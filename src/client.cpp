#include "client.h"
#include "device.h"
#include "sensor.h"
#include "tellduslive.h"
#include "models/devicemodel.h"
#include "models/sensormodel.h"
#include "utils/dev.h"

#include <QApplication>
#include <QTimer>
#include <QDebug>
#include <QJsonDocument>
#include <QJsonObject>
#include <QWebSocket>
#include <QSqlDatabase>
#include <QSqlQuery>

class Client::PrivateData {
public:
	bool online, editable;
	int id;
	QString name, version, type, sessionId;
	QWebSocket webSocket;
};

Client::Client(QObject *parent) :
	QObject(parent)
{
	d = new PrivateData;
	d->online = false;
	d->editable = false;
	d->id = 0;

	connect(QApplication::instance(), SIGNAL(applicationStateChanged(Qt::ApplicationState)), this, SLOT(applicationStateChanged(Qt::ApplicationState)));
	connect(TelldusLive::instance(), SIGNAL(sessionAuthenticated()), this, SLOT(sessionAuthenticated()));

	connect(&d->webSocket, &QWebSocket::connected, this, &Client::wsConnected);
	connect(&d->webSocket, &QWebSocket::disconnected, this, &Client::wsDisconnected);
	connect(&d->webSocket, &QWebSocket::textMessageReceived, this, &Client::wsDataReceived);
	connect(&d->webSocket, &QWebSocket::stateChanged, this, &Client::websocketConnectedChanged);
}

Client::~Client() {
	delete d;
}

bool Client::editable() const {
	return d->editable;
}

void Client::setEditable(bool editable) {
	d->editable = editable;
	emit editableChanged();
	emit saveToCache();
}

int Client::clientId() const {
	return d->id;
}

void Client::setId(int id) {
	d->id = id;
	this->sessionAuthenticated();
	emit idChanged();
	emit saveToCache();
}

QString Client::name() const {
	return d->name;
}

void Client::setName(const QString &name) {
	d->name = name;
	emit nameChanged();
	emit saveToCache();
}

bool Client::online() const {
	return d->online;
}

void Client::setOnline(bool online) {
	d->online = online;
	emit onlineChanged();
	emit saveToCache();
}

QString Client::version() const {
	return d->version;
}

void Client::setVersion(const QString &version) {
	d->version = version;
	emit versionChanged();
	emit saveToCache();
}

QString Client::type() const {
	return d->type;
}

void Client::setType(const QString &type) {
	d->type = type;
	emit typeChanged();
	emit saveToCache();
}

bool Client::websocketConnected() const {
	return d->webSocket.state() == QAbstractSocket::ConnectedState ? true : false;
}

void Client::saveToCache() {
	QSqlDatabase db = QSqlDatabase::database();
	if (db.isOpen()) {
		QSqlQuery query(db);
		query.prepare("REPLACE INTO Client (id, name, online, editable, version, type) VALUES (:id, :name, :online, :editable, :version, :type)");
		query.bindValue(":id", d->id);
		query.bindValue(":name", d->name);
		query.bindValue(":online", d->online);
		query.bindValue(":editable", d->editable);
		query.bindValue(":version", d->version);
		query.bindValue(":type", d->type);
		query.exec();
	}
}

void Client::sessionAuthenticated() {
	qDebug().noquote().nospace() << "[CLIENT:" << d->id << "] Session authenticated";
	if (QApplication::applicationState() == Qt::ApplicationActive) {
		TelldusLive *telldusLive = TelldusLive::instance();
		if (telldusLive->session() == "" || d->id == 0) {
			return;
		}
		// Check to see if we are already connected
		if (d->webSocket.state() == QAbstractSocket::ConnectedState) {
			qDebug().noquote().nospace() << "[CLIENT:" << d->id << ":WEBSOCKET] Already connected";
			return;
		}
		TelldusLiveParams params;
		params["id"] = d->id;
		telldusLive->call("client/serverAddress", params, this, SLOT(addressReceived(QVariantMap)));
	}
}

void Client::addressReceived(const QVariantMap &data) {
	TelldusLiveParams params;
	qDebug().noquote().nospace() << "[CLIENT:" << d->id << "] Websocket address received";
	if (data["address"].toString() == "") {
		qDebug() << "[CLIENT:" << d->id << ":WEBSOCKET] No server to connect to, client offline? Retry in 5 minutes";
		QTimer::singleShot(300000, this, SLOT(sessionAuthenticated()));
		return;
	}
	TelldusLive *telldusLive = TelldusLive::instance();
	d->sessionId = telldusLive->session();
	QString url = QString("ws://%1:%2/websocket").arg(data["address"].toString(), data["port"].toString());
	qDebug().noquote().nospace() << "[CLIENT:" << d->id << ":WEBSOCKET] Connecting to " + url;
	Dev::instance()->logEvent("websocket", "tryConnection", "");

	d->webSocket.open(QUrl(url));
}

void Client::wsConnected() {
	Dev::instance()->logEvent("websocket", "connected", "");
	d->webSocket.sendTextMessage(QString("{\"module\":\"auth\",\"action\":\"auth\",\"data\":{\"sessionid\":\"%1\",\"clientId\":\"%2\"}}").arg(d->sessionId, QString::number(d->id)));
	d->webSocket.sendTextMessage(QString("{\"module\":\"filter\",\"action\":\"accept\",\"data\":{\"module\":\"device\",\"action\":\"setState\"}}"));
	d->webSocket.sendTextMessage(QString("{\"module\":\"filter\",\"action\":\"accept\",\"data\":{\"module\":\"sensor\",\"action\":\"value\"}}"));
}

void Client::wsDataReceived(const QString &string) {
	// Disabled for performance reasons
	// Dev::instance()->logEvent("websocket", "datareceived", "");
	QJsonParseError ok;

	QJsonDocument jsonDocument = QJsonDocument().fromJson(string.toLatin1(), &ok);
	QJsonObject jsonObject = jsonDocument.object();
	QVariantMap msg = jsonObject.toVariantMap();
	if (ok.error != QJsonParseError::NoError) {
		qDebug().noquote().nospace() << "[CLIENT:" << d->id << ":WEBSOCKET:DATA:ERROR] Could not parse json response: " << string;
		return;
	}
	qDebug().noquote().nospace() << "[CLIENT:" << d->id << ":WEBSOCKET:DATA] " << string.toLatin1();
	QVariantMap data = msg["data"].toMap();
	if (msg["module"] == "device" && msg["action"] == "setState") {
		DeviceModel *m = DeviceModel::instance();
		Device *dev = m->findDevice(data["deviceId"].toInt());
		if (dev) {
			dev->setState(data["method"].toInt());
			dev->setStateValue(data["value"].toString());
		}
	} else if (msg["module"] == "sensor" && msg["action"] == "value") {
		SensorModel *m = SensorModel::instance();
		Sensor *sensor = m->findSensor(data["sensorId"].toInt());
		if (sensor) {
			sensor->update(data);
		}
	}
}

void Client::wsDisconnected() {
	Dev::instance()->logEvent("websocket", "disconnected", "");
	qDebug().noquote().nospace() << "[CLIENT:" << d->id << ":WEBSOCKET] Disconnected, retry in 10 seconds";
	QTimer::singleShot(10000, this, SLOT(sessionAuthenticated()));
}

void Client::applicationStateChanged(Qt::ApplicationState state) {
	qDebug().noquote().nospace() << "[CLIENT:" << d->id << "] Application state changed: " + QString::number(state);
	switch (state) {
		case Qt::ApplicationActive:
		Dev::instance()->logEvent("applicationState", "active", "");
		qDebug().noquote().nospace() << "[CLIENT:" << d->id << ":WEBSOCKET] Disconnected, retry now";
		QTimer::singleShot(100, this, SLOT(sessionAuthenticated()));
		break;
	case Qt::ApplicationSuspended:
	case Qt::ApplicationHidden:
		Dev::instance()->logEvent("applicationState", "inactive", "");
		d->webSocket.close();
		QTimer::singleShot(10000, this, SLOT(sessionAuthenticated()));
		break;
	default:
		break;
	}
}

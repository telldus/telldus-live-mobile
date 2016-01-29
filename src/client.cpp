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
	bool hasChanged, online, editable, timezoneAutodetected;
	int id, sunrise, sunset, timezoneOffset;
	QString name, version, type, sessionId, ip, longitude, latitude, timezone, transports;
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
	connect(&d->webSocket, &QWebSocket::stateChanged, this, &Client::wsStateChanged);

	if (TelldusLive::instance()->isAuthorized()) {
		sessionAuthenticated();
	}
}

Client::~Client() {
	delete d;
}

bool Client::editable() const {
	return d->editable;
}

void Client::setEditable(bool editable) {
	if (editable == d->editable) {
		return;
	}
	d->editable = editable;
	emit editableChanged();
	d->hasChanged = true;
	emit saveToCache();

}

int Client::clientId() const {
	return d->id;
}

void Client::setId(int id) {
	if (d->id != id) {
		d->id = id;
		emit idChanged();
		d->hasChanged = true;
		emit saveToCache();
	}
	this->sessionAuthenticated();
}

QString Client::name() const {
	return d->name;
}

void Client::setName(const QString &name) {
	if (name == d->name) {
		return;
	}
	d->name = name;
	emit nameChanged();
	d->hasChanged = true;
	emit saveToCache();
}

bool Client::online() const {
	return d->online;
}

void Client::setOnline(bool online) {
	if (online == d->online) {
		return;
	}
	d->online = online;
	emit onlineChanged();
	d->hasChanged = true;
	emit saveToCache();
}

QString Client::version() const {
	return d->version;
}

void Client::setVersion(const QString &version) {
	if (version == d->version) {
		return;
	}
	d->version = version;
	emit versionChanged();
	d->hasChanged = true;
	emit saveToCache();
}

QString Client::type() const {
	return d->type;
}

void Client::setType(const QString &type) {
	if (type == d->type) {
		return;
	}
	d->type = type;
	emit typeChanged();
	d->hasChanged = true;
	emit saveToCache();
}

QString Client::ip() const {
	return d->ip;
}

QString Client::longitude() const {
	return d->longitude;
}

QString Client::latitude() const {
	return d->latitude;
}

int Client::sunrise() const {
	return d->sunrise;
}

int Client::sunset() const {
	return d->sunset;
}

QString Client::timezone() const {
	return d->timezone;
}

bool Client::timezoneAutodetected() const {
	return d->timezoneAutodetected;
}

int Client::timezoneOffset() const {
	return d->timezoneOffset;
}

QString Client::transports() const {
	return d->transports;
}

void Client::setFromVariantMap(const QVariantMap &dev) {
	if (d->id != dev["id"].toInt()) {
		d->id = dev["id"].toInt();
		emit idChanged();
		d->hasChanged = true;
	}
	if (d->name != dev["name"].toString()) {
		d->name = dev["name"].toString();
		emit nameChanged();
		d->hasChanged = true;
	}
	if (d->online != dev["online"].toBool()) {
		d->online = dev["online"].toBool();
		emit onlineChanged();
		d->hasChanged = true;
	}
	if (d->editable != dev["editable"].toBool()) {
		d->editable = dev["editable"].toBool();
		emit editableChanged();
		d->hasChanged = true;
	}
	if (d->version != dev["version"].toString()) {
		d->version = dev["version"].toString();
		emit versionChanged();
		d->hasChanged = true;
	}
	if (d->type != dev["type"].toString()) {
		d->type = dev["type"].toString();
		emit typeChanged();
		d->hasChanged = true;
	}
	if (d->ip != dev["ip"].toString()) {
		d->ip = dev["ip"].toString();
		emit ipChanged();
		d->hasChanged = true;
	}
	if (d->longitude != dev["longitude"].toString()) {
		d->longitude = dev["longitude"].toString();
		emit longitudeChanged();
		d->hasChanged = true;
	}
	if (d->latitude != dev["latitude"].toString()) {
		d->latitude = dev["latitude"].toString();
		emit latitudeChanged();
		d->hasChanged = true;
	}
	if (d->sunrise != dev["sunrise"].toInt()) {
		d->sunrise = dev["sunrise"].toInt();
		emit sunriseChanged();
		d->hasChanged = true;
	}
	if (d->sunset != dev["sunset"].toInt()) {
		d->sunset = dev["sunset"].toInt();
		emit sunsetChanged();
		d->hasChanged = true;
	}
	if (d->timezone != dev["timezone"].toString()) {
		d->timezone = dev["timezone"].toString();
		emit timezoneChanged();
		d->hasChanged = true;
	}
	if (d->timezoneAutodetected != dev["timezoneAutodetected"].toBool()) {
		d->timezoneAutodetected = dev["timezoneAutodetected"].toBool();
		emit timezoneAutodetectedChanged();
		d->hasChanged = true;
	}
	if (d->timezoneOffset != dev["timezoneOffset"].toInt()) {
		d->timezoneOffset = dev["timezoneOffset"].toInt();
		emit timezoneOffsetChanged();
		d->hasChanged = true;
	}
	if (d->transports != dev["transports"].toString()) {
		d->transports = dev["transports"].toString();
		emit transportsChanged();
		d->hasChanged = true;
	}
	if (dev["fromCache"].toBool() == false) {
		emit saveToCache();
	} else {
		d->hasChanged = false;
	}
}

bool Client::websocketConnected() const {
	return d->webSocket.state() == QAbstractSocket::ConnectedState ? true : false;
}

void Client::saveToCache() {
	qDebug().noquote().nospace() << "[CLIENT:" << d->id << "] Saving to cache (hasChanged = " << d->hasChanged << ")";
	if (d->hasChanged) {
		QSqlDatabase db = QSqlDatabase::database();
		if (db.isOpen()) {
			QSqlQuery query(db);
			query.prepare("REPLACE INTO Client (id, name, online, editable, version, type, ip, longitude, latitude, sunrise, sunset, timezone, timezoneAutodetected, timezoneOffset, transports) VALUES (:id, :name, :online, :editable, :version, :type, :ip, :longitude, :latitude, :sunrise, :sunset, :timezone, :timezoneAutodetected, :timezoneOffset, :transports)");
			query.bindValue(":id", d->id);
			query.bindValue(":name", d->name);
			query.bindValue(":online", d->online);
			query.bindValue(":editable", d->editable);
			query.bindValue(":version", d->version);
			query.bindValue(":type", d->type);
			query.bindValue(":ip", d->ip);
			query.bindValue(":longitude", d->longitude);
			query.bindValue(":latitude", d->latitude);
			query.bindValue(":sunrise", d->sunrise);
			query.bindValue(":sunset", d->sunset);
			query.bindValue(":timezone", d->timezone);
			query.bindValue(":timezoneAutodetected", d->timezoneAutodetected);
			query.bindValue(":timezoneOffset", d->timezoneOffset);
			query.bindValue(":transports", d->transports);
			query.exec();
			qDebug().noquote().nospace() << "[CLIENT:" << d->id << "] Saved to cache";
			d->hasChanged = false;
		}
	}
}

void Client::sessionAuthenticated() {
	qDebug().noquote().nospace() << "[CLIENT:" << d->id << "] Session authenticated";
	if (QApplication::applicationState() == Qt::ApplicationActive) {
		TelldusLive *telldusLive = TelldusLive::instance();
		if (telldusLive->session() == "" || d->id == 0) {
			qDebug().noquote().nospace() << "[CLIENT:" << d->id << "] Session doesn't seem to be authenticated, retry in 5 seconds";
			QTimer::singleShot(5000, this, SLOT(sessionAuthenticated()));
			return;
		}
		// Check to see if we are already connected
		if (d->webSocket.state() == QAbstractSocket::ConnectedState) {
			if (d->webSocket.state() == QAbstractSocket::ClosingState) {
				qDebug().noquote().nospace() << "[CLIENT:" << d->id << "] Socket closing, retry in 3 seconds";
				QTimer::singleShot(3000, this, SLOT(sessionAuthenticated()));
				return;
			}
			qDebug().noquote().nospace() << "[CLIENT:" << d->id << "] Already connected";
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
		qDebug().noquote().nospace() << "[CLIENT:" << d->id << "] No server to connect to, client offline? Retry in 5 minutes";
		QTimer::singleShot(300000, this, SLOT(sessionAuthenticated()));
		return;
	}
	TelldusLive *telldusLive = TelldusLive::instance();
	d->sessionId = telldusLive->session();
	QString url = QString("ws://%1:%2/websocket").arg(data["address"].toString(), data["port"].toString());
	qDebug().noquote().nospace() << "[CLIENT:" << d->id << "] Connecting to " + url;
	Dev::instance()->logEvent("websocket", "tryConnection", "");

	qDebug().noquote().nospace() << "[CLIENT:" << d->id << "] Websocket object state: " << d->webSocket.state();
	if (d->webSocket.state() == QAbstractSocket::UnconnectedState) {
		d->webSocket.open(QUrl(url));
	} else {
		qDebug().noquote().nospace() << "[CLIENT:" << d->id << "] Already connected or connecting";
	}
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
	qDebug().noquote().nospace() << "[CLIENT:" << d->id << "] Disconnected, retry in 10 seconds";
	QTimer::singleShot(10000, this, SLOT(sessionAuthenticated()));
}

void Client::wsStateChanged(QAbstractSocket::SocketState state) {
	qDebug().noquote().nospace() << "[CLIENT:" << d->id << "] State Changed: " << state;
	emit websocketConnectedChanged();
}

void Client::applicationStateChanged(Qt::ApplicationState state) {
	qDebug().noquote().nospace() << "[CLIENT:" << d->id << "] Application state changed: " + QString::number(state);
	switch (state) {
		case Qt::ApplicationActive:
		Dev::instance()->logEvent("applicationState", "active", "");
		qDebug().noquote().nospace() << "[CLIENT:" << d->id << "] Disconnected, retry now";
		this->sessionAuthenticated();
		break;
	case Qt::ApplicationSuspended:
	case Qt::ApplicationInactive:
	case Qt::ApplicationHidden:
		Dev::instance()->logEvent("applicationState", "inactive", "");
		d->webSocket.close();
		QTimer::singleShot(10000, this, SLOT(sessionAuthenticated()));
		break;
	default:
		break;
	}
}

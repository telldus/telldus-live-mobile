#include "client.h"
#include "tellduslive.h"
#include "devicemodel.h"
#include "device.h"
#include "sensormodel.h"
#include "sensor.h"

#include <QApplication>
#include <QTimer>
#include <QDebug>
#include <QJsonDocument>
#include <QJsonObject>

class Client::PrivateData {
public:
	bool online, editable;
	int id;
	QString name, version, type, sessionId;
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
	connect(&m_webSocket, &QWebSocket::connected, this, &Client::wsConnected);
	connect(&m_webSocket, &QWebSocket::disconnected, this, &Client::wsDisconnected);
	connect(&m_webSocket, &QWebSocket::textMessageReceived, this, &Client::wsDataReceived);

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
}

int Client::clientId() const {
	return d->id;
}

void Client::setId(int id) {
	d->id = id;
	this->sessionAuthenticated();
	emit idChanged();
}

QString Client::name() const {
	return d->name;
}

void Client::setName(const QString &name) {
	d->name = name;
	emit nameChanged();
}

bool Client::online() const {
	return d->online;
}

void Client::setOnline(bool online) {
	d->online = online;
	emit onlineChanged();
}

QString Client::version() const {
	return d->version;
}

void Client::setVersion(const QString &version) {
	d->version = version;
	emit versionChanged();
}

QString Client::type() const {
	return d->type;
}

void Client::setType(const QString &type) {
	d->type = type;
	emit typeChanged();
}

void Client::sessionAuthenticated() {
	qDebug() << "Client::sessionAuthenticated";
    if (QApplication::applicationState() == Qt::ApplicationActive) {
		TelldusLive *telldusLive = TelldusLive::instance();
		if (telldusLive->session() == "" || d->id == 0) {
			return;
		}
		// Check to see if we are already connected
		if (m_webSocket.state() == QAbstractSocket::ConnectedState) {
			qDebug() << "Websocket already connected";
			return;
		}
		TelldusLiveParams params;
		params["id"] = d->id;
		telldusLive->call("client/serverAddress", params, this, SLOT(addressReceived(QVariantMap)));
	}
}

void Client::addressReceived(const QVariantMap &data) {
	qDebug() << "Client::addressReceived";
	if (data["address"].toString() == "") {
		qDebug() << "No server to connect to, client offline? Retry in 5 minutes";
		QTimer::singleShot(300000, this, SLOT(sessionAuthenticated()));
		return;
	}
	TelldusLive *telldusLive = TelldusLive::instance();
	d->sessionId = telldusLive->session();
	QString url = QString("ws://%1:%2/websocket").arg(data["address"].toString(), data["port"].toString());
	qDebug() << "-- Connecting to " + url;
	m_webSocket.open(QUrl(url));
}

void Client::wsConnected() {
	m_webSocket.sendTextMessage(QString("{\"module\":\"auth\",\"action\":\"auth\",\"data\":{\"sessionid\":\"%1\",\"clientId\":\"%2\"}}").arg(d->sessionId, QString::number(d->id)));
	m_webSocket.sendTextMessage(QString("{\"module\":\"filter\",\"action\":\"accept\",\"data\":{\"module\":\"device\",\"action\":\"setState\"}}"));
	m_webSocket.sendTextMessage(QString("{\"module\":\"filter\",\"action\":\"accept\",\"data\":{\"module\":\"sensor\",\"action\":\"value\"}}"));
}

void Client::wsDataReceived(const QString &string) {
	qDebug() << "Websocket data received";
	QJsonParseError ok;

	QJsonDocument jsonDocument = QJsonDocument().fromJson(string.toLatin1(), &ok);
    QJsonObject jsonObject = jsonDocument.object();
    QVariantMap msg = jsonObject.toVariantMap();
    if (ok.error != QJsonParseError::NoError) {
		qWarning() << "Could not parse json response";
		qWarning() << string;
		return;
	}
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
	qDebug() << "Websocket disconnected, retry in 10 seconds";
	QTimer::singleShot(10000, this, SLOT(sessionAuthenticated()));
}

void Client::applicationStateChanged(Qt::ApplicationState state) {
	qDebug() << "Client::applicationStateChanged(" + QString::number(state) + ")";
	switch (state) {
        case Qt::ApplicationActive:
		qDebug() << "Websocket disconnected, retry now";
		QTimer::singleShot(100, this, SLOT(sessionAuthenticated()));
		break;
	case Qt::ApplicationSuspended:
    case Qt::ApplicationHidden:
        m_webSocket.close();
		QTimer::singleShot(10000, this, SLOT(sessionAuthenticated()));
		break;
	default:
		break;
	}
}

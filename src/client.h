#ifndef CLIENT_H
#define CLIENT_H

#include <QObject>
#include <QMetaType>
#include <QVariantMap>
#include <QDateTime>
#include <QAbstractSocket>

class Client : public QObject
{
	Q_OBJECT
	Q_PROPERTY(bool editable READ editable NOTIFY editableChanged)
	Q_PROPERTY(int id READ clientId NOTIFY idChanged)
	Q_PROPERTY(QString name READ name NOTIFY nameChanged)
	Q_PROPERTY(bool online READ online NOTIFY onlineChanged)
	Q_PROPERTY(QString version READ version NOTIFY versionChanged)
	Q_PROPERTY(QString type READ type NOTIFY typeChanged)
	Q_PROPERTY(QString sessionId READ name NOTIFY nameChanged)
	Q_PROPERTY(QString ip READ ip NOTIFY ipChanged)
	Q_PROPERTY(QString longitude READ longitude NOTIFY longitudeChanged)
	Q_PROPERTY(QString latitude READ latitude NOTIFY latitudeChanged)
	Q_PROPERTY(int sunrise READ sunrise NOTIFY sunriseChanged)
	Q_PROPERTY(int sunset READ sunset NOTIFY sunsetChanged)
	Q_PROPERTY(QTime sunriseTime READ sunriseTime NOTIFY sunriseTimeChanged)
	Q_PROPERTY(QTime sunsetTime READ sunsetTime NOTIFY sunsetTimeChanged)
	Q_PROPERTY(QString timezone READ timezone NOTIFY timezoneChanged)
	Q_PROPERTY(bool timezoneAutodetected READ timezoneAutodetected NOTIFY timezoneAutodetectedChanged)
	Q_PROPERTY(int timezoneOffset READ timezoneOffset NOTIFY timezoneOffsetChanged)
	Q_PROPERTY(QString transports READ transports NOTIFY transportsChanged)
	Q_PROPERTY(bool websocketConnected READ websocketConnected NOTIFY websocketConnectedChanged)
public:
	explicit Client(QObject *parent = 0);
	~Client();

	bool editable() const;
	void setEditable(bool editable);

	int clientId() const;
	void setId(int id);

	QString name() const;
	void setName(const QString &name);

	bool online() const;
	void setOnline(bool online);

	QString version() const;
	void setVersion(const QString &version);

	QString type() const;
	void setType(const QString &type);

	QString ip() const;
	QString longitude() const;
	QString latitude() const;
	int sunrise() const;
	int sunset() const;
	QTime sunriseTime() const;
	QTime sunsetTime() const;
	QString timezone() const;
	bool timezoneAutodetected() const;
	int timezoneOffset() const;
	QString transports() const;

	void setFromVariantMap(const QVariantMap &dev);

	bool websocketConnected() const;

signals:
	void editableChanged();
	void idChanged();
	void nameChanged();
	void onlineChanged();
	void versionChanged();
	void typeChanged();
	void ipChanged();
	void longitudeChanged();
	void latitudeChanged();
	void sunriseChanged();
	void sunsetChanged();
	void sunriseTimeChanged();
	void sunsetTimeChanged();
	void timezoneChanged();
	void timezoneAutodetectedChanged();
	void timezoneOffsetChanged();
	void transportsChanged();
	void websocketConnectedChanged();

private slots:
	void sessionAuthenticated();
	void addressReceived(const QVariantMap &data);
	void wsConnected();
	void wsDataReceived(const QString &string);
	void wsDisconnected();
	void wsStateChanged(QAbstractSocket::SocketState);
	void applicationStateChanged(Qt::ApplicationState state);
	void saveToCache();

private:
	class PrivateData;
	PrivateData *d;
};

Q_DECLARE_METATYPE(Client*)

#endif // CLIENT_H

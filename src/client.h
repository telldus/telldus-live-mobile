#ifndef CLIENT_H
#define CLIENT_H

#include <QObject>
#include <QMetaType>
#include <QVariantMap>
#include <QDateTime>
#include <QtWebSockets/QWebSocket>

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
	Q_PROPERTY(QString clientId READ name NOTIFY nameChanged)
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

signals:
	void editableChanged();
	void idChanged();
	void nameChanged();
	void onlineChanged();
	void versionChanged();
	void typeChanged();

private slots:
	void sessionAuthenticated();
	void addressReceived(const QVariantMap &data);
	void wsConnected();
	void wsDataReceived(const QString &string);
	void wsDisconnected();
	void applicationStateChanged(Qt::ApplicationState state);

private:
	class PrivateData;
	PrivateData *d;
	QWebSocket m_webSocket;

};

Q_DECLARE_METATYPE(Client*)

#endif // CLIENT_H

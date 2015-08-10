#ifndef TELLDUSLIVE_H
#define TELLDUSLIVE_H

#include <QObject>
#include <QUrl>
#include <QJSValue>
#include <QMap>
#include <QVariant>

typedef QMap<QString, QVariant> TelldusLiveParams;

class TelldusLive : public QObject
{
	Q_OBJECT
	Q_PROPERTY(bool isAuthorized READ isAuthorized NOTIFY authorizedChanged)
	Q_PROPERTY(bool working READ working NOTIFY workingChanged)
public:
	~TelldusLive();

	bool isAuthorized();
	void call(const QString &endpoint, const TelldusLiveParams &params, QObject * receiver, const char * member, const QVariantMap &extra = QVariantMap());
	QString session() const;
	bool working() const;
	void setupManager();

	static TelldusLive *instance();

signals:
	void authorizedChanged();
	void sessionAuthenticated();
	void authorizationNeeded(const QUrl &url);
	void workingChanged();
	void pushTokenChanged(QString token);

public slots:
	void authorize();
	void call(const QString &endpoint, const QJSValue &params, const QJSValue &expression);
	void logout();
	void registerPushTokenWithApi(const QString &phone_id, const QString &name, const QString &manufacturer, const QString &model, const QString &os_version);

private slots:
	void onUrlOpened(const QUrl &url);
	void authenticateSession();
	void onTemporaryTokenReceived(const QString &token, const QString &tokenSecret);
	void onAuthorizationReceived(const QString &token, const QString &verifier);
	void onAccessTokenReceived(const QString &token, const QString &tokenSecret);
	void onRequestReady(const QByteArray &response);
	void onSessionAuthenticated(const QVariantMap &data);
	void registerPushTokenWithApiCallback(const QVariantMap &data);

private:
	explicit TelldusLive(QObject *parent = 0);
	void doCall();
	void registerForPush();
#ifdef PLATFORM_IOS
	void updateWatchData();
#endif
	class PrivateData;
	PrivateData *d;
};

#endif // TELLDUSLIVE_H

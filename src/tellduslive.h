#ifndef TELLDUSLIVE_H
#define TELLDUSLIVE_H

#include <QObject>
#include <QUrl>
#include <QJSValue>
#include <QMap>
#include <QVariant>
#include <QNetworkReply>
#include "config.h"

typedef QMap<QString, QVariant> TelldusLiveParams;

class TelldusLive : public QObject
{
	Q_OBJECT
	Q_PROPERTY(int queueLength READ queueLength NOTIFY queueLengthChanged)
	Q_PROPERTY(bool isAuthorized READ isAuthorized NOTIFY authorizedChanged)
	Q_PROPERTY(bool working READ working NOTIFY workingChanged)
public:
	~TelldusLive();

	int queueLength();
	bool isAuthorized();
	void call(const QString &endpoint, const TelldusLiveParams &params, QObject * receiver, const char * member, const QVariantMap &extra = QVariantMap(), const int priority = 100, const int objectType = 0, const int objectId = -1);
	QString session() const;
	bool working() const;
	void setupManager();

	static TelldusLive *instance();

signals:
	void queueLengthChanged();
	void authorizedChanged();
	void sessionAuthenticated();
	void authorizationNeeded(const QUrl &url);
	void authorizationAborted();
	void authorizationGranted();
	void workingChanged();
	void itemDequeued(const int &objectType, const int &objectId);

#if IS_FEATURE_PUSH_ENABLED
	void pushTokenChanged(QString token);
#endif

public slots:
	void authorize();
	void call(const QString &endpoint, const QJSValue &params, const QJSValue &expression);
	void logout();
#if IS_FEATURE_PUSH_ENABLED
	void submitPushToken();
#endif
	void authenticateSession();

private slots:
	void onUrlOpened(const QUrl &url);
	void onTemporaryTokenReceived(const QString &token, const QString &tokenSecret);
	void onAuthorizationReceived(const QString &token, const QString &verifier);
	void onAccessTokenReceived(const QString &token, const QString &tokenSecret);
	void onRequestReady(const QByteArray &response, QNetworkReply *reply);
	void onSessionAuthenticated(const QVariantMap &data);
	void onNetworkAccessibleChanged(const bool isOnline);

private:
	explicit TelldusLive(QObject *parent = 0);
	void doCall();
#if IS_FEATURE_PUSH_ENABLED
	void registerForPush();
#endif
	class PrivateData;
	PrivateData *d;
};

#endif // TELLDUSLIVE_H

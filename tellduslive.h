#ifndef TELLDUSLIVE_H
#define TELLDUSLIVE_H

#include <QObject>
#include <QUrl>
#include <QScriptValue>

typedef QMap<QString, QVariant> TelldusLiveParams;

class TelldusLive : public QObject
{
	Q_OBJECT
	Q_PROPERTY(bool isAuthorized READ isAuthorized NOTIFY authorizedChanged)
public:
	~TelldusLive();

	bool isAuthorized();
	void call(const QString &endpoint, const TelldusLiveParams &params, QObject * receiver, const char * member);

	static TelldusLive *instance();

signals:
	void authorizedChanged();
	void authorizationNeeded(const QUrl &url);

public slots:

	void authorize();
	void call(const QString &endpoint, const QScriptValue &params, const QScriptValue &expression);
	void logout();

private slots:
	void onTemporaryTokenReceived(const QString &token, const QString &tokenSecret);
	void onAuthorizationReceived(const QString &token, const QString &verifier);
	void onAccessTokenReceived(const QString &token, const QString &tokenSecret);
	void onRequestReady(const QByteArray &response);

private:
	explicit TelldusLive(QObject *parent = 0);
	void doCall();
	void setupManager();
	class PrivateData;
	PrivateData *d;
};

#endif // TELLDUSLIVE_H

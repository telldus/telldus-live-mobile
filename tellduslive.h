#ifndef TELLDUSLIVE_H
#define TELLDUSLIVE_H

#include <QObject>
#include <QUrl>
#include <QScriptValue>

class TelldusLive : public QObject
{
	Q_OBJECT
	Q_PROPERTY(bool isAuthorized READ isAuthorized NOTIFY authorizedChanged)
public:
	explicit TelldusLive(QObject *parent = 0);

	~TelldusLive();

	bool isAuthorized();

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
	void doCall();
	class PrivateData;
	PrivateData *d;
};

#endif // TELLDUSLIVE_H

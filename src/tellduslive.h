#ifndef TELLDUSLIVE_H
#define TELLDUSLIVE_H

#include <QObject>
#include <QUrl>
#include <QScriptValue>
#include <QMap>
#include <QVariant>

#ifdef PLATFORM_BB10
#include <bb/system/InvokeManager>
#endif

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
	bool working() const;

	static TelldusLive *instance();

signals:
	void authorizedChanged();
	void authorizationNeeded(const QUrl &url);
	void workingChanged();

public slots:

	void authorize();
	void call(const QString &endpoint, const QScriptValue &params, const QScriptValue &expression);
	void logout();

protected:
	bool eventFilter(QObject *obj, QEvent *event);

private slots:
	void onTemporaryTokenReceived(const QString &token, const QString &tokenSecret);
	void onAuthorizationReceived(const QString &token, const QString &verifier);
	void onAccessTokenReceived(const QString &token, const QString &tokenSecret);
	void onRequestReady(const QByteArray &response);
#ifdef PLATFORM_BB10
	void handleInvoke(const bb::system::InvokeRequest&);
#endif


private:
	explicit TelldusLive(QObject *parent = 0);
	void doCall();
	void setupManager();
	class PrivateData;
	PrivateData *d;
};

#endif // TELLDUSLIVE_H

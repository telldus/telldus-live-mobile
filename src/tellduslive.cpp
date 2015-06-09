#include <QtKOAuth>
#include <QSettings>
#include <QJSEngine>
#include <QQueue>
#include <QMetaMethod>
#include <QApplication>
#include <QDesktopServices>
#include <QSslSocket>
#include <QUrlQuery>
#include <QJsonDocument>
#include <QUuid>
#include <QDebug>
#include <QTimer>
#include <QDateTime>

#include "config.h"
#include "tellduslive.h"
#ifdef PLATFORM_BB10
#include <bb/system/InvokeRequest>
#endif

class TelldusLiveCall {
public:
	QString endpoint;
	KQOAuthParameters params;
	QJSValue callback;
	QJSValue thisObject;
	QObject *receiver;
	QByteArray member;
	QVariantMap extra;
};

class TelldusLive::PrivateData {
public:
	enum State { Unauthorized, AuthorizationPending, Authorized };
	State state;
	KQOAuthManager *manager;
	KQOAuthRequest *request;
	QString base, session;
	QQueue<TelldusLiveCall> queue;
	bool requestPending, sessionIsAuthenticated;
	QDateTime ttl;
#ifdef PLATFORM_BB10
	bb::system::InvokeManager *m;
#endif
	static TelldusLive *instance;
};

TelldusLive *TelldusLive::PrivateData::instance = 0;

TelldusLive::TelldusLive(QObject *parent) :
	QObject(parent)
{
	d = new PrivateData;
	d->manager = 0;
	d->request = 0;
	d->requestPending = false;
	d->sessionIsAuthenticated = false;

	d->base = TELLDUS_LIVE_API_ENDPOINT;

//	QSslSocket::addDefaultCaCertificates(":/Equifax_Secure_CA.pem");
//	QSslSocket::addDefaultCaCertificates(":/GeoTrustGlobalCA.pem");
//	QSslSocket::addDefaultCaCertificates(":/RapidSSLCA.pem");

	QSettings s;
	QString token = s.value("oauthToken", "").toString();
	QString tokenSecret = s.value("oauthTokenSecret", "").toString();

	QStringList args = QCoreApplication::arguments();
	for(int i = 1; i < args.length(); ++i) {
		if (args.at(i) == "--oauthToken") {
			token = args.at(i+1);
			++i;
			continue;
		} else if (args.at(i) == "--oauthTokenSecret") {
			tokenSecret = args.at(i+1);
			++i;
			continue;
		}
	}
	if (token.isEmpty() || tokenSecret.isEmpty()) {
		d->state = PrivateData::Unauthorized;
	} else {
		d->state = PrivateData::Authorized;
	}
	d->session = s.value("session", "").toString();

	QDesktopServices::setUrlHandler("x-com-telldus-live-mobile", this, "onUrlOpened");

#ifdef PLATFORM_BB10
	d->m = new bb::system::InvokeManager(this);
	connect(d->m, SIGNAL(invoked(const bb::system::InvokeRequest&)), this, SLOT(handleInvoke(const bb::system::InvokeRequest&)));
#endif

	this->setupManager();
}

void TelldusLive::authenticateSession() {
	if (d->session == "") {
		QSettings s;
		d->session = QUuid::createUuid().toString().mid(1, 36);
		s.setValue("session", d->session);
	}
	TelldusLiveParams params;
	params["session"] = d->session;
	qDebug() << d->session;
	this->call("user/authenticateSession", params, this, SLOT(onSessionAuthenticated(QVariantMap)));
}

TelldusLive::~TelldusLive() {
	delete d;
}

#ifdef PLATFORM_BB10
void TelldusLive::handleInvoke(const bb::system::InvokeRequest &r) {
	QMultiMap<QString, QString> queryParams;
	QString token = r.uri().queryItemValue("oauth_token");
	QString verifier = r.uri().queryItemValue("oauth_verifier");
	d->manager->verifyToken(token, verifier);
}
#endif

void TelldusLive::authorize() {
	d->requestPending = true;
	emit workingChanged();

	d->request->initRequest(KQOAuthRequest::TemporaryCredentials, QUrl(d->base + "/oauth/requestToken"));
	d->request->setConsumerKey(TELLDUS_LIVE_PUBLIC_KEY);
	d->request->setConsumerSecretKey(TELLDUS_LIVE_PRIVATE_KEY);
	d->request->setCallbackUrl(QUrl("x-com-telldus-live-mobile://success"));

#if HAVE_WEBKIT
	d->manager->setHandleUserAuthorization(true);
#else
	d->manager->setHandleUserAuthorization(false);
#endif
	d->manager->executeRequest(d->request);

}

void TelldusLive::onTemporaryTokenReceived(const QString &token, const QString &tokenSecret) {
	Q_UNUSED(tokenSecret);
	if( d->manager->lastError() != KQOAuthManager::NoError) {
		return;
	}

	QUrl userAuthURL(d->base + "/oauth/authorize");
	QUrlQuery query;
	query.addQueryItem("oauth_token", token);
	userAuthURL.setQuery(query);
	emit authorizationNeeded(userAuthURL);
}

void TelldusLive::onAuthorizationReceived(const QString &token, const QString &verifier) {
	Q_UNUSED(token);
	Q_UNUSED(verifier);
	if (!d->manager->isVerified()) {
		qDebug() << "The user did not authorized this application, abort";
		return;
	}
	d->manager->getUserAccessTokens(QUrl(d->base + "/oauth/accessToken"));
}

void TelldusLive::onAccessTokenReceived(const QString &token, const QString &tokenSecret) {
	QSettings s;
	s.setValue("oauthToken", token);
	s.setValue("oauthTokenSecret", tokenSecret);
	//We cannot emit the signal here since more will happen when this function ends.
	//Wait for onRequestReady instead
	d->state = PrivateData::AuthorizationPending;
	d->requestPending = false;
	emit workingChanged();
}

void TelldusLive::onRequestReady(const QByteArray &response) {
	if (d->state == PrivateData::AuthorizationPending) {
		d->state = PrivateData::Authorized;
		this->authenticateSession();
		emit authorizedChanged();
		return;
	}
	if (!d->requestPending) {
		//Probably during authorization
		return;
	}

	if (d->queue.length() == 0) {
		qWarning() << "No pending call, should not happen!";
		return;
	}

	TelldusLiveCall call(d->queue.dequeue());

	//Start next call before parse
	if (d->queue.count()) {
		this->doCall();
	} else {
		d->requestPending = false;
		emit workingChanged();
	}

	if (!call.callback.isUndefined() && !call.receiver) {
		// Callback not valid, no need to parse response
		return;
	}

	QJsonParseError error;
	QJsonDocument json(QJsonDocument::fromJson(response, &error));
	QVariantMap result = json.toVariant().toMap();
	if (error.error != QJsonParseError::NoError) {
		qDebug() << "Could not parse json response from" << call.endpoint;
		qDebug() << error.errorString();
		qDebug() << response;
		return;
	}

	if (call.receiver) {
		QByteArray normalizedSignature = QMetaObject::normalizedSignature(call.member.mid(1).constData());
		int methodIndex = call.receiver->metaObject()->indexOfMethod(normalizedSignature);
		QMetaMethod method = call.receiver->metaObject()->method(methodIndex);
		method.invoke(call.receiver, Qt::QueuedConnection, Q_ARG(QVariantMap, result), Q_ARG(QVariantMap, call.extra));
	} else {
		QJSValue parameters = call.callback.engine()->toScriptValue(result);
		QJSValue result = call.callback.callWithInstance(call.thisObject, QJSValueList() << parameters);
		if (result.isError()) {
			qDebug() << result.toString();
		}
	}
}

void TelldusLive::onSessionAuthenticated(const QVariantMap &data) {
	if (data["status"] != "success") {
		qWarning() << "Could not authenticate websockets";
		return;
	}
	d->sessionIsAuthenticated = true;
	d->ttl = QDateTime::fromMSecsSinceEpoch((qint64)data["ttl"].toInt()*1000);
	qint64 msecs = QDateTime::currentDateTime().msecsTo(d->ttl);
	msecs -= 15*60*1000;  // 15 minutes to be sure
	QTimer::singleShot(msecs, this, SLOT(authenticateSession()));  // Renew the session
	emit sessionAuthenticated();
}

bool TelldusLive::isAuthorized() {
	return d->state == PrivateData::Authorized;
}

void TelldusLive::call(const QString &endpoint, const QJSValue &params, const QJSValue &expression) {
	qDebug() << "Queue call to" << endpoint;

	TelldusLiveCall call;
	call.receiver = 0;

	if (expression.isCallable()) {
		call.callback = expression;

		QJSEngine *eng = expression.engine();
		if (eng) {
			// Try determin if we have a forth parameter
			// TODO(micke): We need to figure out how this is done in Qt5
			/*QScriptContext *ctx = eng->currentContext();
			if (ctx->argumentCount() >= 4) {
				call.thisObject = ctx->argument(3);
			}*/
		}
	}
	call.endpoint = endpoint;

	if (params.isObject()) {
		QMap<QString, QVariant> paramsMap = params.toVariant().toMap();
		for(QMap<QString, QVariant>::const_iterator it = paramsMap.constBegin(); it != paramsMap.constEnd(); ++it) {
			call.params.insert(it.key(), it.value().toString());
		}

	}
	d->queue.enqueue(call);
	if (!d->requestPending) {
		this->doCall();
	}
}

void TelldusLive::call(const QString &endpoint, const TelldusLiveParams &params, QObject * receiver, const char * member, const QVariantMap &extra) {
	qDebug() << "Queue call to" << endpoint;

	TelldusLiveCall call;
	call.endpoint = endpoint;
	call.receiver = receiver;
	call.member = member;
	call.extra = extra;

	for(QMap<QString, QVariant>::const_iterator it = params.constBegin(); it != params.constEnd(); ++it) {
		call.params.insert(it.key(), it.value().toString());
	}

	d->queue.enqueue(call);
	if (!d->requestPending) {
		this->doCall();
	}
}

QString TelldusLive::session() const {
	if (d->sessionIsAuthenticated) {
		return d->session;
	}
	return "";
}

bool TelldusLive::working() const {
	return d->requestPending;
}


void TelldusLive::logout() {
	QSettings s;
	s.setValue("oauthToken", "");
	s.setValue("oauthTokenSecret", "");
	d->state = PrivateData::Unauthorized;
	d->sessionIsAuthenticated = false;
	this->setupManager();
	emit authorizedChanged();
}

void TelldusLive::onUrlOpened(const QUrl &url) {
	if (url.scheme() != "x-com-telldus-live-mobile") {
		return;
	}
	QMultiMap<QString, QString> queryParams;
	QUrlQuery query(url);
	QString token = query.queryItemValue("oauth_token");
	QString verifier = query.queryItemValue("oauth_verifier");
	d->manager->verifyToken(token, verifier);
}

void TelldusLive::doCall() {
	d->requestPending = true;
	emit workingChanged();
	TelldusLiveCall call(d->queue.head());
	qDebug() << "Calling" << call.endpoint;

	QSettings s;
	QString token = s.value("oauthToken", "").toString();
	QString tokenSecret = s.value("oauthTokenSecret", "").toString();
	QStringList args = QCoreApplication::arguments();
	for(int i = 1; i < args.length(); ++i) {
		if (args.at(i) == "--oauthToken") {
			token = args.at(i+1);
			++i;
			continue;
		} else if (args.at(i) == "--oauthTokenSecret") {
			tokenSecret = args.at(i+1);
			++i;
			continue;
		}
	}
	d->request->initRequest(KQOAuthRequest::AuthorizedRequest, QUrl(d->base + "/json/" + call.endpoint));
	d->request->setConsumerKey(TELLDUS_LIVE_PUBLIC_KEY);
	d->request->setConsumerSecretKey(TELLDUS_LIVE_PRIVATE_KEY);
	d->request->setToken(token);
	d->request->setTokenSecret(tokenSecret);
	d->request->setHttpMethod(KQOAuthRequest::GET);

	d->request->setAdditionalParameters(call.params);

	d->manager->executeRequest(d->request);
}

void TelldusLive::setupManager() {
	if (d->manager) {
		delete d->manager;
	}
	if (d->request) {
		delete d->request;
	}
	d->manager = new KQOAuthManager(this);
	connect(d->manager, SIGNAL(temporaryTokenReceived(QString,QString)), this, SLOT(onTemporaryTokenReceived(QString, QString)));
	connect(d->manager, SIGNAL(authorizationReceived(QString,QString)), this, SLOT( onAuthorizationReceived(QString, QString)));
	connect(d->manager, SIGNAL(accessTokenReceived(QString,QString)), this, SLOT(onAccessTokenReceived(QString,QString)));
	connect(d->manager, SIGNAL(requestReady(QByteArray)), this, SLOT(onRequestReady(QByteArray)));

	d->request = new KQOAuthRequest(this);

	if (d->state == PrivateData::Authorized) {
		this->authenticateSession();
	}
}

TelldusLive * TelldusLive::instance() {
	if (PrivateData::instance == 0) {
		PrivateData::instance = new TelldusLive();
	}
	return PrivateData::instance;
}

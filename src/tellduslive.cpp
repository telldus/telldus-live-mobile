#include "tellduslive.h"
#include "config.h"

#include <QtKOAuth>
#include "json.h"
#include <QSettings>
#include <QScriptEngine>
#include <QQueue>
#include <QMetaMethod>
#include <QApplication>
#include <QFileOpenEvent>
#include <QDebug>

#ifdef PLATFORM_BB10
#include <bb/system/InvokeRequest>
#endif

class TelldusLiveCall {
public:
	QString endpoint;
	KQOAuthParameters params;
	QScriptValue callback;
	QScriptValue thisObject;
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
	QString base;
	QQueue<TelldusLiveCall> queue;
	bool requestPending;
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
	d->base = "https://api.telldus.com";

	QSettings s;
	QString token = s.value("oauthToken", "").toString();
	QString tokenSecret = s.value("oauthTokenSecret", "").toString();
	if (token.isEmpty() || tokenSecret.isEmpty()) {
		d->state = PrivateData::Unauthorized;
	} else {
		d->state = PrivateData::Authorized;
	}

	qApp->installEventFilter(this);

#ifdef PLATFORM_BB10
	d->m = new bb::system::InvokeManager(this);
	connect(d->m, SIGNAL(invoked(const bb::system::InvokeRequest&)), this, SLOT(handleInvoke(const bb::system::InvokeRequest&)));
#endif

	this->setupManager();
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
	userAuthURL.addQueryItem("oauth_token", token);
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

	if (!call.callback.isValid() && !call.receiver) {
		//Callback not valid, no need to parse response
		return;
	}

	bool ok;
	QVariantMap result = Json::parse(response, ok).toMap();
	if (!ok) {
		qDebug() << "Could not parse json response from" << call.endpoint;
		qDebug() << response;
		return;
	}

	if (call.receiver) {
		QByteArray normalizedSignature = QMetaObject::normalizedSignature(call.member.mid(1).constData());
		int methodIndex = call.receiver->metaObject()->indexOfMethod(normalizedSignature);
		QMetaMethod method = call.receiver->metaObject()->method(methodIndex);
		method.invoke(call.receiver, Qt::QueuedConnection, Q_ARG(QVariantMap, result), Q_ARG(QVariantMap, call.extra));
	} else {
		QScriptValue parameters = call.callback.engine()->toScriptValue(result);
		call.callback.call(call.thisObject, QScriptValueList() << parameters);
		if (call.callback.engine()->hasUncaughtException()) {
			qDebug() << call.callback.engine()->uncaughtException().toString();
		}
	}
}

bool TelldusLive::isAuthorized() {
	return d->state == PrivateData::Authorized;
}

void TelldusLive::call(const QString &endpoint, const QScriptValue &params, const QScriptValue &expression) {
	qDebug() << "Queue call to" << endpoint;

	TelldusLiveCall call;
	call.receiver = 0;

	if (expression.isFunction()) {
		call.callback = expression;

		QScriptEngine *eng = expression.engine();
		if (eng) {
			//Try determin if we have a forth parameter
			QScriptContext *ctx = eng->currentContext();
			if (ctx->argumentCount() >= 4) {
				call.thisObject = ctx->argument(3);
			}
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

bool TelldusLive::working() const {
	return d->requestPending;
}


void TelldusLive::logout() {
	QSettings s;
	s.setValue("oauthToken", "");
	s.setValue("oauthTokenSecret", "");
	d->state = PrivateData::Unauthorized;
	this->setupManager();
	emit authorizedChanged();
}

bool TelldusLive::eventFilter(QObject *obj, QEvent *event) {
	if (event->type() == QEvent::FileOpen) {
		QFileOpenEvent *fileOpenEvent = static_cast<QFileOpenEvent *>(event);
		QUrl url = fileOpenEvent->url();
		if (url.scheme() != "x-com-telldus-live-mobile") {
			return QObject::eventFilter(obj, event);
		}
		QMultiMap<QString, QString> queryParams;
		QString token = url.queryItemValue("oauth_token");
		QString verifier = url.queryItemValue("oauth_verifier");
		d->manager->verifyToken(token, verifier);
		return true;
	}
	return QObject::eventFilter(obj, event);
}

void TelldusLive::doCall() {
	d->requestPending = true;
	emit workingChanged();
	TelldusLiveCall call(d->queue.head());
	qDebug() << "Calling" << call.endpoint;

	QSettings s;
	QString token = s.value("oauthToken", "").toString();
	QString tokenSecret = s.value("oauthTokenSecret", "").toString();

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
}

TelldusLive * TelldusLive::instance() {
	if (PrivateData::instance == 0) {
		PrivateData::instance = new TelldusLive();
	}
	return PrivateData::instance;
}

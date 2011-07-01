#include "tellduslive.h"

#include <QtKOAuth>
#include "json.h"
#include <QSettings>
#include <QScriptEngine>
#include <QQueue>
#include <QDebug>

class TelldusLiveCall {
public:
	QString endpoint;
	QScriptValue params;
	QScriptValue callback;
	QScriptValue thisObject;
};

class TelldusLive::PrivateData {
public:
	enum State { Unauthorized, AuthorizationPending, Authorized };
	State state;
	KQOAuthManager *manager;
	KQOAuthRequest *request;
	QString base, key, secret;
	QQueue<TelldusLiveCall> queue;
	bool requestPending;
};

TelldusLive::TelldusLive(QObject *parent) :
	QObject(parent)
{
	d = new PrivateData;
	d->manager = new KQOAuthManager(this);
	d->requestPending = false;
	d->base = "https://api.telldus.com";
	d->key = "";
	d->secret = "";

	connect(d->manager, SIGNAL(temporaryTokenReceived(QString,QString)), this, SLOT(onTemporaryTokenReceived(QString, QString)));
	connect(d->manager, SIGNAL(authorizationReceived(QString,QString)), this, SLOT( onAuthorizationReceived(QString, QString)));
	connect(d->manager, SIGNAL(accessTokenReceived(QString,QString)), this, SLOT(onAccessTokenReceived(QString,QString)));
	connect(d->manager, SIGNAL(requestReady(QByteArray)), this, SLOT(onRequestReady(QByteArray)));

	d->request = new KQOAuthRequest(this);

	QSettings s;
	QString token = s.value("oauthToken", "").toString();
	QString tokenSecret = s.value("oauthTokenSecret", "").toString();
	if (token.isEmpty() || tokenSecret.isEmpty()) {
		d->state = PrivateData::Unauthorized;
	} else {
		d->state = PrivateData::Authorized;
	}
}

TelldusLive::~TelldusLive() {
	delete d;
}

void TelldusLive::authorize() {
	d->request->initRequest(KQOAuthRequest::TemporaryCredentials, QUrl(d->base + "/oauth/requestToken"));
	d->request->setConsumerKey(d->key);
	d->request->setConsumerSecretKey(d->secret);

	d->manager->setHandleUserAuthorization(true);
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
	}

	if (!call.callback.isValid()) {
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

	QScriptValue parameters = call.callback.engine()->toScriptValue(result);
	call.callback.call(call.thisObject, QScriptValueList() << parameters);
	if (call.callback.engine()->hasUncaughtException()) {
		qDebug() << call.callback.engine()->uncaughtException().toString();
	}
}

bool TelldusLive::isAuthorized() {
	return d->state == PrivateData::Authorized;
}

void TelldusLive::call(const QString &endpoint, const QScriptValue &params, const QScriptValue &expression) {
	qDebug() << "Queue call to" << endpoint;

	TelldusLiveCall call;

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
	call.params = params;
	d->queue.enqueue(call);
	if (!d->requestPending) {
		this->doCall();
	}
}

void TelldusLive::logout() {
	QSettings s;
	s.setValue("oauthToken", "");
	s.setValue("oauthTokenSecret", "");
	d->state = PrivateData::Unauthorized;
	emit authorizedChanged();
}

void TelldusLive::doCall() {
	d->requestPending = true;
	TelldusLiveCall call(d->queue.head());
	qDebug() << "Calling" << call.endpoint;

	QSettings s;
	QString token = s.value("oauthToken", "").toString();
	QString tokenSecret = s.value("oauthTokenSecret", "").toString();

	d->request->initRequest(KQOAuthRequest::AuthorizedRequest, QUrl(d->base + "/json/" + call.endpoint));
	d->request->setConsumerKey(d->key);
	d->request->setConsumerSecretKey(d->secret);
	d->request->setToken(token);
	d->request->setTokenSecret(tokenSecret);
	d->request->setHttpMethod(KQOAuthRequest::GET);

	if (call.params.isObject()) {
		KQOAuthParameters callParams;
		QMap<QString, QVariant> paramsMap = call.params.toVariant().toMap();
		for(QMap<QString, QVariant>::const_iterator it = paramsMap.constBegin(); it != paramsMap.constEnd(); ++it) {
			callParams.insert(it.key(), it.value().toString());
		}

		d->request->setAdditionalParameters(callParams);
	}

	d->manager->executeRequest(d->request);
}


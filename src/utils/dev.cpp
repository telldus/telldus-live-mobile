#include "Dev.h"
#include "config.h"

#include <QDebug>
#include <QUuid>
#include <QNetworkRequest>
#include <QUrlQuery>
#include <QDateTime>

class Dev::PrivateData {
public:
	static Dev *instance;
	static QString sessionId;
};

Dev *Dev::PrivateData::instance = 0;
QString Dev::PrivateData::sessionId = "";

Dev::Dev(QObject *parent):QObject(parent) {
	this->init();
}

Dev::~Dev() {
	this->deinit();
}

Dev * Dev::instance() {
	if (PrivateData::instance == 0) {
		PrivateData::instance = new Dev();
	}
	return PrivateData::instance;
}

// Default platforms
#ifndef PLATFORM_IOS
void Dev::init() {
	if (PrivateData::sessionId == "") {
		PrivateData::sessionId = QUuid::createUuid().toString();
	}
	nam = new QNetworkAccessManager();
}
void Dev::deinit() {
}

void Dev::logScreenView(const QString &screenName) {
	QNetworkRequest req(QUrl("http://www.google-analytics.com/collect"));
	req.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");

	QUrlQuery query;
	query.addQueryItem("v", "1"); // Version
	query.addQueryItem("tid", GOOGLE_ANALYTICS_TRACKER); // Tracking ID - use value assigned to you by Google Analytics
	query.addQueryItem("cid", PrivateData::sessionId); // Client ID
	query.addQueryItem("aid", "com.telldus.live.mobile"); // Client ID TODO
	query.addQueryItem("ds", "app");
	query.addQueryItem("dm", "desktop");

	query.addQueryItem("t", "screenview");
	query.addQueryItem("cd", screenName);

	query.addQueryItem("an", "TelldusLiveMobile"); // App Name
	query.addQueryItem("av", "1.0.5"); // App Version TODO
	query.addQueryItem("sr", "750x1334"); // Screen Resolution TODO
	query.addQueryItem("ul", "en"); // Language TODO
	QDateTime local(QDateTime::currentDateTime());
	query.addQueryItem("z", QString::number(local.currentMSecsSinceEpoch())); // Required Cachebuster

	QByteArray data;
	data.append(query.query());
	qDebug() << data;
	nam->post(req, data);
}

void Dev::logEvent(const QString &category, const QString &action, const QString &label) {
	QNetworkRequest req(QUrl("http://www.google-analytics.com/collect"));
	req.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");

	QUrlQuery query;
	query.addQueryItem("v", "1"); // Version
	query.addQueryItem("tid", GOOGLE_ANALYTICS_TRACKER); // Tracking ID - use value assigned to you by Google Analytics
	query.addQueryItem("cid", PrivateData::sessionId); // Client ID
	query.addQueryItem("aid", "com.telldus.live.mobile"); // Client ID TODO
	query.addQueryItem("ds", "app");
	query.addQueryItem("dm", "desktop");

	query.addQueryItem("t", "event");
	query.addQueryItem("ec", category);
	query.addQueryItem("ea", action);
	query.addQueryItem("el", label);

	query.addQueryItem("an", "TelldusLiveMobile"); // App Name
	query.addQueryItem("av", "1.0.5"); // App Version TODO
	query.addQueryItem("sr", "750x1334"); // Screen Resolution TODO
	query.addQueryItem("ul", "en"); // Language TODO
	QDateTime local(QDateTime::currentDateTime());
	query.addQueryItem("z", QString::number(local.currentMSecsSinceEpoch())); // Required Cachebuster

	QByteArray data;
	data.append(query.query());
	qDebug() << data;
	nam->post(req, data);
}
#endif

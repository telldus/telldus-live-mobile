#include "user.h"
#include <QSettings>
#include "tellduslive.h"
#include <QDebug>

class User::PrivateData {
public:
	bool fetched;
	QString firstname, lastname, email;
	double credits;
};

User::User(QObject *parent) :
	QObject(parent)
{
	d = new PrivateData;
	d->fetched = false;
	QSettings s;
	d->firstname = s.value("firstname", "").toString();
	d->lastname = s.value("lastname", "").toString();
	d->email = s.value("email", "").toString();
	d->credits = s.value("credits", 0).toDouble();
}

User::~User() {
	delete d;
}

QString User::firstname() const {
	if (!d->fetched) {
		this->fetchData();
	}
	return d->firstname;
}

QString User::lastname() const {
	if (!d->fetched) {
		this->fetchData();
	}
	return d->lastname;
}

QString User::email() const {
	if (!d->fetched) {
		this->fetchData();
	}
	return d->email;
}

double User::credits() const {
	if (!d->fetched) {
		this->fetchData();
	}
	return d->credits;
}

void User::fetchData() const {
	TelldusLive *telldusLive = TelldusLive::instance();
	if (!telldusLive->isAuthorized()) {
		return;
	}
	telldusLive->call("user/profile", TelldusLiveParams(), const_cast<User*>(this), SLOT(onInfoReceived(QVariantMap)));
	d->fetched = true;
}

void User::onInfoReceived(const QVariantMap &info) {
	qDebug() << "Info" << info;
	QSettings s;
	if (info.contains("firstname")) {
		d->firstname = info["firstname"].toString();
		s.setValue("firstname", d->firstname);
		emit firstnameChanged();
	}
	if (info.contains("lastname")) {
		d->lastname = info["lastname"].toString();
		s.setValue("lastname", d->lastname);
		emit lastnameChanged();
	}
	if (info.contains("email")) {
		d->email = info["email"].toString();
		s.setValue("email", d->email);
		emit emailChanged();
	}
	if (info.contains("credits")) {
		d->credits = info["credits"].toDouble();
		s.setValue("credits", d->credits);
		emit creditsChanged();
	}
}

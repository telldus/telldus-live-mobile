#include "client.h"
#include "tellduslive.h"

class Client::PrivateData {
public:
	bool online, editable;
	int id;
	QString name, version, type;
};

Client::Client(QObject *parent) :
	QObject(parent)
{
	d = new PrivateData;
	d->online = false;
	d->editable = false;
	d->id = 0;
}

Client::~Client() {
	delete d;
}

bool Client::editable() const {
	return d->editable;
}

void Client::setEditable(bool editable) {
	d->editable = editable;
	emit editableChanged();
}

int Client::clientId() const {
	return d->id;
}

void Client::setId(int id) {
	d->id = id;
	emit idChanged();
}

QString Client::name() const {
	return d->name;
}

void Client::setName(const QString &name) {
	d->name = name;
	emit nameChanged();
}

bool Client::online() const {
	return d->online;
}

void Client::setOnline(bool online) {
	d->online = online;
	emit onlineChanged();
}

QString Client::version() const {
	return d->version;
}

void Client::setVersion(const QString &version) {
	d->version = version;
	emit versionChanged();
}

QString Client::type() const {
	return d->type;
}

void Client::setType(const QString &type) {
	d->type = type;
	emit typeChanged();
}

#include "device.h"
#include "schedulerjob.h"
#include "tellduslive.h"
#include "models/devicemodel.h"
#include "models/groupdevicemodel.h"
#include "models/schedulermodel.h"

#include <QDebug>
#include <QStringList>
#include <QSqlDatabase>
#include <QSqlQuery>

class Device::PrivateData {
public:
	bool isFavorite, online;
	int id, methods, state;
	QString name, stateValue, clientName;
	Type type;
	GroupDeviceModel *groupModel;
};

Device::Device(QObject *parent) :
	QObject(parent)
{
	d = new PrivateData;
	d->isFavorite = false;
	d->online = false;
	d->id = 0;
	d->methods = 0;
	d->state = 2;
	d->type = DeviceType;
	d->groupModel = new GroupDeviceModel(this);
	connect(d->groupModel, SIGNAL(changed()), this, SLOT(groupContentChanged()));

	SchedulerModel *sm = SchedulerModel::instance();
	connect(sm, SIGNAL(rowsInserted(QModelIndex,int,int)), this, SLOT(schedulerJobsChanged(QModelIndex,int,int)));
	connect(sm, SIGNAL(rowsRemoved(QModelIndex,int,int)), this, SLOT(schedulerJobsChanged(QModelIndex,int,int)));
}

Device::~Device() {
	delete d;
}

void Device::addDevice(int deviceId, bool save) {
	d->groupModel->addDevices(QList<int>() << deviceId, save);
}

void Device::addDevices(const QString &devices, bool save) {
	QList<int> list;
	foreach(QString deviceId, devices.split(',')) {
		list << deviceId.toInt();
	}
	d->groupModel->addDevices(list, save);
}

QString Device::clientName() const {
	return d->clientName;
}

void Device::setClientName(const QString &clientName) {
	d->clientName = clientName;
	emit clientNameChanged();
	emit saveToCache();
}

GroupDeviceModel * Device::devices() const {
	return d->groupModel;
}

void Device::bell() {
	sendMethod(Device::BELL);
}

void Device::dim(unsigned char level) {
	sendMethod(Device::DIM, QString::number(level));
}

void Device::down() {
	sendMethod(Device::DOWN);
}

void Device::learn() {
	sendMethod(Device::LEARN);
}

void Device::stop() {
	sendMethod(Device::STOP);
}

bool Device::hasDevice(int deviceId) const {
	return d->groupModel->hasDevice(deviceId);
}

int Device::deviceId() const {
	return d->id;
}

void Device::setId(int id) {
	d->id = id;
	d->groupModel->setId(d->id);
	emit idChanged();
	emit saveToCache();
}

bool Device::isFavorite() const {
	return d->isFavorite;
}

void Device::setIsFavorite(bool isFavorite) {
	d->isFavorite = isFavorite;
	emit isFavoriteChanged();
	emit saveToCache();
}

int Device::methods() const {
	return d->methods;
}

void Device::setMethods(int methods) {
	if (d->methods == methods) {
		return;
	}
	d->methods = methods;
	emit methodsChanged();
	emit saveToCache();
}

QString Device::name() const {
	return d->name;
}

void Device::setName(const QString &name) {
	d->name = name;
	emit nameChanged();
	emit saveToCache();
}

QDateTime Device::nextRunTime() const {
	return SchedulerModel::instance()->nextRunTimeForDevice(d->id);
}

void Device::onActionResponse(const QVariantMap &result, const QVariantMap &data) {
	if (result["status"].toString() != "success") {
		return;
	}
	int method = data["method"].toInt();
	if (method == Device::DIM) {
		QString value = data["value"].toString();
		if (value == "255") {
			method = Device::TURNON;
		} else if (value == "0") {
			method = Device::TURNOFF;
		}
		setStateValue(value);
	} else if (method == Device::BELL || method == Device::LEARN) {
		return;
	}
	setState(method);
}

void Device::onDeviceInfo(const QVariantMap &result, const QVariantMap &) {
	this->setMethods(result["methods"].toInt());
}

bool Device::online() const {
	return d->online;
}

void Device::groupContentChanged() {
	TelldusLive *telldusLive = TelldusLive::instance();
	TelldusLiveParams params;
	params["id"] = d->id;
	params["supportedMethods"] = 23; //TODO: Use constants
	telldusLive->call("device/info", params, this, SLOT(onDeviceInfo(QVariantMap,QVariantMap)));

}

void Device::removeDevice(int deviceId) {
	d->groupModel->removeDevices(QList<int>() << deviceId);
}

void Device::setOnline(bool online) {
	d->online = online;
	emit onlineChanged();
}

void Device::sendMethod(int method, const QString &value) {
	TelldusLive *telldusLive = TelldusLive::instance();
	TelldusLiveParams params;
	params["id"] = this->deviceId();
	params["method"] = method;
	params["value"] = value;
	telldusLive->call("device/command", params, this, SLOT(onActionResponse(QVariantMap,QVariantMap)), params);
}

int Device::state() const {
	return d->state;
}

void Device::setState(int state) {
	d->state = state;
	emit stateChanged();
	emit stateValueChanged(this->stateValue());
	emit saveToCache();
}

QString Device::stateValue() const {
	if (d->state == Device::TURNON) {
		return "255";
	} else if (d->state == Device::TURNOFF) {
		return "0";
	} else if (d->state == Device::DIM) {
		return d->stateValue;
	}
	return "";
}

void Device::setStateValue(const QString &stateValue) {
	d->stateValue = stateValue;
	emit stateValueChanged(stateValue);
	emit saveToCache();
}

void Device::turnOff() {
	sendMethod(Device::TURNOFF);
}

void Device::turnOn() {
	sendMethod(Device::TURNON);
}

void Device::up() {
	sendMethod(Device::UP);
}

Device::Type Device::type() const {
	return d->type;
}

void Device::setType(Device::Type type) {
	if (type == d->type) {
		return;
	}
	d->type = type;
	emit typeChanged();
	emit saveToCache();
}

void Device::setType(const QString &type) {
	if (type == "group") {
		setType(GroupType);
	} else {
		setType(DeviceType);
	}
}

void Device::schedulerJobsChanged(const QModelIndex &, int start, int end) {
	SchedulerModel *model = SchedulerModel::instance();
	for (int i = start; i <= end; ++i ) {
		SchedulerJob *job = qobject_cast<SchedulerJob *>(model->get(i).value<QObject *>());
		if (!job) {
			continue;
		}
		if (job->deviceId() == d->id) {
			emit nextRunTimeChanged();
			return;
		}
	}
}

void Device::saveToCache() {
	QSqlDatabase db = QSqlDatabase::database();
	if (db.isOpen()) {
		QSqlQuery query(db);
		query.prepare("REPLACE INTO Device (id, name, methods, type, favorite, state, statevalue, clientName) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
		query.bindValue(0, d->id);
		query.bindValue(1, d->name);
		query.bindValue(2, d->methods);
		query.bindValue(3, d->type);
		query.bindValue(4, d->isFavorite);
		query.bindValue(5, d->state);
		query.bindValue(6, d->stateValue);
		query.bindValue(7, d->clientName);
		query.exec();
	}
}

#include "tellduscenter.h"
#include <QtDeclarative>
#include "tellduslive.h"
#include "devicemodel.h"
#include "filtereddevicemodel.h"
#include "groupdevicemodel.h"
#include "sensormodel.h"
#include "favoritemodel.h"
#include "clientmodel.h"
#include "client.h"
#include "device.h"
#include "sensor.h"

class TelldusCenter::PrivateData {
public:
	QDeclarativeView *view;
	FilteredDeviceModel *rawDeviceModel, *deviceModel, *groupModel;
	SensorModel *sensorModel;
	FavoriteModel *favoriteModel;
	ClientModel *clientModel;
};

TelldusCenter::TelldusCenter(QDeclarativeView *view, QObject *parent) :
	QObject(parent)
{
	d = new PrivateData;
	d->view = view;
	d->rawDeviceModel = new FilteredDeviceModel(DeviceModel::instance(), Device::AnyType, this);
	d->deviceModel = new FilteredDeviceModel(DeviceModel::instance(), Device::DeviceType, this);
	d->groupModel = new FilteredDeviceModel(DeviceModel::instance(), Device::GroupType, this);
	d->favoriteModel = new FavoriteModel(DeviceModel::instance(), this);
	d->clientModel = new ClientModel(this);
	d->sensorModel = new SensorModel(this);

	qmlRegisterType<TListModel>("Telldus", 1, 0, "TListModel");
	qmlRegisterType<Client>("Telldus", 1, 0, "Client");
	qmlRegisterType<Device>("Telldus", 1, 0, "Device");
	qmlRegisterType<Sensor>("Telldus", 1, 0, "Sensor");
	qmlRegisterType<GroupDeviceModel>("Telldus", 1, 0, "GroupDeviceModel");
	qRegisterMetaType<QModelIndex>("QModelIndex");

	d->view->rootContext()->setContextProperty("telldusLive", TelldusLive::instance());
	d->view->rootContext()->setContextProperty("deviceModelController", DeviceModel::instance());
	d->view->rootContext()->setContextProperty("rawDeviceModel", d->rawDeviceModel);
	d->view->rootContext()->setContextProperty("deviceModel", d->deviceModel);
	d->view->rootContext()->setContextProperty("groupModel", d->groupModel);
	d->view->rootContext()->setContextProperty("favoriteModel", d->favoriteModel);
	d->view->rootContext()->setContextProperty("clientModel", d->clientModel);
	d->view->rootContext()->setContextProperty("sensorModel", d->sensorModel);
}

TelldusCenter::~TelldusCenter() {
	delete d;
}

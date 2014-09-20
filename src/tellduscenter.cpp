#include "tellduscenter.h"
#include <QtQuick>
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
#include "swipearea.h"
#include "user.h"
#include "commonview.h"

class TelldusCenter::PrivateData {
public:
	AbstractView *view;
	FilteredDeviceModel *rawDeviceModel, *deviceModel, *groupModel;
	FavoriteModel *favoriteModel;
	ClientModel *clientModel;
	User *user;
};

TelldusCenter::TelldusCenter(AbstractView *view, QObject *parent) :
	QObject(parent)
{
	d = new PrivateData;
	d->view = view;
	d->rawDeviceModel = new FilteredDeviceModel(DeviceModel::instance(), Device::AnyType, this);
	d->deviceModel = new FilteredDeviceModel(DeviceModel::instance(), Device::DeviceType, this);
	d->groupModel = new FilteredDeviceModel(DeviceModel::instance(), Device::GroupType, this);
	d->favoriteModel = new FavoriteModel(DeviceModel::instance(), this);
	d->clientModel = new ClientModel(this);
	d->user = new User(this);

	qmlRegisterType<TListModel>("Telldus", 1, 0, "TListModel");
	qmlRegisterType<Client>("Telldus", 1, 0, "Client");
	qmlRegisterType<Device>("Telldus", 1, 0, "Device");
	qmlRegisterType<Sensor>("Telldus", 1, 0, "Sensor");
	qmlRegisterType<GroupDeviceModel>("Telldus", 1, 0, "GroupDeviceModel");
	qmlRegisterType<SwipeArea>("Telldus", 1, 0, "SwipeArea");
	qRegisterMetaType<QModelIndex>("QModelIndex");

	d->view->setContextProperty("telldusLive", TelldusLive::instance());
	d->view->setContextProperty("core", this);
	d->view->setContextProperty("deviceModelController", DeviceModel::instance());
	d->view->setContextProperty("rawDeviceModel", d->rawDeviceModel);
	d->view->setContextProperty("deviceModel", d->deviceModel);
	d->view->setContextProperty("groupModel", d->groupModel);
	d->view->setContextProperty("favoriteModel", d->favoriteModel);
	d->view->setContextProperty("clientModel", d->clientModel);
	d->view->setContextProperty("sensorModel", SensorModel::instance());
	d->view->setContextProperty("user", d->user);

#ifdef PLATFORM_IOS
	this->init();
#endif
}

TelldusCenter::~TelldusCenter() {
	delete d;
}

void TelldusCenter::openUrl(const QUrl &url) {
#ifdef PLATFORM_IOS
	qobject_cast<CommonView *>(d->view)->openUrl(url);
#else
	QDesktopServices::openUrl(url);
#endif  // PLATFORM_IOS
}

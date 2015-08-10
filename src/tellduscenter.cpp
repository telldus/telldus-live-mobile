#include <QtQuick>

#include "client.h"
#include "commonview.h"
#include "device.h"
#include "sensor.h"
#include "swipearea.h"
#include "tellduscenter.h"
#include "tellduslive.h"
#include "user.h"
#include "models/clientmodel.h"
#include "models/devicemodel.h"
#include "models/dashboardModel.h"
#include "models/favoritemodel.h"
#include "models/filtereddevicemodel.h"
#include "models/groupdevicemodel.h"
#include "models/sensormodel.h"
#include "utils/dev.h"

class TelldusCenter::PrivateData {
public:
	AbstractView *view;
	FilteredDeviceModel *rawDeviceModel, *deviceModel, *groupModel;
	DashboardModel *dashboardModel;
	FavoriteModel *favoriteModel;
	ClientModel *clientModel;
	User *user;
};

TelldusCenter::TelldusCenter(AbstractView *view, QObject *parent) :QObject(parent)
{
	d = new PrivateData;
	d->view = view;
	d->rawDeviceModel = new FilteredDeviceModel(DeviceModel::instance(), Device::AnyType, this);
	d->deviceModel = new FilteredDeviceModel(DeviceModel::instance(), Device::DeviceType, this);
	d->groupModel = new FilteredDeviceModel(DeviceModel::instance(), Device::GroupType, this);
	d->dashboardModel = new DashboardModel(DeviceModel::instance(), this);
	d->favoriteModel = new FavoriteModel(DeviceModel::instance(), this);
	d->clientModel = new ClientModel(this);
	d->user = new User(this);

	qmlRegisterType<TListModel>("Telldus", 1, 0, "TListModel");
	qmlRegisterType<Client>("Telldus", 1, 0, "Client");
	qmlRegisterType<Device>("Telldus", 1, 0, "Device");
	qmlRegisterType<Sensor>("Telldus", 1, 0, "Sensor");
	qmlRegisterType<GroupDeviceModel>("Telldus", 1, 0, "GroupDeviceModel");
	qRegisterMetaType<QModelIndex>("QModelIndex");

	d->view->setContextProperty("telldusLive", TelldusLive::instance());
	d->view->setContextProperty("dev", Dev::instance());
	d->view->setContextProperty("core", this);
	d->view->setContextProperty("deviceModelController", DeviceModel::instance());
	d->view->setContextProperty("rawDeviceModel", d->rawDeviceModel);
	d->view->setContextProperty("deviceModel", d->deviceModel);
	d->view->setContextProperty("groupModel", d->groupModel);
	d->view->setContextProperty("favoriteModel", d->favoriteModel);
	d->view->setContextProperty("dashboardModel", d->dashboardModel);
	d->view->setContextProperty("clientModel", d->clientModel);
	d->view->setContextProperty("sensorModel", SensorModel::instance());
	d->view->setContextProperty("user", d->user);
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

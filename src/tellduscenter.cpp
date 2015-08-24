#include "tellduscenter.h"

#include <QtQuick>

#include "client.h"
#include "commonview.h"
#include "config.h"
#include "device.h"
#include "models/clientmodel.h"
#include "models/devicemodel.h"
#include "models/dashboardmodel.h"
#include "models/favoritedevicemodel.h"
#include "models/favoritesensormodel.h"
#include "models/filtereddevicemodel.h"
#include "models/groupdevicemodel.h"
#include "models/schedulermodel.h"
#include "models/sensormodel.h"
#include "Notification.h"
#include "objects/DashboardItem.h"
#include "properties/Properties.h"
#include "properties/PropertiesTheme.h"
#include "properties/PropertiesThemeColors.h"
#include "properties/PropertiesThemeCore.h"
#include "sensor.h"
#include "tellduslive.h"
#include "user.h"
#include "utils/dev.h"

#if IS_FEATURE_PUSH_ENABLED
#include "Push.h"
#endif  // IS_FEATURE_PUSH_ENABLED

class TelldusCenter::PrivateData {
public:
	AbstractView *view;
	FilteredDeviceModel *rawDeviceModel, *deviceModel, *groupModel;
	ClientModel *clientModel;
	DashboardModel *dashboardModel;
	User *user;
	static TelldusCenter *instance;
};

TelldusCenter *TelldusCenter::PrivateData::instance = 0;

TelldusCenter::TelldusCenter(AbstractView *view, QObject *parent) :QObject(parent) {
	TelldusLive *tdLive = TelldusLive::instance();

	tdLive->setupManager();

	d = new PrivateData;
	d->view = view;
	d->rawDeviceModel = new FilteredDeviceModel(DeviceModel::instance(), Device::AnyType, this);
	d->deviceModel = new FilteredDeviceModel(DeviceModel::instance(), Device::DeviceType, this);
	d->groupModel = new FilteredDeviceModel(DeviceModel::instance(), Device::GroupType, this);
	d->dashboardModel = new DashboardModel(
		new FavoriteDeviceModel(DeviceModel::instance(), this),
		new FavoriteSensorModel(SensorModel::instance(), this),
		this
	);
	d->clientModel = new ClientModel(this);
	d->user = new User(this);
#if IS_FEATURE_PUSH_ENABLED
	connect(Push::instance(), SIGNAL(messageReceived(QString)), this, SLOT(pushMessageReceived(QString)));
#endif  // IS_FEATURE_PUSH_ENABLED

	qmlRegisterType<TListModel>("Telldus", 1, 0, "TListModel");
	qmlRegisterType<Client>("Telldus", 1, 0, "Client");
	qmlRegisterType<Device>("Telldus", 1, 0, "Device");
	qmlRegisterType<DashboardItem>("Telldus", 1, 0, "DashboardItem");
	qmlRegisterType<Sensor>("Telldus", 1, 0, "Sensor");
	qmlRegisterType<GroupDeviceModel>("Telldus", 1, 0, "GroupDeviceModel");
	qmlRegisterType<PropertiesTheme>("Telldus", 1, 0, "PropertiesTheme");
	qmlRegisterType<PropertiesThemeColors>("Telldus", 1, 0, "PropertiesThemeColors");
	qmlRegisterType<PropertiesThemeCore>("Telldus", 1, 0, "PropertiesThemeCore");

	qRegisterMetaType<QModelIndex>("QModelIndex");

	d->view->setContextProperty("telldusLive", tdLive);
	d->view->setContextProperty("dev", Dev::instance());
	d->view->setContextProperty("core", this);
	d->view->setContextProperty("deviceModelController", DeviceModel::instance());
	d->view->setContextProperty("rawDeviceModel", d->rawDeviceModel);
	d->view->setContextProperty("schedulerModel", SchedulerModel::instance());
	d->view->setContextProperty("deviceModel", d->deviceModel);
	d->view->setContextProperty("groupModel", d->groupModel);
	d->view->setContextProperty("dashboardModel", d->dashboardModel);
	d->view->setContextProperty("clientModel", d->clientModel);
	d->view->setContextProperty("sensorModel", SensorModel::instance());
	d->view->setContextProperty("user", d->user);
	d->view->setContextProperty("properties", Properties::instance());
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

void TelldusCenter::pushMessageReceived(const QString &message) {
	Notification notification(message);
	notification.notify();
}

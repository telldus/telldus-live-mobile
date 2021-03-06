#include "tellduscenter.h"

#include <QtQuick>
#include <QSqlDatabase>
#include <QStandardPaths>

#include "client.h"
#include "commonview.h"
#include "config.h"
#include "device.h"
#include "models/clientmodel.h"
#include "models/DeviceListSortFilterModel.h"
#include "models/devicemodel.h"
#include "models/dashboardmodel.h"
#include "models/DrawerMenuModel.h"
#include "models/favoritedevicemodel.h"
#include "models/favoritesensormodel.h"
#include "models/filtereddevicemodel.h"
#include "models/groupdevicemodel.h"
#include "models/SchedulerDayModel.h"
#include "models/SchedulerDaySortFilterModel.h"
#include "models/schedulermodel.h"
#include "models/sensormodel.h"
#include "models/SensorListSortFilterModel.h"
#include "objects/DashboardItem.h"
#include "objects/DrawerMenuItem.h"
#include "properties/Properties.h"
#include "properties/PropertiesTheme.h"
#include "properties/PropertiesThemeColors.h"
#include "properties/PropertiesThemeCore.h"
#include "properties/PropertiesUi.h"
#include "sensor.h"
#include "tellduslive.h"
#include "user.h"
#include "utils/dev.h"

#if IS_FEATURE_PUSH_ENABLED
#include "Push.h"
#include "Notification.h"
#endif  // IS_FEATURE_PUSH_ENABLED

class TelldusCenter::PrivateData {
public:
	AbstractView *view;
	FilteredDeviceModel *rawDeviceModel, *deviceModel, *groupModel;
	ClientModel *clientModel;
	DashboardModel *dashboardModel;
	DrawerMenuModel *drawerMenuModel;
	SchedulerDayModel *schedulerDayModel;
	SchedulerDaySortFilterModel *schedulerDaySortFilterModel;
	DeviceListSortFilterModel *deviceListSortFilterModel;
	SensorListSortFilterModel *sensorListSortFilterModel;
	User *user;
	static TelldusCenter *instance;
};

TelldusCenter *TelldusCenter::PrivateData::instance = 0;

TelldusCenter::TelldusCenter(AbstractView *view, QObject *parent) :QObject(parent) {

	qDebug().nospace().noquote() << "[MISC] Translator test: " << QCoreApplication::translate("extra", "This is untranslated!");

	QString dataPath(QStandardPaths::standardLocations(QStandardPaths::AppDataLocation).last());
	if(!QDir(dataPath).exists()) {
		QDir().mkpath(dataPath);
	}
	QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
	db.setDatabaseName(dataPath + "/data.sqlite");
	bool ok = db.open();
	qDebug().nospace().noquote() << "[DB] db.open result: " << ok << "(" << db.databaseName() << ")";

	TelldusLive *tdLive = TelldusLive::instance();

	tdLive->setupManager();

	d = new PrivateData;
	d->view = view;
	d->user = new User(this);
	d->rawDeviceModel = new FilteredDeviceModel(DeviceModel::instance(), Device::AnyType, this);
	d->deviceModel = new FilteredDeviceModel(DeviceModel::instance(), Device::DeviceType, this);
	d->groupModel = new FilteredDeviceModel(DeviceModel::instance(), Device::GroupType, this);
	d->deviceListSortFilterModel = new DeviceListSortFilterModel(DeviceModel::instance(), this);
	d->clientModel = ClientModel::instance();
	d->drawerMenuModel = new DrawerMenuModel(this);
	d->dashboardModel = new DashboardModel(
		new FavoriteDeviceModel(DeviceModel::instance(), this),
		new FavoriteSensorModel(SensorModel::instance(), this),
		this
	);
	d->schedulerDayModel = new SchedulerDayModel(SchedulerModel::instance(), this);
	d->schedulerDaySortFilterModel = new SchedulerDaySortFilterModel(d->schedulerDayModel, this);
	d->sensorListSortFilterModel = new SensorListSortFilterModel(SensorModel::instance(), this);
#if IS_FEATURE_PUSH_ENABLED
	connect(Push::instance(), SIGNAL(messageReceived(QString)), this, SLOT(pushMessageReceived(QString)));
#endif  // IS_FEATURE_PUSH_ENABLED

	connect(d->view, SIGNAL(backPressed()), this, SIGNAL(backPressed()));

	qmlRegisterType<TListModel>("Telldus", 1, 0, "TListModel");
	qmlRegisterType<Client>("Telldus", 1, 0, "Client");
	qmlRegisterType<Device>("Telldus", 1, 0, "Device");
	qmlRegisterType<DashboardItem>("Telldus", 1, 0, "DashboardItem");
	qmlRegisterType<DrawerMenuItem>("Telldus", 1, 0, "DrawerMenuItem");
	qmlRegisterType<Sensor>("Telldus", 1, 0, "Sensor");
	qmlRegisterType<GroupDeviceModel>("Telldus", 1, 0, "GroupDeviceModel");
	qmlRegisterType<PropertiesTheme>("Telldus", 1, 0, "PropertiesTheme");
	qmlRegisterType<PropertiesThemeColors>("Telldus", 1, 0, "PropertiesThemeColors");
	qmlRegisterType<PropertiesThemeCore>("Telldus", 1, 0, "PropertiesThemeCore");
	qmlRegisterType<PropertiesUi>("Telldus", 1, 0, "PropertiesUi");
	qmlRegisterType<User>("Telldus", 1, 0, "User");

	qRegisterMetaType<QModelIndex>("QModelIndex");

	d->view->setContextProperty("telldusLive", tdLive);
	d->view->setContextProperty("dev", Dev::instance());
	d->view->setContextProperty("core", this);
	d->view->setContextProperty("deviceModelController", DeviceModel::instance());
	d->view->setContextProperty("deviceListSortFilterModel", d->deviceListSortFilterModel);
	d->view->setContextProperty("rawDeviceModel", d->rawDeviceModel);
	d->view->setContextProperty("schedulerDayModel", d->schedulerDayModel);
	d->view->setContextProperty("schedulerDaySortFilterModel", d->schedulerDaySortFilterModel);
	d->view->setContextProperty("schedulerModel", SchedulerModel::instance());
	d->view->setContextProperty("deviceModel", d->deviceModel);
	d->view->setContextProperty("groupModel", d->groupModel);
	d->view->setContextProperty("dashboardModel", d->dashboardModel);
	d->view->setContextProperty("drawerMenuModel", d->drawerMenuModel);
	d->view->setContextProperty("clientModel", d->clientModel);
	d->view->setContextProperty("sensorModel", SensorModel::instance());
	d->view->setContextProperty("sensorListSortFilterModel", d->sensorListSortFilterModel);
	d->view->setContextProperty("user", d->user);
	d->view->setContextProperty("properties", Properties::instance());
}

TelldusCenter::~TelldusCenter() {
	delete d;
}

void TelldusCenter::quit() {
#if defined(PLATFORM_ANDROID) || defined(PLATFORM_DESKTOP)
	QCoreApplication::quit();
#endif
}

void TelldusCenter::openUrl(const QUrl &url) {
#ifdef PLATFORM_IOS
//	qobject_cast<CommonView *>(d->view)->openUrl(url);
#else
	QDesktopServices::openUrl(url);
#endif  // PLATFORM_IOS
}

#if IS_FEATURE_PUSH_ENABLED
void TelldusCenter::pushMessageReceived(const QString &message) {
	Notification notification(message);
	notification.notify();
}
#endif

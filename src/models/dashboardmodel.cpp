#include "dashboardmodel.h"

#include <QDebug>

#include "device.h"
#include "devicemodel.h"
#include "favoritedevicemodel.h"
#include "favoritesensormodel.h"
#include "objects/DashboardItem.h"
#include "sensor.h"
#include "sensormodel.h"
#include "tellduslive.h"

class DashboardModel::PrivateData {
public:
	FavoriteDeviceModel *favoriteDeviceModel;
	FavoriteSensorModel *filteredSensorModel;
};

DashboardModel::DashboardModel(FavoriteDeviceModel *favoriteDeviceModel, FavoriteSensorModel *filteredSensorModel, QObject *parent) : TListModel("dashboardItem", parent)
{
	d = new PrivateData;

	d->favoriteDeviceModel = favoriteDeviceModel;
	connect(d->favoriteDeviceModel, SIGNAL(countChanged()), this, SLOT(addDashboardItems()));

	d->filteredSensorModel = filteredSensorModel;
	connect(d->filteredSensorModel, SIGNAL(countChanged()), this, SLOT(addDashboardItems()));
}

DashboardModel::~DashboardModel() {
	delete d;
}

void DashboardModel::addDashboardItems() {
	this->clear();
	QList<QObject *> list;
	qDebug() << "Favorited Device RowCount: " << d->favoriteDeviceModel->rowCount();
	for(int a = 0; a < d->favoriteDeviceModel->rowCount(); a = a + 1) {
		Device *device = qvariant_cast<Device*>(d->favoriteDeviceModel->index(a, 0).data());
		DashboardItem *dashboardItem = new DashboardItem(this);
		dashboardItem->setId(10000 + device->deviceId());
		dashboardItem->setChildObject(QVariant::fromValue(device));
		list << dashboardItem;
	}
	qDebug() << "Favorited Sensor RowCount: " << d->filteredSensorModel->rowCount();
	for(int a = 0; a < d->filteredSensorModel->rowCount(); a = a + 1) {
		Sensor *sensor = qvariant_cast<Sensor*>(d->filteredSensorModel->index(a, 0).data());
		DashboardItem *dashboardItem = new DashboardItem(this);
		dashboardItem->setId(10000 + sensor->sensorId());
		dashboardItem->setChildObject(QVariant::fromValue(sensor));
		list << dashboardItem;
	}
	if (list.size()) {
		//Appends all in one go
		this->append(list);
	}
}

void DashboardModel::authorizationChanged() {
}


DashboardItem *DashboardModel::findDashboardItem(int id) const {
	for(int i = 0; i < this->rowCount(); ++i) {
		DashboardItem *dashboardItem = qobject_cast<DashboardItem *>(this->get(i).value<QObject *>());
		if (!dashboardItem) {
			continue;
		}
		if (dashboardItem->dashboardItemId() == id) {
			return dashboardItem;
		}
	}
	return 0;
}

void DashboardModel::onDashboardItemInfo(const QVariantMap &result) {
//	QVariantList list;
//	list << result;
//	this->addDashboardItems(list);
}

void DashboardModel::onDashboardItemRemove(const QVariantMap &result, const QVariantMap &params) {
	if (result["status"] != "success") {
		return;
	}
	for(int i = 0; i < this->rowCount(); ++i) {
		DashboardItem *dashboardItem = qobject_cast<DashboardItem *>(this->get(i).value<QObject *>());
		if (!dashboardItem) {
			continue;
		}
		if (dashboardItem->dashboardItemId() == params["id"].toInt()) {
			this->splice(i,1);
			return;
		}
	}
}

void DashboardModel::onDashboardItemsList(const QVariantMap &result) {
//	this->addDashboardItems(result["DashboardItem"].toList());
//	emit dashboardItemsLoaded(result["DashboardItem"].toList());
}

void DashboardModel::removeDashboardItem(int id) {
}

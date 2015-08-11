#include "dashboardmodel.h"

#include <QDebug>

#include "device.h"
#include "devicemodel.h"
#include "sensor.h"
#include "sensormodel.h"
#include "tellduslive.h"
#include "objects/DashboardItem.h"

class DashboardModel::PrivateData {
public:
	static DashboardModel *instance;
};
DashboardModel *DashboardModel::PrivateData::instance = 0;

DashboardModel::DashboardModel(QObject *parent) : TListModel("dashboardItem", parent)
{
	connect(DeviceModel::instance(), SIGNAL(countChanged()), this, SLOT(addDashboardItems()));
	connect(SensorModel::instance(), SIGNAL(countChanged()), this, SLOT(addDashboardItems()));
}

void DashboardModel::addDashboardItems() {
	this->clear();
	QList<QObject *> list;
	qDebug() << "Device RowCount: " << DeviceModel::instance()->rowCount();
	for(int a = 0; a < DeviceModel::instance()->rowCount(); a = a + 1) {
		Device *device = qvariant_cast<Device*>(DeviceModel::instance()->get(a));
		if (device->isFavorite()) {
			DashboardItem *dashboardItem = new DashboardItem(this);
			dashboardItem->setId(10000 + device->deviceId());
			dashboardItem->setChildObject(QVariant::fromValue(device));
			list << dashboardItem;
		}
	}
	qDebug() << "Sensor RowCount: " << SensorModel::instance()->rowCount();
	for(int a = 0; a < SensorModel::instance()->rowCount(); a = a + 1) {
		Sensor *sensor = qvariant_cast<Sensor*>(SensorModel::instance()->get(a));
		if (sensor->isFavorite()) {
			DashboardItem *dashboardItem = new DashboardItem(this);
			dashboardItem->setId(10000 + sensor->sensorId());
			dashboardItem->setChildObject(QVariant::fromValue(sensor));
			list << dashboardItem;
		}
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

DashboardModel * DashboardModel::instance() {
	if (PrivateData::instance == 0) {
		PrivateData::instance = new DashboardModel;
	}
	return PrivateData::instance;
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


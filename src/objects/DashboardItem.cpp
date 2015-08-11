#include "DashboardItem.h"
#include <QDebug>

class DashboardItem::PrivateData {
public:
	int id;
	QVariant childObject;
    ChildObjectType childObjectType;
};

DashboardItem::DashboardItem(QObject *parent) : QObject(parent)
{
	d = new PrivateData;
	d->id = 0;
}

DashboardItem::~DashboardItem() {
	delete d;
}

void DashboardItem::fetchData() {
	d->id = 1;
}

int DashboardItem::dashboardItemId() const {
	return d->id;
}

void DashboardItem::setId(int id) {
	d->id = id;
	emit idChanged();
}

QVariant DashboardItem::childObject() const {
	return d->childObject;
}

void DashboardItem::setChildObject(const QVariant &childObject) {
    QStringList myOptions;
    myOptions << "Device*" << "Sensor*" << "Weather*";
	switch (myOptions.indexOf(childObject.typeName())) {
        case 0:
            d->childObjectType = DeviceChildObjectType;
            break;
        case 1:
            d->childObjectType = SensorChildObjectType;
            break;
        case 2:
            d->childObjectType = WeatherChildObjectType;
            break;
        default:
            d->childObjectType = UnknownChildObjectType;
            break;
    }
	d->childObject = childObject;
	emit childObjectChanged();
}

DashboardItem::ChildObjectType DashboardItem::childObjectType() const {
	return d->childObjectType;
}
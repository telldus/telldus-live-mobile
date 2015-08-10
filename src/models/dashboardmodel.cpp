#include "dashboardmodel.h"
#include "devicemodel.h"
#include "device.h"

#include <QDebug>

class DashboardModel::PrivateData {
public:
	bool doFilter;
};

DashboardModel::DashboardModel(DeviceModel *model, QObject *parent) :
	QSortFilterProxyModel(parent)
{
	d = new PrivateData;
	d->doFilter = true;
	this->setSourceModel(model);
	this->setDynamicSortFilter(true);
	this->sort(0);
	connect(model, SIGNAL(rowsInserted(QModelIndex,int,int)), this, SLOT(rowsAdded(QModelIndex,int,int)));
	connect(this, SIGNAL(rowsInserted(QModelIndex,int,int)), this, SIGNAL(countChanged()));
	connect(this, SIGNAL(rowsRemoved(QModelIndex,int,int)), this, SIGNAL(countChanged()));
}

DashboardModel::~DashboardModel() {
	delete d;
}

bool DashboardModel::filterAcceptsRow(int sourceRow, const QModelIndex &) const {
	DeviceModel *model = qobject_cast<DeviceModel *>(this->sourceModel());
	if (!model) {
		//Should not happen
		return false;
	}
	if (!d->doFilter) {
		return true;
	}
	Device *device = qobject_cast<Device *>(model->get(sourceRow).value<QObject *>());
	return device->isFavorite();
}

bool DashboardModel::lessThan(const QModelIndex &left, const QModelIndex &right) const {
	Device *leftDevice = qobject_cast<Device *>(this->sourceModel()->data(left).value<QObject *>());
	Device *rightDevice = qobject_cast<Device *>(this->sourceModel()->data(right).value<QObject *>());

	return QString::localeAwareCompare(leftDevice->name(), rightDevice->name()) < 0;
}

bool DashboardModel::doFilter() const {
	return d->doFilter;
}

void DashboardModel::setDoFilter(bool doFilter) {
	d->doFilter = doFilter;
	emit doFilterChanged();
	this->invalidateFilter();
}

void DashboardModel::rowsAdded(const QModelIndex &, int start, int end) {
	DeviceModel *model = qobject_cast<DeviceModel *>(this->sourceModel());
	if (!model) {
		return;
	}
	for (int i = start; i <= end; ++i ) {
		Device *device = qobject_cast<Device *>(model->get(i).value<QObject *>());
		connect(device, SIGNAL(isFavoriteChanged()), this, SLOT(deviceChanged()));
		connect(device, SIGNAL(nameChanged()), this, SLOT(invalidate()));
	}
}

void DashboardModel::deviceChanged() {
	this->invalidateFilter();
}

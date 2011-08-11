#ifndef FILTEREDDEVICEMODEL_H
#define FILTEREDDEVICEMODEL_H

#include <QSortFilterProxyModel>

#include "device.h"

class DeviceModel;

class FilteredDeviceModel : public QSortFilterProxyModel
{
	Q_OBJECT
	Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
public:
	explicit FilteredDeviceModel(DeviceModel *model, Device::Type type, QObject *parent = 0);

signals:
	void countChanged();

protected slots:
	void rowsAdded( const QModelIndex & parent, int start, int end );
	void deviceChanged();

protected:
	bool filterAcceptsRow ( int sourceRow, const QModelIndex & ) const;
	bool lessThan(const QModelIndex &left, const QModelIndex &right) const;

private:
	Device::Type type;
};

#endif // FILTEREDDEVICEMODEL_H

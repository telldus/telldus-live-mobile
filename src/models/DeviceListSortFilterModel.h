#ifndef DEVICELISTSORTFILTERMODEL_H
#define DEVICELISTSORTFILTERMODEL_H

#include <QSortFilterProxyModel>

class FilteredDeviceModel;

class DeviceListSortFilterModel : public QSortFilterProxyModel
{
	Q_OBJECT
	Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
public:
	explicit DeviceListSortFilterModel(FilteredDeviceModel *model, QObject *parent = 0);
	~DeviceListSortFilterModel();

signals:
	void countChanged();

protected slots:
	void rowsAdded( const QModelIndex & parent, int start, int end );

protected:
	bool lessThan(const QModelIndex &left, const QModelIndex &right) const;

private:

};

#endif // DEVICELISTSORTFILTERMODEL_H

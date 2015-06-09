#ifndef ABSTRACTFILTEREDDEVICEMODEL_H
#define ABSTRACTFILTEREDDEVICEMODEL_H

#include <QSortFilterProxyModel>

class DeviceModel;
class Device;

class AbstractFilteredDeviceModel : public QSortFilterProxyModel
{
	Q_OBJECT
	Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
public:
	explicit AbstractFilteredDeviceModel(DeviceModel *model, QObject *parent = 0);
	virtual ~AbstractFilteredDeviceModel();

signals:
	void countChanged();

protected slots:
	void rowsAdded( const QModelIndex & parent, int start, int end );
	void deviceChanged();

protected:
	bool filterAcceptsRow ( int sourceRow, const QModelIndex & ) const;
	virtual bool filterAcceptsDevice( Device * ) const;
	void deviceAdded(Device *) const;
	bool lessThan(const QModelIndex &left, const QModelIndex &right) const;
};

#endif // ABSTRACTFILTEREDDEVICEMODEL_H

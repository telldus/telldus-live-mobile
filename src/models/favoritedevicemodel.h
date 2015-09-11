#ifndef FAVORITEDEVICEMODEL_H
#define FAVORITEDEVICEMODEL_H

#include <QSortFilterProxyModel>

class DeviceModel;

class FavoriteDeviceModel : public QSortFilterProxyModel
{
	Q_OBJECT
	Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
public:
	explicit FavoriteDeviceModel(DeviceModel *model, QObject *parent = 0);
	~FavoriteDeviceModel();

signals:
	void countChanged();
	void aDeviceChanged();

protected slots:
	void deviceChanged();

protected:
	bool filterAcceptsRow ( int sourceRow, const QModelIndex & ) const;
	bool lessThan(const QModelIndex &left, const QModelIndex &right) const;

private:

};

#endif // FAVORITEDEVICEMODEL_H

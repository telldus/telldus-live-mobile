#ifndef FAVORITEMODEL_H
#define FAVORITEMODEL_H

#include <QSortFilterProxyModel>

class DeviceModel;

class FavoriteModel : public QSortFilterProxyModel
{
	Q_OBJECT
	Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
public:
	explicit FavoriteModel(DeviceModel *model, QObject *parent = 0);

signals:
	void countChanged();

protected slots:
	void rowsAdded( const QModelIndex & parent, int start, int end );
	void deviceChanged();

protected:
	bool filterAcceptsRow ( int sourceRow, const QModelIndex & ) const;
};

#endif // FAVORITEMODEL_H

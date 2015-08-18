#ifndef FAVORITESENSORMODEL_H
#define FAVORITESENSORMODEL_H

#include <QSortFilterProxyModel>

class SensorModel;

class FavoriteSensorModel : public QSortFilterProxyModel
{
	Q_OBJECT
	Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
public:
	explicit FavoriteSensorModel(SensorModel *model, QObject *parent = 0);
	~FavoriteSensorModel();

signals:
	void countChanged();

protected slots:
	void rowsAdded( const QModelIndex & parent, int start, int end );
	void sensorChanged();

protected:
	bool filterAcceptsRow ( int sourceRow, const QModelIndex & ) const;
	bool lessThan(const QModelIndex &left, const QModelIndex &right) const;

private:

};

#endif // FAVORITESENSORMODEL_H

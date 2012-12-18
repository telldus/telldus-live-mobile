#ifndef FAVORITEMODEL_H
#define FAVORITEMODEL_H

#include <QSortFilterProxyModel>

class DeviceModel;

class FavoriteModel : public QSortFilterProxyModel
{
	Q_OBJECT
	Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
	Q_PROPERTY(bool doFilter READ doFilter WRITE setDoFilter NOTIFY doFilterChanged)
public:
	explicit FavoriteModel(DeviceModel *model, QObject *parent = 0);
	~FavoriteModel();

signals:
	void countChanged();
	void doFilterChanged();

protected slots:
	void rowsAdded( const QModelIndex & parent, int start, int end );
	void deviceChanged();

protected:
	bool filterAcceptsRow ( int sourceRow, const QModelIndex & ) const;
	bool lessThan(const QModelIndex &left, const QModelIndex &right) const;

private:
	class PrivateData;
	PrivateData *d;
	bool doFilter() const;
	void setDoFilter(bool doFilter);

};

#endif // FAVORITEMODEL_H

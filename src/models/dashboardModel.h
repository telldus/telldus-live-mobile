#ifndef DASHBOARDMODEL_H
#define DASHBOARDMODEL_H

#include <QSortFilterProxyModel>

class DeviceModel;

class DashboardModel : public QSortFilterProxyModel
{
	Q_OBJECT
	Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
	Q_PROPERTY(bool doFilter READ doFilter WRITE setDoFilter NOTIFY doFilterChanged)
public:
	explicit DashboardModel(DeviceModel *model, QObject *parent = 0);
	~DashboardModel();

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

#endif // DASHBOARDMODEL_H

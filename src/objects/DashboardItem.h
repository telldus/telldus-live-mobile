#ifndef DASHBOARDITEM_H
#define DASHBOARDITEM_H

#include <QObject>
#include <QMetaType>
#include <QVariant>

class DashboardItem : public QObject
{
	Q_OBJECT
	Q_ENUMS(ChildObjectType)
	Q_PROPERTY(int id READ dashboardItemId WRITE setId NOTIFY idChanged)
	Q_PROPERTY(QVariant childObject READ childObject WRITE setChildObject NOTIFY childObjectChanged)
	Q_PROPERTY(ChildObjectType childObjectType READ childObjectType NOTIFY childObjectTypeChanged)

public:
	explicit DashboardItem(QObject *parent = 0);
	~DashboardItem();

	enum ChildObjectType { UnknownChildObjectType, DeviceChildObjectType, SensorChildObjectType, WeatherChildObjectType };

	int dashboardItemId() const;
	void setId(int id);

	QVariant childObject() const;
	void setChildObject(const QVariant &childObject);

	ChildObjectType childObjectType() const;

signals:
	void idChanged();
	void childObjectChanged();
	void childObjectTypeChanged();


private slots:
	void fetchData();

private:
	class PrivateData;
	PrivateData *d;
};

Q_DECLARE_METATYPE(DashboardItem*)

#endif // DASHBOARDITEM_H

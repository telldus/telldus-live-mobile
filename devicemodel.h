#ifndef DEVICEMODEL_H
#define DEVICEMODEL_H

#include "tlistmodel.h"

class Device;

class DeviceModel : public TListModel
{
	Q_OBJECT
public:
	Q_INVOKABLE void addDevices(const QVariantList &devices);
	Q_INVOKABLE Device *findDevice(int id) const;

	static DeviceModel *instance();

signals:
	void devicesLoaded(const QVariantList &devices);

private slots:
	void authorizationChanged();
	void onDevicesList(const QVariantMap &result);

private:
	explicit DeviceModel(QObject *parent = 0);
	class PrivateData;
	PrivateData *d;
};

#endif // DEVICEMODEL_H

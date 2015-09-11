#ifndef DEVICEMODEL_H
#define DEVICEMODEL_H

#include "tlistmodel.h"

class Device;

class DeviceModel : public TListModel
{
	Q_OBJECT
public:
	Q_INVOKABLE void addDevices(const QVariantList &devices);
	Q_INVOKABLE void createGroup(int clientId, const QString &name, Device *device);
	Q_INVOKABLE Device *findDevice(int id) const;
	Q_INVOKABLE void removeDevice(int id);

	static DeviceModel *instance();

signals:
	void devicesLoaded(const QVariantList &devices);

private slots:
	void authorizationChanged();
	void onDeviceInfo(const QVariantMap &result);
	void onDeviceRemove(const QVariantMap &result, const QVariantMap &params);
	void onDevicesList(const QVariantMap &result);
	void onGroupAdd(const QVariantMap &result);
	void fetchDataFromCache();

private:
	explicit DeviceModel(QObject *parent = 0);
	class PrivateData;
	PrivateData *d;
};

#endif // DEVICEMODEL_H

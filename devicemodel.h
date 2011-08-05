#ifndef DEVICEMODEL_H
#define DEVICEMODEL_H

#include "tlistmodel.h"

class Device;

class DeviceModel : public TListModel
{
	Q_OBJECT
public:
	explicit DeviceModel(QObject *parent = 0);

	Q_INVOKABLE void addDevices(const QVariantList &devices);
	Q_INVOKABLE Device *findDevice(int id) const;

signals:

private slots:
	void authorizationChanged();
	void onDevicesList(const QVariantMap &result);
};

#endif // DEVICEMODEL_H

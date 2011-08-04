#ifndef DEVICEMODEL_H
#define DEVICEMODEL_H

#include "tlistmodel.h"

class DeviceModel : public TListModel
{
	Q_OBJECT
public:
	explicit DeviceModel(QObject *parent = 0);

	Q_INVOKABLE void addDevices(const QVariantList &devices);

signals:

public slots:

};

#endif // DEVICEMODEL_H

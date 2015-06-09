#ifndef FILTEREDDEVICEMODEL_H
#define FILTEREDDEVICEMODEL_H

#include "abstractfiltereddevicemodel.h"

#include "device.h"

class FilteredDeviceModel : public AbstractFilteredDeviceModel
{
	Q_OBJECT
public:
	explicit FilteredDeviceModel(DeviceModel *model, Device::Type type, QObject *parent = 0);

protected:
	bool filterAcceptsDevice ( Device * ) const;
	virtual void deviceAdded( Device * ) const;

private:
	Device::Type type;
};

#endif // FILTEREDDEVICEMODEL_H

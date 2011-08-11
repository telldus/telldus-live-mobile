#ifndef GROUPDEVICEMODEL_H
#define GROUPDEVICEMODEL_H

#include "abstractfiltereddevicemodel.h"

class GroupDeviceModel : public AbstractFilteredDeviceModel
{
	Q_OBJECT
public:
	explicit GroupDeviceModel(QObject *parent = 0);
	~GroupDeviceModel();

	void addDevices(const QList<int> &devices);
	bool hasDevice(int deviceId) const;
	void removeDevices(const QList<int> &devices);

protected:
	bool filterAcceptsDevice ( Device * ) const;
	void deviceAdded( Device * );

private:
	class PrivateData;
	PrivateData *d;
};

#endif // GROUPDEVICEMODEL_H

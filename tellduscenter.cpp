#include "tellduscenter.h"
#include <QtDeclarative>
#include "tellduslive.h"
#include "devicemodel.h"
#include "sensormodel.h"
#include "device.h"
#include "sensor.h"

class TelldusCenter::PrivateData {
public:
	QDeclarativeView *view;
	DeviceModel *deviceModel;
	SensorModel *sensorModel;
};

TelldusCenter::TelldusCenter(QDeclarativeView *view, QObject *parent) :
	QObject(parent)
{
	d = new PrivateData;
	d->view = view;
	d->deviceModel = new DeviceModel(this);
	d->sensorModel = new SensorModel(this);

	qmlRegisterType<TListModel>("Telldus", 1, 0, "TListModel");
	qmlRegisterType<Device>("Telldus", 1, 0, "Device");
	qmlRegisterType<Sensor>("Telldus", 1, 0, "Sensor");
	qRegisterMetaType<QModelIndex>("QModelIndex");

	double scaleFactor = 1.0;
#ifdef Q_WS_MAEMO_5
	scaleFactor = 2.0;
#endif

	d->view->rootContext()->setContextProperty("telldusLive", TelldusLive::instance());
	d->view->rootContext()->setContextProperty("deviceModel", d->deviceModel);
	d->view->rootContext()->setContextProperty("sensorModel", d->sensorModel);
	d->view->rootContext()->setContextProperty("SCALEFACTOR", scaleFactor);
}

TelldusCenter::~TelldusCenter() {
	delete d;
}

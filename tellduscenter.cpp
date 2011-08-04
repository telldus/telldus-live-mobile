#include "tellduscenter.h"
#include <QtDeclarative>
#include "tellduslive.h"
#include "tlistmodel.h"
#include "device.h"

class TelldusCenter::PrivateData {
public:
	QDeclarativeView *view;
	TelldusLive telldusLive;
	TListModel *deviceModel;
};

TelldusCenter::TelldusCenter(QDeclarativeView *view, QObject *parent) :
    QObject(parent)
{
	d = new PrivateData;
	d->view = view;
	d->deviceModel = new TListModel("device", this);

	qmlRegisterType<TListModel>("Telldus", 1, 0, "TListModel");
	qmlRegisterType<Device>("Telldus", 1, 0, "Device");

	double scaleFactor = 1.0;
#ifdef Q_WS_MAEMO_5
	scaleFactor = 2.0;
#endif

	d->view->rootContext()->setContextProperty("telldusLive", &d->telldusLive);
	d->view->rootContext()->setContextProperty("deviceModel", d->deviceModel);
	d->view->rootContext()->setContextProperty("SCALEFACTOR", scaleFactor);

	connect(&d->telldusLive, SIGNAL(authorizedChanged()), this, SLOT(authorizationChanged()));
	this->authorizationChanged();
}

TelldusCenter::~TelldusCenter() {
	delete d;
}

void TelldusCenter::authorizationChanged() {
	if (d->telldusLive.isAuthorized()) {
		TelldusLiveParams params;
		params["supportedMethods"] = 23; //TODO: Use constants
		d->telldusLive.call("devices/list", params, this, SLOT(onDevicesList(QVariantMap)));
	}
}

void TelldusCenter::onDevicesList(const QVariantMap &result) {
	QVariantList deviceList = result["device"].toList();
	foreach(QVariant v, deviceList) {
		QVariantMap dev = v.toMap();

		Device *device = new Device(this);
		device->setId(dev["id"].toInt());
		device->setMethods(dev["methods"].toInt());
		device->setName(dev["name"].toString());
		device->setOnline(dev["online"].toBool());
		device->setState(dev["state"].toInt());
		device->setStateValue(dev["statevalue"].toString());
		d->deviceModel->append(device);
	}

}

#include "tellduscenter.h"
#include <QtDeclarative>
#include "tellduslive.h"
#include "devicemodel.h"
#include "device.h"

class TelldusCenter::PrivateData {
public:
	QDeclarativeView *view;
	TelldusLive telldusLive;
	DeviceModel *deviceModel;
};

TelldusCenter::TelldusCenter(QDeclarativeView *view, QObject *parent) :
    QObject(parent)
{
	d = new PrivateData;
	d->view = view;
	d->deviceModel = new DeviceModel(this);

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

	d->deviceModel->addDevices(result["device"].toList());

}

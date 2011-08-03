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

}

TelldusCenter::~TelldusCenter() {
	delete d;
}

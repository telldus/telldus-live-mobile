#include <QtGui/QApplication>
#include <QtDeclarative>
#include "tellduscenter.h"
#include "tellduslive.h"

int main(int argc, char *argv[])
{
	Q_INIT_RESOURCE(resources);

	QApplication app(argc, argv);

	QCoreApplication::setOrganizationName("telldus");
	QCoreApplication::setOrganizationDomain("com.telldus");
	QCoreApplication::setApplicationName("TelldusCenter Light");
	QCoreApplication::setApplicationVersion("Android-1.0");

	QDeclarativeView *viewer = new QDeclarativeView();
	viewer->setWindowTitle("TelldusCenter Light");

	TelldusCenter tc(viewer);

	viewer->setResizeMode(QDeclarativeView::SizeRootObjectToView);
	viewer->setSource(QUrl("qrc:/phone/main.qml"));
	viewer->showFullScreen();

	return app.exec();
}

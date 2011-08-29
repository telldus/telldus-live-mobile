#include <QtGui/QApplication>
#include "qmlapplicationviewer.h"
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

	QmlApplicationViewer *viewer = new QmlApplicationViewer();
	viewer->setWindowTitle("TelldusCenter Light");

	TelldusCenter tc(viewer);

	viewer->setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
	viewer->setSource(QUrl("qrc:/qml/main.qml"));
	viewer->showExpanded();

	return app.exec();
}

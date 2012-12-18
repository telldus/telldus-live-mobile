#include <QtGui/QApplication>
#include <QtDeclarative>
#include <QDesktopWidget>
#include "tellduscenter.h"
#include "tellduslive.h"

int main(int argc, char *argv[])
{
	Q_INIT_RESOURCE(resources);

	QApplication app(argc, argv);
#ifdef PLATFORM_ANDROID
	app.setFont(QFont("Roboto"));
#endif

	QCoreApplication::setOrganizationName("telldus");
	QCoreApplication::setOrganizationDomain("com.telldus");
	QCoreApplication::setApplicationName("TelldusCenter Light");
	QCoreApplication::setApplicationVersion("Android-1.0");

	QDeclarativeView *viewer = new QDeclarativeView();
	viewer->setWindowTitle("TelldusCenter Light");

	TelldusCenter tc(viewer);

	viewer->setResizeMode(QDeclarativeView::SizeRootObjectToView);
	viewer->setSource(QUrl("qrc:/phone/main.qml"));

#ifdef PLATFORM_BB10
	QDesktopWidget s;
	QRect size = s.availableGeometry();

	viewer->resize(size.width(), size.height());
#endif

#if defined(PLATFORM_DESKTOP)
	viewer->show();
#elif defined(PLATFORM_ANDROID)
	viewer->show();
#else
	viewer->showFullScreen();
#endif

	return app.exec();
}

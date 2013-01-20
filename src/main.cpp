#include <QtGui/QApplication>
#include <QtDeclarative>
#include <QDesktopWidget>
#include <QGLWidget>
#include "tellduscenter.h"
#include "tellduslive.h"
#include "config.h"

#ifdef PLATFORM_IOS
	#include <QtPlugin>
	Q_IMPORT_PLUGIN(UIKit)
	Q_IMPORT_PLUGIN(qsqlite)
	Q_IMPORT_PLUGIN(qsvg)
#endif

int main(int argc, char *argv[])
{
	Q_INIT_RESOURCE(resources);

	QApplication app(argc, argv);
#ifdef PLATFORM_ANDROID
	app.setFont(QFont("Roboto"));
#endif

	QCoreApplication::setOrganizationName("telldus");
	QCoreApplication::setOrganizationDomain("com.telldus");
	QCoreApplication::setApplicationName("Telldus Live! Mobile");
	QCoreApplication::setApplicationVersion("Android-1.0");

	QDeclarativeView *viewer = new QDeclarativeView();
#ifdef PLATFORM_BB10
	// This is needed because OpenGL viewport doesn't support partial updates.
	viewer->setViewportUpdateMode(QGraphicsView::FullViewportUpdate);
	viewer->setViewport(new QGLWidget);
#endif

	viewer->setWindowTitle("Telldus Live! mobile");
	viewer->rootContext()->setContextProperty("HAVE_WEBKIT", HAVE_WEBKIT);

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

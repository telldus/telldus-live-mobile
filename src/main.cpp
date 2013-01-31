#include <QtGui/QApplication>
#include "tellduscenter.h"
#include "tellduslive.h"
#include "view.h"
#include <QDebug>

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

	View *viewer = new View();
	TelldusCenter tc(viewer);

	viewer->loadAndShow();

	return app.exec();
}

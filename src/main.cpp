#include <QtGui/QApplication>
#include "tellduscenter.h"
#include "tellduslive.h"
#include "config.h"
#include <QDebug>

#include "commonview.h"

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
	QCoreApplication::setApplicationVersion(VERSION);

	CommonView *viewer = new CommonView();
	TelldusCenter tc(viewer);

	viewer->loadAndShow();

	return app.exec();
}

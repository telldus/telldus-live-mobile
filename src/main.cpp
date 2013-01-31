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

#if defined(PLATFORM_DESKTOP)
	viewer->show();
	int w = 0, h = 0;
	QStringList args = app.arguments();
	for(int i = 1; i < args.length(); ++i) {
		if (args.at(i) == "--width") {
			w = args.at(i+1).toInt();
			++i;
			continue;
		} else if (args.at(i) == "--height") {
			h = args.at(i+1).toInt();
			++i;
			continue;
		}
	}
	if (w > 0 && h > 0) {
		viewer->setFixedSize(w, h);
	}
#elif defined(PLATFORM_ANDROID)
	viewer->show();
#elif defined(PLATFORM_IOS)
	viewer->show();
#else
	viewer->showFullScreen();
#endif

	viewer->load();

	return app.exec();
}

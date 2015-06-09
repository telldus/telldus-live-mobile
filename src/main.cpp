#include <QtWidgets/QApplication>
#include "tellduscenter.h"
#include "tellduslive.h"
#include "config.h"
#include <QDebug>

#include "commonview.h"

#ifdef PLATFORM_IOS
	#include <QtPlugin>
	Q_IMPORT_PLUGIN(QSvgPlugin)
	Q_IMPORT_PLUGIN(QSQLiteDriverPlugin)
#endif

#ifdef Q_OS_IOS
extern "C" int qtmn(int argc, char *argv[])
#else
int main(int argc, char *argv[])
#endif
{
	QScopedPointer<QApplication> app(new QApplication(argc, argv));

	QCoreApplication::setOrganizationName("telldus");
	QCoreApplication::setOrganizationDomain("com.telldus");
	QCoreApplication::setApplicationName("Telldus Live! Mobile");
	QCoreApplication::setApplicationVersion(VERSION);

	CommonView *viewer = new CommonView();
	TelldusCenter tc(viewer);

	viewer->loadAndShow();

	return app->exec();
}
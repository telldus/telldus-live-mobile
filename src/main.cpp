#include <QtWidgets/QApplication>
#include <QDebug>

#include "commonview.h"
#include "config.h"
#include "tellduscenter.h"
#include "tellduslive.h"

#ifdef PLATFORM_DESKTOP
	#include "utils/errorhandler.h"
#endif

#ifdef PLATFORM_IOS
	#include <QtPlugin>
	Q_IMPORT_PLUGIN(QSvgPlugin)
	Q_IMPORT_PLUGIN(QSQLiteDriverPlugin)

	#include "ObjectiveUtils.h"
	#include "QtAppDelegate-C-Interface.h"
#endif

int init(int argc, char *argv[]) {

#ifdef PLATFORM_DESKTOP
	qInstallMessageHandler(errorHandler);
#endif

#ifdef PLATFORM_IOS
	QtAppDelegateInitialize();
	ObjectiveUtils::setGoodStatusBarStyle();
#endif

	qDebug().noquote() << QString("[FEATURE] Logging: %1").arg(IS_FEATURE_LOGGING_ENABLED ? "Enabled" : "Disabled");
	qDebug().noquote() << QString("[FEATURE] Websockets: %1").arg(IS_FEATURE_WEBSOCKETS_ENABLED ? "Enabled" : "Disabled");
	qDebug().noquote() << QString("[FEATURE] GoogleAnalytics: %1").arg(IS_FEATURE_GOOGLEANALYTICS_ENABLED ? "Enabled" : "Disabled");

	QScopedPointer<QApplication> app(new QApplication(argc, argv));
	QCoreApplication::setOrganizationName("telldus");
	QCoreApplication::setOrganizationDomain("com.telldus");
	QCoreApplication::setApplicationName("Telldus Live! Mobile");
	QCoreApplication::setApplicationVersion(VERSION);

	CommonView *viewer = new CommonView();
	TelldusCenter tc(viewer);

	viewer->loadAndShow();

	int retval = app->exec();
#ifdef PLATFORM_BB10
	// For some reason the app won't quit properly on BB10. This is a workaround.
	// Feel free to remove it if is fixed in a later SDK.
	exit(0);
#endif
	return retval;
}

#ifdef PLATFORM_IOS
extern "C" int qtmn(int argc, char *argv[]) {
#else
int main(int argc, char *argv[]) {
#endif
return init(argc, argv);
}

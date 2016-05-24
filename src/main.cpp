#include <QGuiApplication>
#include <QTranslator>
#include <QDebug>

#include "commonview.h"
#include "config.h"
#include "tellduscenter.h"
#include "tellduslive.h"

#include "utils/Logger.h"

#ifdef PLATFORM_IOS
	#include <QtPlugin>
	Q_IMPORT_PLUGIN(QSvgPlugin)
	Q_IMPORT_PLUGIN(QSQLiteDriverPlugin)

	#include "ObjectiveUtils.h"
	#include "QtAppDelegate-C-Interface.h"
#endif


int main(int argc, char **argv) {

#ifdef PLATFORM_IOS
	QtAppDelegateInitialize();
	ObjectiveUtils::setGoodStatusBarStyle();
#endif

	QGuiApplication app(argc,argv);
	app.setOrganizationName("telldus");
	app.setOrganizationDomain("com.telldus");
	app.setApplicationName("Telldus Live! Mobile");
	app.setApplicationVersion(VERSION);

#ifndef PLATFORM_ANDROID
	Logger::instance();
	qDebug() << "[APP] Logger is active!";
#endif

	QStringList args = QCoreApplication::arguments();
	QString forceLanguage;
	for(int i = 1; i < args.length(); ++i) {
		if (args.at(i) == "--force-language") {
			forceLanguage = args.at(i+1);
			++i;
			continue;
		}
	}

	qDebug().noquote() << QString("[ENVIRONMENT] QtVersion: 0x%1").arg(QT_VERSION, 5, 16, QChar('0'));
	qDebug().noquote() << QString("[FEATURE] Logging: %1").arg(IS_FEATURE_LOGGING_ENABLED ? "Enabled" : "Disabled");
	qDebug().noquote() << QString("[FEATURE] Websockets: %1").arg(IS_FEATURE_WEBSOCKETS_ENABLED ? "Enabled" : "Disabled");
	qDebug().noquote() << QString("[FEATURE] GoogleAnalytics: %1").arg(IS_FEATURE_GOOGLEANALYTICS_ENABLED ? "Enabled" : "Disabled");
	qDebug().noquote() << QString("[ENVIRONMENT] Forced Language: %1").arg(forceLanguage);
	qDebug().nospace().noquote() << "[ENVIRONMENT] QLocale Languages: " << QLocale().uiLanguages();

	QTranslator translator;
	if (translator.load(forceLanguage == "" ? QLocale() : forceLanguage, "core", "_", ":/translations", ".qm")) {
		app.installTranslator(&translator);
	} else {
		qDebug() << "[MISC] Unable to load any translation file.";
	}

	CommonView *viewer = new CommonView();
	TelldusCenter tc(viewer);

	viewer->loadAndShow();

#ifdef PLATFORM_BB10
	// For some reason the app won't quit properly on BB10. This is a workaround.
	// Feel free to remove it if is fixed in a later SDK.
	exit(0);
#endif
	return app.exec();
}

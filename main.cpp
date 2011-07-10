#include <QtGui/QApplication>
#include "qmlapplicationviewer.h"
#include <QDeclarativeContext>
#include "tellduslive.h"

int main(int argc, char *argv[])
{
	Q_INIT_RESOURCE(resources);

	QApplication app(argc, argv);

	QCoreApplication::setOrganizationName("telldus");
	QCoreApplication::setOrganizationDomain("com.telldus");
	QCoreApplication::setApplicationName("TelldusCenter Light");
	QCoreApplication::setApplicationVersion("Android-1.0");

	QmlApplicationViewer viewer;
	viewer.setWindowTitle("TelldusCenter Light");

	double scaleFactor = 1.0;
#ifdef Q_WS_MAEMO_5
	scaleFactor = 2.0;
#endif

	TelldusLive telldusLive;
	viewer.rootContext()->setContextProperty("telldusLive", &telldusLive);
	viewer.rootContext()->setContextProperty("SCALEFACTOR", scaleFactor);

	viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
	viewer.setSource(QUrl("qrc:/qml/tellduscenterlight/phone/RootHarmattan.qml"));
	viewer.showFullScreen();

	return app.exec();
}

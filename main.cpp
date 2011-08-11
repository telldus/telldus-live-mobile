#include <QtGui/QApplication>
#include <applauncherd/MDeclarativeCache>
#include <QtDeclarative>
#include "tellduscenter.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
	Q_INIT_RESOURCE(resources);

	QApplication *app = MDeclarativeCache::qApplication(argc, argv);

	QCoreApplication::setOrganizationName("telldus");
	QCoreApplication::setOrganizationDomain("com.telldus");
	QCoreApplication::setApplicationName("TelldusCenter Light");
	QCoreApplication::setApplicationVersion("Android-1.0");

	QDeclarativeView *viewer = MDeclarativeCache::qDeclarativeView();
	viewer->setWindowTitle("TelldusCenter Light");

	TelldusCenter tc(viewer);

	viewer->setSource(QUrl("qrc:/qml/tellduscenterlight/phone/RootHarmattan.qml"));
	viewer->showFullScreen();

	return app->exec();
}

#include "view.h"
#include <QtDeclarative>
#include <QDesktopWidget>
#include <QGLWidget>
#include "config.h"

class View::PrivateData {
public:
};

View::View(QWidget *parent) :
	QDeclarativeView(parent)
{
	d = new PrivateData;

#ifdef PLATFORM_BB10
	// This is needed because OpenGL viewport doesn't support partial updates.
	this->setViewportUpdateMode(QGraphicsView::FullViewportUpdate);
	this->setViewport(new QGLWidget);
#endif

	this->setWindowTitle("Telldus Live! mobile");
	this->rootContext()->setContextProperty("HAVE_WEBKIT", HAVE_WEBKIT);

	this->setResizeMode(QDeclarativeView::SizeRootObjectToView);
	
#ifdef PLATFORM_BB10
	QDesktopWidget s;
	QRect size = s.availableGeometry();
	
	this->resize(size.width(), size.height());
#endif

}

View::~View() {
	delete d;
}

void View::load() {
	this->setSource(QUrl("qrc:/phone/main.qml"));
}

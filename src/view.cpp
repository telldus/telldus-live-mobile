#include "view.h"
#include <QtDeclarative>
#include <QDesktopWidget>
#include <QGLWidget>
#include <QResizeEvent>
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
	this->rootContext()->setContextProperty("SCALEFACTOR", 1);  // Default value, resizeEvent() overrides this

	
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

void View::resizeEvent ( QResizeEvent * event ) {
	QDeclarativeView::resizeEvent(event);
	QSize s = event->size();
	if (s.width() == 0 || s.height() == 0) {
		return;
	}

	if (s.height() < 500) {
		this->rootContext()->setContextProperty("SCALEFACTOR", 0.5);
	}
}

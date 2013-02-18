#include "view.h"
#include <QtDeclarative>
#include <QDesktopWidget>
#include <QGLWidget>
#include <QResizeEvent>
#include <QDesktopWidget>
#include "config.h"

class View::PrivateData {
public:
};

View::View(QWidget *parent) :
	QDeclarativeView(parent)
{
	d = new PrivateData;
	connect(QApplication::desktop(), SIGNAL(workAreaResized(int)), this, SLOT(workAreaResized(int)));

#ifdef PLATFORM_BB10
	// This is needed because OpenGL viewport doesn't support partial updates.
	this->setViewportUpdateMode(QGraphicsView::FullViewportUpdate);
	this->setViewport(new QGLWidget);
#endif

	this->setWindowTitle("Telldus Live! mobile");
	this->rootContext()->setContextProperty("HAVE_WEBKIT", HAVE_WEBKIT);

	this->setResizeMode(QDeclarativeView::SizeRootObjectToView);
	this->rootContext()->setContextProperty("SCALEFACTOR", 1);  // Default value, resizeEvent() overrides this
}

View::~View() {
	delete d;
}

void View::loadAndShow() {
#if defined(PLATFORM_DESKTOP)
	this->show();
	int w = 0, h = 0;
	QStringList args = QCoreApplication::arguments();
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
	QSize size(w, h);
	if (w > 0 && h > 0) {
		this->setFixedSize(size);
	}
#elif defined(PLATFORM_IOS)
	QSize size(this->windowSize());
	this->show();
	this->resize(size);
#else
	QRect r(QApplication::desktop()->availableGeometry());
	QSize size(r.width(), r.height());
	this->show();
#endif

	this->rootContext()->setContextProperty("HEIGHT", size.height());
	this->rootContext()->setContextProperty("WIDTH", size.width());
	this->setSource(QUrl("qrc:/phone/main.qml"));

#ifdef PLATFORM_BB10
	this->resize(size);
#endif
}

void View::workAreaResized(int screen) {
	QRect r(QApplication::desktop()->availableGeometry());
	this->resize(r.width(), r.height());
}

void View::resizeEvent ( QResizeEvent * event ) {
	QDeclarativeView::resizeEvent(event);
	QSize s = event->size();
	if (s.width() == 0 || s.height() == 0) {
		return;
	}

	double scaleFactor = 1;
	if (s.width() < 450) {
		scaleFactor = 0.5;
	} else if (s.width() < 600) {
		scaleFactor = 0.75;
	}
	this->rootContext()->setContextProperty("SCALEFACTOR", scaleFactor);
}

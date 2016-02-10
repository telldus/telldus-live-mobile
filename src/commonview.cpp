#include "commonview.h"

#include <QApplication>
#include <QtQuick>
#include <QDesktopWidget>
#include <QKeyEvent>
#include <QResizeEvent>
#include <QTouchEvent>

#include "config.h"
#include "ColorImageProvider.h"

#ifdef PLATFORM_IOS
Q_IMPORT_PLUGIN(QtQuick2Plugin)
Q_IMPORT_PLUGIN(QQmlLocalStoragePlugin)
Q_IMPORT_PLUGIN(QtQuick2WindowPlugin)
Q_IMPORT_PLUGIN(QWebViewModule)
#endif

class CommonView::PrivateData {
public:
	QQuickView view;
	double scalefactor;
	QString platform;
};

CommonView::CommonView(QObject *parent):AbstractView(parent) {
	d = new PrivateData;
	d->scalefactor = 0;
	d->platform = "Desktop";

	// For platform specific tasks
	this->init();

#ifdef PLATFORM_IOS
	qobject_cast<QQmlExtensionPlugin*>(qt_static_plugin_QtQuick2Plugin().instance())->registerTypes("QtQuick");
	qobject_cast<QQmlExtensionPlugin*>(qt_static_plugin_QQmlLocalStoragePlugin().instance())->registerTypes("QtQuick.LocalStorage");
	qobject_cast<QQmlExtensionPlugin*>(qt_static_plugin_QtQuick2WindowPlugin().instance())->registerTypes("QtQuick.Window");
	qobject_cast<QQmlExtensionPlugin*>(qt_static_plugin_QWebViewModule().instance())->registerTypes("QtWebView");
#endif

	d->view.installEventFilter(this);
//	connect(QApplication::desktop(), SIGNAL(workAreaResized(int)), this, SLOT(workAreaResized(int)));

	d->view.setTitle("Telldus Live! mobile");
	d->view.rootContext()->setContextProperty("HAVE_WEBKIT", HAVE_WEBKIT);

	d->view.setResizeMode(QQuickView::SizeRootObjectToView);
	d->view.rootContext()->setContextProperty("SCALEFACTOR", 1);  // Default value, resizeEvent() overrides this

	QQmlEngine *engine = d->view.engine();
	//QQuickImageProvider *i = new QQuickImageProvider(QQuickImageProvider::Pixmap);
	ColorImageProvider *i = new ColorImageProvider();
	engine->addImageProvider(QLatin1String("icons"), i);
}

CommonView::~CommonView() {
	delete d;
}

#ifndef PLATFORM_IOS
void CommonView::init() {
	// Do nothing
}
#endif  // PLATFORM_IOS

void CommonView::loadAndShow() {
d->platform = QGuiApplication::platformName().toLower();
#if defined(PLATFORM_DESKTOP)
	d->platform = "desktop";
	d->view.show();
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
		} else if (args.at(i) == "--scalefactor") {
			d->scalefactor = args.at(i+1).toDouble();
			qDebug().nospace().noquote() << "[ARGS] --scalefactor " << args.at(i+1).toDouble();
			++i;
			continue;
		} else if (args.at(i) == "--platform-override") {
			d->platform = args.at(i+1).toLower();
			qDebug().nospace().noquote() << "[ARGS] --platform-override " << args.at(i+1);
			++i;
			continue;
		}
	}
	QSize size(w, h);
	if (w > 0 && h > 0) {
		d->view.resize(size);
	}
#elif defined(PLATFORM_IOS)
	d->platform = "ios";
	QSize size(this->windowSize());
	d->view.showFullScreen();
#elif defined(PLATFORM_ANDROID)
	d->platform = "android";
	QSize size = QApplication::desktop()->size();
	d->view.show();
#else
	QRect r(QApplication::desktop()->availableGeometry());
	QSize size(r.width(), r.height());
	d->view.show();
#endif

	qDebug() << "[APP] Display is now visible!";

	qDebug().nospace().noquote() << "[DEVICE] Screen size: " << size;
	qDebug().nospace().noquote() << "[DEVICE] Screen logicalDotsPerInch: " << QApplication::primaryScreen()->logicalDotsPerInch();
	qDebug().nospace().noquote() << "[DEVICE] Screen physicalDotsPerInch: " << QApplication::primaryScreen()->physicalDotsPerInch();
	qDebug().nospace().noquote() << "[DEVICE] Screen devicePixelRatio: " << QApplication::primaryScreen()->devicePixelRatio();
	qDebug().nospace().noquote() << "[DEVICE] Screen virtualGeometry: " << QApplication::primaryScreen()->virtualGeometry();
	qDebug().nospace().noquote() << "[DEVICE] Screen virtualSize: " << QApplication::primaryScreen()->virtualSize();
	qDebug().nospace().noquote() << "[DEVICE] Screen size: " << QApplication::primaryScreen()->size();
	qDebug().nospace().noquote() << "[DEVICE] Screen physicalSize: " << QApplication::primaryScreen()->physicalSize();
	qDebug().nospace().noquote() << "[DEVICE] Screen geometry : " << QApplication::primaryScreen()->geometry ();
	qDebug().nospace().noquote() << "[DEVICE] Screen availableVirtualSize: " << QApplication::primaryScreen()->availableVirtualSize();
	qDebug().nospace().noquote() << "[DEVICE] Screen availableVirtualGeometry: " << QApplication::primaryScreen()->availableVirtualGeometry();
	qDebug().nospace().noquote() << "[DEVICE] Screen availableSize: " << QApplication::primaryScreen()->availableSize();
	qDebug().nospace().noquote() << "[DEVICE] Screen availableGeometry : " << QApplication::primaryScreen()->availableGeometry();
	qDebug().nospace().noquote() << "[QML] Context property: UI_PLATFORM = " << d->platform;

	d->view.rootContext()->setContextProperty("HEIGHT", size.height());
	d->view.rootContext()->setContextProperty("WIDTH", size.width());
	d->view.rootContext()->setContextProperty("UI_PLATFORM", d->platform);
	d->view.engine()->addImportPath(":/qmllib/common");
	d->view.engine()->addImportPath(":/qmlmodules");
	if (UI_TYPE == "TV") {
		d->view.setSource(QUrl("qrc:/resources/qml/main.tv.qml"));
	} else {
		d->view.setSource(QUrl("qrc:/resources/qml/main.qml"));
	}
}

void CommonView::setContextProperty(const QString &name, QObject *value) {
	d->view.rootContext()->setContextProperty(name, value);
}

void CommonView::workAreaResized(int screen) {
	QRect r(QApplication::desktop()->availableGeometry());
	d->view.resize(r.width(), r.height());
}

bool CommonView::eventFilter(QObject *obj, QEvent * event ) {
	if (event->type() == QEvent::TouchEnd) {
		QTouchEvent *touchEvent = static_cast<QTouchEvent *>(event);
		if (!touchEvent->touchPoints().isEmpty()) {
			if ((touchEvent->touchPoints().first().lastPos().x() - touchEvent->touchPoints().first().startPos().x()) > (50 * d->scalefactor)) {
				emit swipedRight();
			}
			if ((touchEvent->touchPoints().first().startPos().x() - touchEvent->touchPoints().first().lastPos().x()) > (50 * d->scalefactor)) {
				emit swipedLeft();
			}
		}
	}
	if (UI_TYPE != "TV") {
		if (event->type() == QEvent::KeyPress) {
			QKeyEvent *keyEvent = static_cast<QKeyEvent *>(event);
			qDebug() << "Keypress: " << event;
			if (keyEvent->key() == Qt::Key_Back) {
				emit backPressed();
				return true;
			}
#ifdef PLATFORM_DESKTOP
			if (keyEvent->key() == Qt::Key_Backspace) {
				emit backPressed();
				return true;
			}
#endif
		}
	}
	if (event->type() != QEvent::Resize) {
		return QObject::eventFilter(obj, event);
	}
	QResizeEvent *resizeEvent = static_cast<QResizeEvent *>(event);

	QSize s = resizeEvent->size();
	if (s.width() == 0 || s.height() == 0) {
		return QObject::eventFilter(obj, event);
	}

	if (d->scalefactor == 0) {
		d->scalefactor = QApplication::primaryScreen()->logicalDotsPerInch() / 72;
#ifdef PLATFORM_BB10
		// BB10 has a DU which is multiplied by 16 gets the logicalDPI
		d->scalefactor = (((QApplication::primaryScreen()->physicalDotsPerInch() / 25.4) / 1.5) * 16) / 72;
#endif
	}
	qDebug().nospace().noquote() << "[DEVICE] Scalefactor: " << d->scalefactor;

//	if (s.width() < 450) {
//		scaleFactor = 0.5;
//	} else if (s.width() < 600) {
//		scaleFactor = 0.75;
//	}
	d->view.rootContext()->setContextProperty("SCALEFACTOR", d->scalefactor);
	return QObject::eventFilter(obj, event);
}

QQuickView *CommonView::view() const {
	return &d->view;
}

#ifndef COMMONVIEW_H
#define COMMONVIEW_H

#include "abstractview.h"
#include <QSize>
#include <QResizeEvent>

class QQuickView;
#ifdef PLATFORM_IOS
@class WebViewDelegate;
#endif  // PLATFORM_IOS

class CommonView : public AbstractView
{
	Q_OBJECT
public:
	explicit CommonView(QObject *parent = 0);
	virtual ~CommonView();

	void loadAndShow();
	void setContextProperty(const QString &name, QObject *value);

signals:
	void fullscreen();
	void backPressed();

protected slots:
	void workAreaResized(int screen);

protected:
	bool eventFilter(QObject *obj, QEvent *event);

private:
	QQuickView *view() const;
	void init();
	class PrivateData;
	PrivateData *d;

#ifdef PLATFORM_IOS
	QSize windowSize() const;
	WebViewDelegate *iosDelegate;
#endif
};

#endif // COMMONVIEW_H

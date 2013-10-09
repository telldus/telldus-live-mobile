#ifndef COMMONVIEW_H
#define COMMONVIEW_H

#include "abstractview.h"
#include <QSize>

class CommonView : public AbstractView
{
	Q_OBJECT
public:
	explicit CommonView(QObject *parent = 0);
	virtual ~CommonView();

	void loadAndShow();
	void setContextProperty( const QString &name, QObject *value);

signals:
	void fullscreen();

protected slots:
	void workAreaResized(int screen);

protected:
//	void resizeEvent( QResizeEvent * event );
//	void changeEvent( QEvent *event );

private:
	class PrivateData;
	PrivateData *d;

#ifdef PLATFORM_IOS
	QSize windowSize() const;
#endif
};

#endif // COMMONVIEW_H

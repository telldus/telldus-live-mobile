#ifndef ABSTRACTVIEW_H
#define ABSTRACTVIEW_H

#include <QObject>

class AbstractView : public QObject
{
	Q_OBJECT
public:
	explicit AbstractView(QObject *parent = 0);
	virtual ~AbstractView();

	virtual void loadAndShow() = 0;
	virtual void setContextProperty( const QString &name, QObject *value) = 0;

/*signals:
	void fullscreen();

protected slots:
	void workAreaResized(int screen);

protected:
	void resizeEvent( QResizeEvent * event );
	void changeEvent( QEvent *event );

private:
	class PrivateData;
	PrivateData *d;

#ifdef PLATFORM_IOS
	QSize windowSize() const;
#endif*/
};

#endif // ABSTRACTVIEW_H

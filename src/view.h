#ifndef VIEW_H
#define VIEW_H

#include <QDeclarativeView>

class View : public QDeclarativeView
{
	Q_OBJECT
public:
	explicit View(QWidget *parent = 0);
	virtual ~View();

	void loadAndShow();

signals:

protected slots:
	void workAreaResized(int screen);

protected:
	void resizeEvent( QResizeEvent * event );

private:
	class PrivateData;
	PrivateData *d;

#ifdef PLATFORM_IOS
	QSize windowSize() const;
#endif
};

#endif // VIEW_H

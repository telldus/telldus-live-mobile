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

public slots:

protected:
	void resizeEvent( QResizeEvent * event );

private:
	class PrivateData;
	PrivateData *d;
};

#endif // VIEW_H

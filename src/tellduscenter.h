#ifndef TELLDUSCENTER_H
#define TELLDUSCENTER_H

#include <QObject>
#include <QVariantList>

class QDeclarativeView;

class TelldusCenter : public QObject
{
	Q_OBJECT
public:
	explicit TelldusCenter(QDeclarativeView *view, QObject *parent = 0);
	virtual ~TelldusCenter();

signals:

public slots:

private:
	class PrivateData;
	PrivateData *d;

#ifdef PLATFORM_IOS
	void init();
#endif
};

#endif // TELLDUSCENTER_H

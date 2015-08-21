#ifndef ABSTRACTNOTIFICATION_H
#define ABSTRACTNOTIFICATION_H

#include <QObject>

class AbstractNotification : public QObject {
	Q_OBJECT
public:
	explicit AbstractNotification(const QString &message, QObject *parent = 0);
	virtual ~AbstractNotification();

	QString message() const;

	virtual void notify() = 0;

private:
	class PrivateData;
	PrivateData *d;
};

#endif // ABSTRACTNOTIFICATION_H

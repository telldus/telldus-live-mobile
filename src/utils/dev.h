#ifndef DEV_H
#define DEV_H

#include <QObject>
#include <QNetworkAccessManager>

class Dev : public QObject
{
	Q_OBJECT
public:
	~Dev();
	static Dev *instance();

signals:

public slots:
	void logScreenView(const QString &screenName);
	void logEvent(const QString &category, const QString &action, const QString &label);

private:
	explicit Dev(QObject *parent = 0);
	class PrivateData;
	PrivateData *d;
	QNetworkAccessManager *nam;

	void init();
	void deinit();

};

#endif // DEV_H

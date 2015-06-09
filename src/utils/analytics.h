#ifndef ANALYTICS_H
#define ANALYTICS_H

#include <QObject>
#include <QNetworkAccessManager>

class Analytics : public QObject
{
	Q_OBJECT
public:
	~Analytics();
	static Analytics *instance();

signals:

public slots:
	void sendScreenView(const QString &screenName);
	void sendEvent(const QString &category, const QString &action, const QString &label);

private:
	explicit Analytics(QObject *parent = 0);
	class PrivateData;
	PrivateData *d;
	QNetworkAccessManager *nam;

	void init();
	void deinit();

};

#endif // ANALYTICS_H

#ifndef ABSTRACTPUSH_H
#define ABSTRACTPUSH_H

#include <QObject>

class AbstractPush : public QObject {
	Q_OBJECT
public:
	explicit AbstractPush(QObject *parent = 0);
	virtual ~AbstractPush();

signals:
	void messageReceived(const QString &message);

protected:
	void registerToken(const QString &token, const QString &deviceName, const QString &manufacturer, const QString &model, const QString &os_version);

private slots:
	void onAuthorizedChanged();
	void registerPushTokenWithApiCallback(const QVariantMap &data);

private:
	class PrivateData;
	PrivateData *d;
};

#endif // ABSTRACTPUSH_H

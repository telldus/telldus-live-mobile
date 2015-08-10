#ifndef JAVADATASTORE_H
#define JAVADATASTORE_H

#include <QObject>
#include <QAndroidJniObject>

class AndroidPushNotifications : public QObject
{
	Q_OBJECT
public:
	explicit AndroidPushNotifications(QObject *parent = 0);
	~AndroidPushNotifications();
	static AndroidPushNotifications *instance();
	void receivePushData(QString token, QString name, QString manufacturer, QString model, QString os_version);

signals:
	void sendRegisterPushTokenWithApi(QString token, QString name, QString manufacturer, QString model, QString os_version);

public slots:

private:
	class PrivateData;
	PrivateData *d;
	static void fromJavaSendRegistrationToServer(JNIEnv *env, jobject thiz, jstring token, jstring name, jstring manufacturer, jstring model, jstring os_version);

};

#endif // JAVADATASTORE_H

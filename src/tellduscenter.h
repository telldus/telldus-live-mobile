#ifndef TELLDUSCENTER_H
#define TELLDUSCENTER_H

#include <QObject>
#include <QVariantList>
#ifdef PLATFORM_ANDROID
#include <QAndroidJniObject>
#endif

class AbstractView;

class TelldusCenter : public QObject
{
	Q_OBJECT
public:
	explicit TelldusCenter(AbstractView *view, QObject *parent = 0);
	virtual ~TelldusCenter();
	static TelldusCenter *instance(AbstractView *view = 0, QObject *parent = 0);

signals:

public slots:
	void openUrl(const QUrl &url);

#ifdef PLATFORM_ANDROID
	static void fromJavaSendRegistrationToServer(JNIEnv *env, jobject thiz, jstring token, jstring name, jstring manufacturer, jstring model, jstring os_version);
#endif

private slots:
	void pushMessageReceived(const QString &message);

private:
	class PrivateData;
	PrivateData *d;

#ifdef PLATFORM_IOS
	void init();
#endif

};

#endif // TELLDUSCENTER_H

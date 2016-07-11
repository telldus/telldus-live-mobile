#include "Push.h"
#include "config.h"

#include <QDebug>

#include <QAndroidJniObject>
#include <QAndroidJniEnvironment>

class Push::PrivateData {
public:
};

Push::Push()
	:AbstractPush()
{
	d = new PrivateData;
	qDebug() << "Telldus welcome to push";
	JNINativeMethod methods[] {{"callNativeSendRegistrationToServer", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", reinterpret_cast<void *>(Push::fromJavaSendRegistrationToServer)}};
	QAndroidJniObject javaClass("com/telldus/live/mobile/RegistrationIntentService");
	QAndroidJniEnvironment env;
	jclass objectClass = env->GetObjectClass(javaClass.object<jobject>());
	// Register native methods
	env->RegisterNatives(objectClass, methods, sizeof(methods) / sizeof(methods[0]));
	env->DeleteLocalRef(objectClass);

	QAndroidJniObject::callStaticMethod<void>("com/telldus/live/mobile/MainActivity", "sendRegistration", "()V");
}

Push::~Push() {
}

void Push::fromJavaSendRegistrationToServer(JNIEnv *env, jobject thiz, jstring token, jstring name, jstring manufacturer, jstring model, jstring os_version, jstring device_id) {
	Q_UNUSED(thiz);
	const char* nativeToken = env->GetStringUTFChars(token, 0);
	const char* nativeName = env->GetStringUTFChars(name, 0);
	const char* nativeManufacturer = env->GetStringUTFChars(manufacturer, 0);
	const char* nativeModel = env->GetStringUTFChars(model, 0);
	const char* nativeOsVersion = env->GetStringUTFChars(os_version, 0);
	const char* nativeDeviceId = env->GetStringUTFChars(device_id, 0);
	qDebug() << "[TelldusCenter] Token from Java in C++" << QString(nativeToken);
	qDebug() << "[TelldusCenter] Name from Java in C++" << QString(nativeName);
	qDebug() << "[TelldusCenter] Model from Java in C++" << QString(nativeModel);
	qDebug() << "[TelldusCenter] Manufacturer from Java in C++" << QString(nativeManufacturer);
	qDebug() << "[TelldusCenter] OsVersion from Java in C++" << QString(nativeOsVersion);
	qDebug() << "[TelldusCenter] DeviceId from Java in C++" << QString(nativeDeviceId);
	Push::instance()->registerToken(QString(nativeToken), QString(nativeName), QString(nativeManufacturer), QString(nativeModel), QString(nativeOsVersion), QString(nativeDeviceId));
}

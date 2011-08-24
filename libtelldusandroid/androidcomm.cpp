#include "androidcomm.h"
#include <android/log.h>
#include <jni.h>

#define LOGI(...) ((void)__android_log_print(ANDROID_LOG_INFO, "Telldus", __VA_ARGS__))

class AndroidComm::PrivateData {
public:
	JavaVM *javaVm;
	jclass cls;
	jmethodID pickImgMethod;

	static AndroidComm *instance;
};

typedef union {
	JNIEnv* nativeEnvironment;
	void* venv;
} UnionJNIEnvToVoid;

AndroidComm *AndroidComm::PrivateData::instance = 0;


AndroidComm::AndroidComm(QObject *parent) :
	QObject(parent)
{
	d = new PrivateData;
	d->javaVm = 0;
}

AndroidComm::~AndroidComm() {
	delete d;
}

void AndroidComm::pickedImage(const QString &imgurl) {
	emit imagePicked(imgurl);
}

void AndroidComm::pickImage() {
	JNIEnv* env;
	if (d->javaVm->AttachCurrentThread(&env, NULL)<0){
		LOGI("AttachCurrentThread failed");
		return ;
	}

	//jstring returnstring = (jstring)
	env->CallStaticVoidMethod(d->cls, d->pickImgMethod);

	/*const char *str = env->GetStringUTFChars(returnstring, NULL);

	LOGI("Return string is %s", str);

	env->ReleaseStringUTFChars(returnstring, str);
	*/
	d->javaVm->DetachCurrentThread();
}

void AndroidComm::setupVM(JavaVM *vm) {
	d->javaVm = vm;

	UnionJNIEnvToVoid uenv;
	uenv.venv = NULL;

	if (vm->GetEnv(&uenv.venv, JNI_VERSION_1_4) != JNI_OK) {
		LOGI("GetEnv failed");
		return;
	}
	JNIEnv *env = uenv.nativeEnvironment;

	d->cls = env->FindClass("eu/licentia/necessitas/industrius/ImageGallery");
	LOGI("Class is %i", (int)d->cls);

	d->pickImgMethod = env->GetStaticMethodID(d->cls, "pickImage", "()V");
	LOGI("Method id is %i", (int)d->pickImgMethod);
}

AndroidComm * AndroidComm::instance() {
	if (PrivateData::instance == 0) {
		PrivateData::instance = new AndroidComm();
	}
	return PrivateData::instance;
}

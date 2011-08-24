#include "androidcomm.h"
#include <jni.h>
#include <android/log.h>

#define LOGI(...) ((void)__android_log_print(ANDROID_LOG_INFO, "Telldus", __VA_ARGS__))

extern "C" {
	JNIEXPORT void JNICALL Java_eu_licentia_necessitas_industrius_ImageGallery_pickedImage(JNIEnv *env, jclass clazz, jstring imageurl);
};

JNIEXPORT void JNICALL Java_eu_licentia_necessitas_industrius_ImageGallery_pickedImage(JNIEnv *env, jclass clazz, jstring imageurl){

	const char *str = env->GetStringUTFChars(imageurl, 0);

	LOGI("Return string is %s", str);
	AndroidComm *comm = AndroidComm::instance();
	comm->pickedImage(str);

	env->ReleaseStringUTFChars(imageurl, str);

	LOGI("TILLBAKAMEDDELANDE!!!");
}

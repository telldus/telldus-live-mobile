#include <QtCore/QCoreApplication>

#include <android/log.h>
#include <jni.h>


Q_DECL_EXPORT jint JNICALL JNI_OnLoad(JavaVM* vm, void* /*reserved*/) {
    __android_log_print(ANDROID_LOG_INFO,"Qt", "Hello from libTelldusAndroid");

    return JNI_VERSION_1_4;
}

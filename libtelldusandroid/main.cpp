#include "androidcomm.h"
#include <android/log.h>
#include <jni.h>


Q_DECL_EXPORT jint JNICALL JNI_OnLoad(JavaVM* vmInit, void* /*reserved*/) {
	AndroidComm *comm = AndroidComm::instance();
	comm->setupVM(vmInit);

	return JNI_VERSION_1_4;
}

#ifndef PUSH_H
#define PUSH_H

#include "AbstractPush.h"

#include <QAndroidJniObject>

class Push : public AbstractPush {
	Q_OBJECT
	friend class AbstractPush;
public:
	virtual ~Push();

	static void fromJavaSendRegistrationToServer(JNIEnv *env, jobject thiz, jstring token, jstring name, jstring manufacturer, jstring model, jstring os_version);

protected:
	explicit Push();

private:
	class PrivateData;
	PrivateData *d;
};

#endif // PUSH_H

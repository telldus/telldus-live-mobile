#ifndef PUSH_H
#define PUSH_H

#include "AbstractPush.h"

class Push : public AbstractPush {
	Q_OBJECT
	friend class AbstractPush;
public:
	virtual ~Push();
	void didRegisterForRemoteNotificationsWithDeviceToken(NSData *deviceToken);

protected:
	explicit Push();

private:
	void registerForPush();

	class PrivateData;
	PrivateData *d;
};

#endif // PUSH_H

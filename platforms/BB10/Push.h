#ifndef PUSH_H
#define PUSH_H

#include "AbstractPush.h"
#include <QAbstractNativeEventFilter>

#include <push/push_payload.h>
#include <push/push_service.h>

class Push : public AbstractPush, QAbstractNativeEventFilter {
	Q_OBJECT
public:
	explicit Push(QObject *parent = 0);
	virtual ~Push();
	virtual bool nativeEventFilter(const QByteArray & eventType, void * message, long * result);

private:
	void processPushPayload(const push_payload_t* payload);
	static void createChannelOnPushTransportReady(push_service_t* ps, int status_code);
	static void onCreateChannelComplete(push_service_t* ps, int status_code);
	static void onCreateSessionComplete(push_service_t* ps, int status_code);
	static int pushIoHandler(int fd, int io_events, void* opaque);
	class PrivateData;
	PrivateData *d;
};

#endif // PUSH_H


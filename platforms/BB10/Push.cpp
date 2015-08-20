#include "Push.h"
#include "config.h"

#include <QAbstractEventDispatcher>
#include <QDebug>

#include <bps/bps.h>
#include <bps/deviceinfo.h>
#include <bps/navigator.h>
#include <bps/navigator_invoke.h>
#include <btapi/btdevice.h>
#include <errno.h>

class Push::PrivateData {
public:
	push_service_t *ps;
	int pushPpsFd;
	static Push *instance;
};
Push *Push::PrivateData::instance = 0;

Push::Push(QObject *parent)
	:AbstractPush(parent), QAbstractNativeEventFilter()
{
	d = new PrivateData;
	QAbstractEventDispatcher::instance()->installNativeEventFilter(this);

	d->ps = NULL;
	int rc = push_service_initialize(&d->ps);
	if (rc == PUSH_FAILURE || (d->ps == NULL)) {
		return;
	}

	int push_pps_fd = push_service_get_fd(d->ps);
	if (push_pps_fd == PUSH_INVALID_PPS_FILE_DESCRIPTOR) {
		return;
	}
	if (bps_add_fd(push_pps_fd, BPS_IO_INPUT, &Push::pushIoHandler, d->ps) == BPS_FAILURE) {
		return;
	}
	rc = push_service_set_provider_application_id(d->ps, PUSH_APPID);
	if (rc == PUSH_FAILURE) {
		return;
	}

	rc = push_service_set_target_key(d->ps, "com.telldus.live.mobile.invoke.push");
	if (rc == PUSH_FAILURE) {
		return;
	}

	rc = push_service_create_session(d->ps, Push::onCreateSessionComplete);
	if (rc == PUSH_FAILURE) {
		return;
	}
	PrivateData::instance = this;
}

Push::~Push() {
	push_service_cleanup(d->ps);
	bps_remove_fd(d->pushPpsFd);
	delete d;
	PrivateData::instance = 0;
}

bool Push::nativeEventFilter(const QByteArray &eventType, void *message, long *result) {
	if (eventType != "bps_event_t") {
		return false;
	}
	bps_event_t *event = static_cast<bps_event_t *>(message);
	if (!event) {
		return false;
	}
	int domain = bps_event_get_domain(event);
	if (domain != navigator_get_domain()) {
		return false;
	}
	int event_type = bps_event_get_code(event);
	if (event_type != NAVIGATOR_INVOKE_TARGET) {
		return false;
	}
	const navigator_invoke_invocation_t *invoke = navigator_invoke_event_get_invocation(event);
	if (!invoke) {
		return false;
	}
	if (QString(navigator_invoke_invocation_get_action(invoke)) != PUSH_INVOCATION_ACTION) {
		return false;
	}
	const unsigned char* raw_invoke_data = (unsigned char*) navigator_invoke_invocation_get_data(invoke);
	int invoke_data_len = navigator_invoke_invocation_get_data_length(invoke);

	push_payload_t* push_payload;
	if(push_payload_create(&push_payload) == PUSH_FAILURE){
		return false;
	}
	if (push_payload_set_payload(push_payload, raw_invoke_data, invoke_data_len) == PUSH_SUCCESS && push_payload_is_valid(push_payload)){
		processPushPayload(push_payload);
	}

	push_payload_destroy(push_payload);
	return false;
}

void Push::processPushPayload(const push_payload_t *payload) {
	const unsigned char* data = push_payload_get_data(payload);
	size_t data_length = push_payload_get_data_length(payload);

	emit messageReceived(QString(QByteArray((const char*)data, data_length)));
}

void Push::createChannelOnPushTransportReady(push_service_t *ps, int status_code) {
	push_service_create_channel(ps, Push::onCreateChannelComplete, Push::createChannelOnPushTransportReady);
}

void Push::onCreateChannelComplete(push_service_t *ps, int status_code) {
	if (!PrivateData::instance) {
		return;
	}
	QString token(push_service_get_token(ps));
	QString deviceName = "Unknown";
	QString model = "Unknown";
	QString osVersion = "Unknown";
	deviceinfo_details_t *details = NULL;
	if (deviceinfo_get_details(&details) == BPS_SUCCESS) {
		model = deviceinfo_details_get_model_name(details);
		osVersion = deviceinfo_details_get_device_os_version(details);
		deviceinfo_free_details(&details);
	}

	char buffer[128];
	const int bufferSize = sizeof(buffer);
	bool ok = false;
	ok = (bt_ldev_get_friendly_name(buffer, bufferSize) == 0);
	if (ok) {
		deviceName = QString::fromLatin1(buffer);
	}

	PrivateData::instance->registerToken(token, deviceName, "BlackBerry", model, osVersion);
}

void Push::onCreateSessionComplete(push_service_t *ps, int status_code) {
	if (status_code != PUSH_NO_ERR) {
		return;
	}
	int rc = push_service_set_ppg_url(ps, PUSH_PPGURL);
	if (rc == PUSH_SUCCESS) {
		push_service_register_to_launch(ps, Push::onRegisterToLaunchComplete);
		push_service_create_channel(ps, Push::onCreateChannelComplete, Push::createChannelOnPushTransportReady);
	}
}

void Push::onRegisterToLaunchComplete(push_service_t *ps, int status_code) {
	// Do nothing
}

int Push::pushIoHandler(int fd, int io_events, void *opaque) {
	push_service_t* ps = (push_service_t*)opaque;
	if (ps == NULL) {
		return BPS_FAILURE;
	}
	int old_fd = push_service_get_fd(ps);

	if (push_service_process_msg(ps) == PUSH_SUCCESS) {
		int new_fd = push_service_get_fd(ps);
		// Push connection has been closed.
		// Need to remove the Push Service file descriptor from
		// the list monitored by BPS.
		if (new_fd == PUSH_INVALID_PPS_FILE_DESCRIPTOR) {
			bps_remove_fd(old_fd);
		}
		return BPS_SUCCESS;
	}
	return BPS_FAILURE;
}

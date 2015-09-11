#include "PropertiesUi.h"
#include "config.h"

class PropertiesUi::PrivateData {
public:
	bool supportsKeys;
	bool supportsTouch;
};

PropertiesUi::PropertiesUi(QObject *parent):QObject(parent) {
	d = new PrivateData;
	if (UI_TYPE == "TV") {
		d->supportsKeys = true;
		d->supportsTouch = false;
	} else {
		d->supportsKeys = false;
		d->supportsTouch = true;
	}
}

PropertiesUi::~PropertiesUi() {
	delete d;
}

bool PropertiesUi::supportsKeys() const {
	return d->supportsKeys;
}

bool PropertiesUi::supportsTouch() const {
	return d->supportsTouch;
}
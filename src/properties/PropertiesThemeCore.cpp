#include "PropertiesThemeCore.h"

class PropertiesThemeCore::PrivateData {
public:
	qreal tilePadding;
};

PropertiesThemeCore::PropertiesThemeCore(QObject *parent):QObject(parent) {
	d = new PrivateData;
	d->tilePadding = 12;
}

PropertiesThemeCore::~PropertiesThemeCore() {
	delete d;
}

qreal PropertiesThemeCore::tilePadding() const {
	return d->tilePadding;
}

void PropertiesThemeCore::setTilePadding(const qreal tilePadding) {
	d->tilePadding = tilePadding;
	emit tilePaddingChanged(tilePadding);
}

#include "PropertiesTheme.h"
#include "properties/PropertiesThemeColors.h"
#include "properties/PropertiesThemeCore.h"

class PropertiesTheme::PrivateData {
public:
	PropertiesThemeColors *colors;
	PropertiesThemeCore *core;
};

PropertiesTheme::PropertiesTheme(QObject *parent):QObject(parent) {
	d = new PrivateData;
	d->colors = new PropertiesThemeColors(this);
	d->core = new PropertiesThemeCore(this);
}

PropertiesTheme::~PropertiesTheme() {
	delete d;
}

PropertiesThemeColors *PropertiesTheme::colors() const {
	return d->colors;
}

PropertiesThemeCore *PropertiesTheme::core() const {
	return d->core;
}
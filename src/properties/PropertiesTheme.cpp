#include "PropertiesTheme.h"
#include "properties/PropertiesThemeColors.h"
#include "properties/PropertiesThemeCore.h"

class PropertiesTheme::PrivateData {
public:
	PropertiesThemeColors *colors;
	PropertiesThemeCore *core;
	bool isMaterialDesign;
};

PropertiesTheme::PropertiesTheme(QObject *parent):QObject(parent) {
	d = new PrivateData;
	d->colors = new PropertiesThemeColors(this);
	d->core = new PropertiesThemeCore(this);
#ifdef PLATFORM_IOS
	d->isMaterialDesign = false;
#endif
#ifdef PLATFORM_DESKTOP
	d->isMaterialDesign = false;
#endif
#ifdef PLATFORM_ANDROID
	d->isMaterialDesign = true;
#endif
#ifdef PLATFORM_BB10
	d->isMaterialDesign = false;
#endif
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

bool PropertiesTheme::isMaterialDesign() const {
	return d->isMaterialDesign;
}
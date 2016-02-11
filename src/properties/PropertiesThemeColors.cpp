#include "PropertiesThemeColors.h"

class PropertiesThemeColors::PrivateData {
public:
	QColor dashboardBackground;
	QColor telldusBlue;
	QColor telldusOrange;
};

PropertiesThemeColors::PropertiesThemeColors(QObject *parent):QObject(parent) {
	d = new PrivateData;
	d->dashboardBackground = QColor("#EEEEEE");
	d->telldusBlue = QColor("#1b365d");
	d->telldusOrange = QColor("#e26901");
}

PropertiesThemeColors::~PropertiesThemeColors() {
	delete d;
}

QColor PropertiesThemeColors::dashboardBackground() const {
	return d->dashboardBackground;
}

void PropertiesThemeColors::setDashboardBackground(const QColor dashboardBackground) {
	d->dashboardBackground = dashboardBackground;
	emit dashboardBackgroundChanged(dashboardBackground);
}


QColor PropertiesThemeColors::telldusBlue() const {
	return d->telldusBlue;
}

QColor PropertiesThemeColors::telldusOrange() const {
	return d->telldusOrange;
}

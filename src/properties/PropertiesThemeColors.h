#ifndef PROPERTIESTHEMECOLORS_H
#define PROPERTIESTHEMECOLORS_H

#include <QObject>
#include <QColor>

class PropertiesThemeColors : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QColor dashboardBackground READ dashboardBackground WRITE setDashboardBackground NOTIFY dashboardBackgroundChanged)
	Q_PROPERTY(QColor telldusBlue READ telldusBlue NOTIFY telldusBlueChanged)
	Q_PROPERTY(QColor telldusOrange READ telldusOrange NOTIFY telldusOrangeChanged)
public:
	PropertiesThemeColors(QObject *parent = 0);
	~PropertiesThemeColors();

	QColor dashboardBackground() const;
	void setDashboardBackground(const QColor dashboardBackground);

	QColor telldusBlue() const;
	QColor telldusOrange() const;

signals:
	void dashboardBackgroundChanged(const QColor dashboardBackground);
	void telldusBlueChanged(const QColor telldusBlue);
	void telldusOrangeChanged(const QColor telldusOrange);

public slots:

private:
	class PrivateData;
	PrivateData *d;
};

#endif  // PROPERTIESTHEMECOLORS_H
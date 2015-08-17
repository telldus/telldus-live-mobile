#ifndef PROPERTIESTHEME_H
#define PROPERTIESTHEME_H

#include <QObject>

class PropertiesThemeColors;
class PropertiesThemeCore;

class PropertiesTheme : public QObject
{
	Q_OBJECT
	Q_PROPERTY(PropertiesThemeColors *colors READ colors NOTIFY colorsChanged)
	Q_PROPERTY(PropertiesThemeCore *core READ core NOTIFY coreChanged)
public:
	PropertiesTheme(QObject *parent = 0);
	~PropertiesTheme();

	PropertiesThemeColors *colors() const;
	PropertiesThemeCore *core() const;

signals:
	void colorsChanged();
	void coreChanged();

public slots:

private:
	class PrivateData;
	PrivateData *d;
};

#endif  // PROPERTIESTHEME_H
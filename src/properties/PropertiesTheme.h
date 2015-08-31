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
	Q_PROPERTY(bool isMaterialDesign READ isMaterialDesign NOTIFY isMaterialDesignChanged)
public:
	PropertiesTheme(QObject *parent = 0);
	~PropertiesTheme();

	PropertiesThemeColors *colors() const;
	PropertiesThemeCore *core() const;
	bool isMaterialDesign() const;

signals:
	void colorsChanged();
	void coreChanged();
	void isMaterialDesignChanged();

public slots:

private:
	class PrivateData;
	PrivateData *d;
};

#endif  // PROPERTIESTHEME_H
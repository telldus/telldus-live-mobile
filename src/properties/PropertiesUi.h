#ifndef PROPERTIESUI_H
#define PROPERTIESUI_H

#include <QObject>

class PropertiesUi : public QObject
{
	Q_OBJECT
	Q_PROPERTY(bool supportsKeys READ supportsKeys NOTIFY supportsKeysChanged)
	Q_PROPERTY(bool supportsTouch READ supportsTouch NOTIFY supportsTouchChanged)
public:
	PropertiesUi(QObject *parent = 0);
	~PropertiesUi();

	bool supportsKeys() const;
	bool supportsTouch() const;

signals:
	void supportsKeysChanged();
	void supportsTouchChanged();

public slots:

private:
	class PrivateData;
	PrivateData *d;
};

#endif  // PROPERTIESUI_H
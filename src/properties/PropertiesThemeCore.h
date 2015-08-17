#ifndef PROPERTIESTHEMECORE_H
#define PROPERTIESTHEMECORE_H

#include <QObject>

class PropertiesThemeCore : public QObject
{
	Q_OBJECT
	Q_PROPERTY(qreal tilePadding READ tilePadding WRITE setTilePadding NOTIFY tilePaddingChanged)
public:
	PropertiesThemeCore(QObject *parent = 0);
	~PropertiesThemeCore();

	qreal tilePadding() const;
	void setTilePadding(const qreal tilePadding);

signals:
	void tilePaddingChanged(const qreal tilePadding);

public slots:

private:
	class PrivateData;
	PrivateData *d;
};

#endif  // PROPERTIESTHEMECORE_H
#ifndef PROPERTIES_H
#define PROPERTIES_H

#include <QObject>

class PropertiesTheme;

class Properties : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QString foo READ foo WRITE setFoo NOTIFY fooChanged)
	Q_PROPERTY(PropertiesTheme *theme READ theme NOTIFY themeChanged)
public:
	~Properties();
	static Properties *instance();

	PropertiesTheme *theme() const;

	QString foo() const;
	void setFoo(const QString &foo);

signals:
	void themeChanged();
	void fooChanged(const QString &foo);

public slots:

private:
	explicit Properties(QObject *parent = 0);
	class PrivateData;
	PrivateData *d;
};

#endif  // PROPERTIES_H
#ifndef PROPERTIES_H
#define PROPERTIES_H

#include <QObject>

class PropertiesTheme;
class PropertiesUi;

class Properties : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QString foo READ foo WRITE setFoo NOTIFY fooChanged)
	Q_PROPERTY(PropertiesTheme *theme READ theme NOTIFY themeChanged)
	Q_PROPERTY(PropertiesUi *ui READ ui NOTIFY uiChanged)
public:
	~Properties();
	static Properties *instance();

	QString foo() const;
	void setFoo(const QString &foo);

	PropertiesTheme *theme() const;
	PropertiesUi *ui() const;

signals:
	void fooChanged(const QString &foo);
	void themeChanged();
	void uiChanged();

public slots:

private:
	explicit Properties(QObject *parent = 0);
	class PrivateData;
	PrivateData *d;
};

#endif  // PROPERTIES_H
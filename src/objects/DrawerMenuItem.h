#ifndef DRAWERMENUITEM_H
#define DRAWERMENUITEM_H

#include <QObject>
#include <QMetaType>
#include <QString>

class DrawerMenuItem : public QObject
{
	Q_OBJECT
	Q_PROPERTY(int id READ DrawerMenuItemId WRITE setId NOTIFY idChanged)
	Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
	Q_PROPERTY(QString page READ page WRITE setPage NOTIFY pageChanged)
	Q_PROPERTY(QString childView READ childView WRITE setChildView NOTIFY childViewChanged)
	Q_PROPERTY(QString icon READ icon WRITE setIcon NOTIFY iconChanged)

public:
	explicit DrawerMenuItem(QObject *parent = 0);
	~DrawerMenuItem();

	int DrawerMenuItemId() const;
	void setId(int id);

	QString title() const;
	void setTitle(const QString title);

	QString page() const;
	void setPage(const QString page);

	QString childView() const;
	void setChildView(const QString childView);

	QString icon() const;
	void setIcon(const QString icon);

signals:
	void idChanged();
	void titleChanged();
	void pageChanged();
	void childViewChanged();
	void iconChanged();


private:
	class PrivateData;
	PrivateData *d;
};

Q_DECLARE_METATYPE(DrawerMenuItem*)

#endif // DRAWERMENUITEM_H

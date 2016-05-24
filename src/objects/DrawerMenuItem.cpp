#include "DrawerMenuItem.h"
#include <QDebug>

class DrawerMenuItem::PrivateData {
public:
	int id;
	QString title, page, childView, icon;

};

DrawerMenuItem::DrawerMenuItem(QObject *parent) : QObject(parent)
{
	d = new PrivateData;
	d->id = 0;
}

DrawerMenuItem::~DrawerMenuItem() {
	delete d;
}

int DrawerMenuItem::DrawerMenuItemId() const {
	return d->id;
}

void DrawerMenuItem::setId(int id) {
	d->id = id;
	emit idChanged();
}

QString DrawerMenuItem::title() const {
	return d->title;
}

void DrawerMenuItem::setTitle(QString title) {
	if (d->title == title) {
		return;
	}
	d->title = title;
	emit titleChanged();
}

QString DrawerMenuItem::page() const {
	return d->page;
}

void DrawerMenuItem::setPage(QString page) {
	if (d->page == page) {
		return;
	}
	d->page = page;
	emit pageChanged();
}

QString DrawerMenuItem::childView() const {
	return d->childView;
}

void DrawerMenuItem::setChildView(QString childView) {
	if (d->childView == childView) {
		return;
	}
	d->childView = childView;
	emit childViewChanged();
}

QString DrawerMenuItem::icon() const {
	return d->icon;
}

void DrawerMenuItem::setIcon(QString icon) {
	if (d->icon == icon) {
		return;
	}
	d->icon = icon;
	emit iconChanged();
}

#include "DrawerMenuModel.h"

#include <QDebug>
#include <QCoreApplication>

#include "objects/DrawerMenuItem.h"
#include "tellduslive.h"

DrawerMenuModel::DrawerMenuModel(QObject *parent) : TListModel("drawerMenuItem", parent) {
	this->addDrawerMenuItems();
}

DrawerMenuModel::~DrawerMenuModel() {
}

void DrawerMenuModel::addDrawerMenuItems() {
	this->clear();
	QList<QObject *> list;

	DrawerMenuItem *drawerMenuItem = new DrawerMenuItem(this);
	drawerMenuItem->setTitle("Add Location");
	drawerMenuItem->setPage("AddLocationPage.qml");
	drawerMenuItem->setIcon("addLocation");
//	list << drawerMenuItem;

	DrawerMenuItem *drawerMenuItem2 = new DrawerMenuItem(this);
	drawerMenuItem2->setTitle("Add Device");
	drawerMenuItem2->setPage("AddDevicePage.qml");
	drawerMenuItem2->setIcon("addDevice");
//	list << drawerMenuItem2;

	DrawerMenuItem *drawerMenuItem3 = new DrawerMenuItem(this);
	drawerMenuItem3->setTitle(QCoreApplication::translate("extra", "Connected Locations"));
	drawerMenuItem3->setChildView("DrawerChildViewConnectedLocations.qml");
	drawerMenuItem3->setIcon("connectedLocations");
	list << drawerMenuItem3;

	DrawerMenuItem *drawerMenuItem4 = new DrawerMenuItem(this);
	drawerMenuItem4->setTitle(QCoreApplication::translate("pages", "Settings"));
	drawerMenuItem4->setPage("SettingsPage.qml");
	drawerMenuItem4->setIcon("settings");
	list << drawerMenuItem4;

	if (list.size()) {
		//Appends all in one go
		this->append(list);
	}
}

void DrawerMenuModel::authorizationChanged() {
}


DrawerMenuItem *DrawerMenuModel::findDrawerMenuItem(int id) const {
	for(int i = 0; i < this->rowCount(); ++i) {
		DrawerMenuItem *drawerMenuItem = qobject_cast<DrawerMenuItem *>(this->get(i).value<QObject *>());
		if (!drawerMenuItem) {
			continue;
		}
		if (drawerMenuItem->DrawerMenuItemId() == id) {
			return drawerMenuItem;
		}
	}
	return 0;
}

void DrawerMenuModel::onDrawerMenuItemInfo(const QVariantMap &result) {
//	QVariantList list;
//	list << result;
//	this->addDrawerMenuItems(list);
}

void DrawerMenuModel::onDrawerMenuItemRemove(const QVariantMap &result, const QVariantMap &params) {
	if (result["status"] != "success") {
		return;
	}
	for(int i = 0; i < this->rowCount(); ++i) {
		DrawerMenuItem *drawerMenuItem = qobject_cast<DrawerMenuItem *>(this->get(i).value<QObject *>());
		if (!drawerMenuItem) {
			continue;
		}
		if (drawerMenuItem->DrawerMenuItemId() == params["id"].toInt()) {
			this->splice(i,1);
			return;
		}
	}
}

void DrawerMenuModel::onDrawerMenuItemsList(const QVariantMap &result) {
//	this->addDrawerMenuItems(result["DrawerMenuItem"].toList());
//	emit DrawerMenuItemsLoaded(result["DrawerMenuItem"].toList());
}

void DrawerMenuModel::removeDrawerMenuItem(int id) {
}

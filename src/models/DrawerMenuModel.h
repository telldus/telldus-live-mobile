#ifndef DRAWERMENUMODEL_H
#define DRAWERMENUMODEL_H

#include "tlistmodel.h"

class DrawerMenuItem;

class DrawerMenuModel : public TListModel
{
	Q_OBJECT
public:
	DrawerMenuModel(QObject *parent = 0);
	~DrawerMenuModel();
	Q_INVOKABLE void addDrawerMenuItems();
	Q_INVOKABLE DrawerMenuItem *findDrawerMenuItem(int id) const;
	Q_INVOKABLE void removeDrawerMenuItem(int id);

signals:
	void DrawerMenuItemsLoaded(const QVariantList &DrawerMenuItems);

private slots:
	void authorizationChanged();
	void onDrawerMenuItemInfo(const QVariantMap &result);
	void onDrawerMenuItemRemove(const QVariantMap &result, const QVariantMap &params);
	void onDrawerMenuItemsList(const QVariantMap &result);

private:
	//class PrivateData;
	//PrivateData *d;
};

#endif // DRAWERMENUMODEL_H

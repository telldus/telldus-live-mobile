#ifndef CLIENTMODEL_H
#define CLIENTMODEL_H

#include "tlistmodel.h"

class Client;

class ClientModel : public TListModel
{
	Q_OBJECT
public:
	explicit ClientModel(QObject *parent = 0);
	Q_INVOKABLE void addClients(const QVariantList &devices);
	Q_INVOKABLE Client *findClient(int id) const;

signals:
	void clientsLoaded(const QVariantList &devices);

private slots:
	void authorizationChanged();
	void onClientsList(const QVariantMap &result);
};

#endif // CLIENTMODEL_H

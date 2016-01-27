#ifndef CLIENTMODEL_H
#define CLIENTMODEL_H

#include "tlistmodel.h"

class Client;

class ClientModel : public TListModel
{
	Q_OBJECT
public:
	Q_INVOKABLE void addClients(const QVariantList &devices);
	Q_INVOKABLE Client *findClient(int id) const;
	Q_INVOKABLE Client *findClientByName(QString name) const;
	Q_INVOKABLE void deactivateClients(QList<int> activeIds);

	static ClientModel *instance();

signals:
	void clientsLoaded(const QVariantList &devices);

public slots:
	void authorizationChanged();
private slots:
	void fetchDataFromCache();
	void onClientsList(const QVariantMap &result);

private:
	class PrivateData;
	PrivateData *d;
	explicit ClientModel(QObject *parent = 0);
};

#endif // CLIENTMODEL_H

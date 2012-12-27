#include "clientmodel.h"
#include "client.h"
#include "tellduslive.h"


ClientModel::ClientModel(QObject *parent) :
	TListModel("client", parent)
{
	connect(TelldusLive::instance(), SIGNAL(authorizedChanged()), this, SLOT(authorizationChanged()));
	this->authorizationChanged();
}

void ClientModel::addClients(const QVariantList &clientList) {
	QList<QObject *> list;
	foreach(QVariant v, clientList) {
		QVariantMap dev = v.toMap();

		Client *client = this->findClient(dev["id"].toInt());
		if (!client) {
			client = new Client(this);
			client->setId(dev["id"].toInt());
			list << client;
		}
		client->setName(dev["name"].toString());
		client->setOnline(dev["online"].toBool());
		client->setEditable(dev["editable"].toBool());
		client->setVersion(dev["version"].toString());
		client->setType(dev["type"].toString());
	}
	if (list.size()) {
		//Appends all in one go
		this->append(list);
	}
}

void ClientModel::authorizationChanged() {
	TelldusLive *telldusLive = TelldusLive::instance();
	if (telldusLive->isAuthorized()) {
		telldusLive->call("clients/list", TelldusLiveParams(), this, SLOT(onClientsList(QVariantMap)));
	} else {
		this->clear();
	}
}


Client *ClientModel::findClient(int id) const {
	for(int i = 0; i < this->rowCount(); ++i) {
		Client *client = qobject_cast<Client *>(this->get(i).value<QObject *>());
		if (!client) {
			continue;
		}
		if (client->clientId() == id) {
			return client;
		}
	}
	return 0;
}

void ClientModel::onClientsList(const QVariantMap &result) {
	this->addClients(result["client"].toList());
	emit clientsLoaded(result["client"].toList());
}


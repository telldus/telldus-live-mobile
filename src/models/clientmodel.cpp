#include "clientmodel.h"
#include "client.h"
#include "tellduslive.h"

#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QDebug>

class ClientModel::PrivateData {
public:
	static ClientModel *instance;
};
ClientModel *ClientModel::PrivateData::instance = 0;

ClientModel::ClientModel(QObject *parent) :
	TListModel("client", parent)
{
	QSqlDatabase db = QSqlDatabase::database();
	if (db.isOpen()) {
		qDebug() << "[SQL] CREATE TABLE IF NOT EXISTS Client (id INTEGER PRIMARY KEY, name TEXT, online INTEGER, editable INTEGER, version TEXT, type TEXT)";
		qDebug() << "[SQL] ALTER TABLE Client ADD COLUMN deactive INTEGER";
		qDebug() << "[SQL] ALTER TABLE Client ADD COLUMN ip TEXT";
		qDebug() << "[SQL] ALTER TABLE Client ADD COLUMN longitude TEXT";
		qDebug() << "[SQL] ALTER TABLE Client ADD COLUMN latitude TEXT";
		qDebug() << "[SQL] ALTER TABLE Client ADD COLUMN sunrise INTEGER";
		qDebug() << "[SQL] ALTER TABLE Client ADD COLUMN sunset INTEGER";
		qDebug() << "[SQL] ALTER TABLE Client ADD COLUMN timezone TEXT";
		qDebug() << "[SQL] ALTER TABLE Client ADD COLUMN timezoneAutodetected TEXT";
		qDebug() << "[SQL] ALTER TABLE Client ADD COLUMN timezoneOffset INTEGER";
		qDebug() << "[SQL] ALTER TABLE Client ADD COLUMN transports TEXT";
		QSqlQuery query1("CREATE TABLE IF NOT EXISTS Client (id INTEGER PRIMARY KEY, name TEXT, online INTEGER, editable INTEGER, version TEXT, type TEXT)", db);
		QSqlQuery query2("ALTER TABLE Client ADD COLUMN deactive INTEGER", db);
		QSqlQuery query3("ALTER TABLE Client ADD COLUMN ip TEXT", db);
		QSqlQuery query4("ALTER TABLE Client ADD COLUMN longitude TEXT", db);
		QSqlQuery query5("ALTER TABLE Client ADD COLUMN latitude TEXT", db);
		QSqlQuery query6("ALTER TABLE Client ADD COLUMN sunrise INTEGER", db);
		QSqlQuery query7("ALTER TABLE Client ADD COLUMN sunset INTEGER", db);
		QSqlQuery query8("ALTER TABLE Client ADD COLUMN timezone TEXT", db);
		QSqlQuery query9("ALTER TABLE Client ADD COLUMN timezoneAutodetected INTEGER", db);
		QSqlQuery query10("ALTER TABLE Client ADD COLUMN timezoneOffset INTEGER", db);
		QSqlQuery query11("ALTER TABLE Client ADD COLUMN transports TEXT", db);
	}
	connect(TelldusLive::instance(), SIGNAL(authorizedChanged()), this, SLOT(authorizationChanged()));

	this->authorizationChanged();
}

ClientModel *ClientModel::instance() {
	if (PrivateData::instance == 0) {
		PrivateData::instance = new ClientModel;
		PrivateData::instance->fetchDataFromCache();
	}
	return PrivateData::instance;
}

void ClientModel::fetchDataFromCache() {
	qDebug() << "[METHOD] ClientModel::fetchDataFromCache";
	QSqlDatabase db = QSqlDatabase::database();
	if (db.isOpen()) {
		qDebug() << "[SQL] SELECT id, name, online, editable, version, type, deactive, ip, longitude, latitude, sunrise, sunset, timezone, timezoneAutodetected, timezoneOffset, transports FROM Client ORDER BY name";
		QSqlQuery query("SELECT id, name, online, editable, version, type, deactive, ip, longitude, latitude, sunrise, sunset, timezone, timezoneAutodetected, timezoneOffset, transports FROM Client ORDER BY name", db);
		QVariantList clients;
		while (query.next()) {
			QVariantMap client;
			client["id"] = query.value(0);
			client["name"] = query.value(1);
			client["online"] = query.value(2);
			client["editable"] = query.value(3);
			client["version"] = query.value(4);
			client["type"] = query.value(5);
			client["deactive"] = query.value(6);
			client["ip"] = query.value(7);
			client["longitude"] = query.value(8);
			client["latitude"] = query.value(9);
			client["sunrise"] = query.value(10);
			client["sunset"] = query.value(11);
			client["timezone"] = query.value(12);
			client["timezoneAutodetected"] = query.value(13);
			client["timezoneOffset"] = query.value(14);
			client["transports"] = query.value(15);
			client["fromCache"] = true;
			clients << client;
		}
		if (clients.size()) {
			this->addClients(clients);
		}
	}
}

void ClientModel::addClients(const QVariantList &clientList) {
	QList<int> activeClientIds;
	QList<QObject *> list;
	foreach(QVariant v, clientList) {
		QVariantMap dev = v.toMap();
		// API returns tzoffset instead of timezoneOffset
		if(dev.contains("tzoffset")) {
			dev.insert("timezoneOffset", dev["tzoffset"]);
			dev.remove("tzoffset");
		}
		if (dev["deactive"].toBool() == false) {
			if (dev["fromCache"].toBool() == false) {
				activeClientIds << dev["id"].toInt();
			}
			Client *client = this->findClient(dev["id"].toInt());
			if (!client) {
				client = new Client(this);
				client->setFromVariantMap(dev);
				list << client;
			} else {
				client->setFromVariantMap(dev);
			}
		}
	}
	this->deactivateClients(activeClientIds);
	if (list.size()) {
		//Appends all in one go
		this->append(list);
	}
}

void ClientModel::authorizationChanged() {
	TelldusLive *telldusLive = TelldusLive::instance();
	if (telldusLive->isAuthorized()) {
		TelldusLiveParams params;
		params["extras"] = "coordinate,suntime,timezone,transports,tzoffset";
		telldusLive->call("clients/list", params, this, SLOT(onClientsList(QVariantMap)));
	} else {
		this->clear();
		QSqlDatabase db = QSqlDatabase::database();
		if (db.isOpen()) {
			qDebug() << "[SQL] DELETE FROM Client";
			QSqlQuery query("DELETE FROM Client", db);
		}
		qDebug().nospace().noquote() << "[CLIENTMODEL] Cleared";
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

Client *ClientModel::findClientByName(QString name) const {
	for(int i = 0; i < this->rowCount(); ++i) {
		Client *client = qobject_cast<Client *>(this->get(i).value<QObject *>());
		if (!client) {
			continue;
		}
		if (client->name() == name) {
			return client;
		}
	}
	return 0;
}

void ClientModel::deactivateClients(QList<int> activeIds) {
	QSqlDatabase db = QSqlDatabase::database();
	for(int j=0; j < activeIds.count(); ++j) {
		for(int i = 0; i < this->rowCount(); ++i) {
			Client *client = qobject_cast<Client *>(this->get(i).value<QObject *>());
			if (activeIds.indexOf(client->clientId()) == -1) {
				qDebug() << "[CLIENTMODEL] Client Not Found, will deactivate!! Id: " << client->clientId();
				if (db.isOpen()) {
					QSqlQuery query(db);
					query.prepare("UPDATE Client SET deactive = ? WHERE id = ?");
					query.bindValue(0, true);
					query.bindValue(1, client->clientId());
					query.exec();
				}
				this->splice(i, 1);
			}
		}
	}
}

void ClientModel::onClientsList(const QVariantMap &result) {
	if (result["client"].toList().size() == 0) {
		qDebug() << "[CLIENTMODEL] No Clients found, will deactivate all!!";
		QSqlDatabase db = QSqlDatabase::database();
		if (db.isOpen()) {
			QSqlQuery query(db);
			query.prepare("UPDATE Client SET deactive = ?");
			query.bindValue(0, true);
			query.exec();
		}
		this->clear();
	} else {
		this->addClients(result["client"].toList());
	}
	emit clientsLoaded(result["client"].toList());
}


var db;

function setupCache(clientModel, database) {
	db = database;
	clientModel.rowsInserted.connect(function(index, start, end) {
		var clients = [];
		for(var i = start; i <= end; ++i) {
			var client = clientModel.get(i);
			clients.push(client);
			client.nameChanged.connect(client, function() { save([this]) });

		}
		//Save them to the cache
		save(clients);
	});
	clientModel.clientsLoaded.connect(function(clients) {
		db.transaction(function(tx) {
			var ids = [];
			for (var i = 0; i < clientModel.length; ++i) {
				//See if the client is in the one got from the server
				var found = false;
				for (var j in clients) {
					if (clients[j].id == clientModel.get(i).id) {
						found = true;
						break;
					}
				}
				if (found) {
					continue;
				}
				ids.push(clientModel.get(i).id);
				tx.executeSql('DELETE FROM Client WHERE id = ?', [clientModel.get(i).id]);
			}
			for(var i in ids) {
				for (var j = 0; j < clientModel.length; ++j) {
					if (clientModel.get(j).id == ids[i]) {
						clientModel.splice(j, 1);
						break;
					}
				}
			}
		});
	});

	db.transaction(function(tx) {
		var rs = tx.executeSql('SELECT id, name, online, editable, version, type FROM Client ORDER BY id');
		var clientList = [];
		for(var i = 0; i < rs.rows.length; ++i) {
			clientList.push({
				'id': rs.rows.item(i).id,
				'name': rs.rows.item(i).name,
				'online': rs.rows.item(i).online,
				'editable': rs.rows.item(i).editable,
				'version': rs.rows.item(i).version,
				'type': rs.rows.item(i).type
			});
		}

		clientModel.addClients(clientList);
	});
}

function save(clients) {
	db.transaction(function(tx) {
		for(var i = 0; i < clients.length; ++i) {
			tx.executeSql('REPLACE INTO Client (id, name, online, editable, version, type) VALUES(?, ?, ?, ?, ?, ?)',
				[clients[i].id, clients[i].name, clients[i].online, clients[i].editable, clients[i].version, clients[i].type]
			);
		}
	});
}


var db = LocalStorage.openDatabaseSync("TelldusLiveMobile", "1.0", "Settings used by Telldus Live! mobile", 1000000);

function setupCache(deviceModel) {
	deviceModel.rowsInserted.connect(function(index, start, end) {
		var devices = [];
		for(var i = start; i <= end; ++i) {
			var device = deviceModel.get(i);
			devices.push(device);
			device.isFavoriteChanged.connect(device, function() { save([this]) });
			device.typeChanged.connect(device, function() { save([this]) });
			device.stateValueChanged.connect(device, function() { save([this]) });
		}
		//Save them to the cache
		save(devices);
	});
	deviceModel.devicesLoaded.connect(function(devices) {
		db.transaction(function(tx) {
			var ids = [];
			for (var i = 0; i < deviceModel.length; ++i) {
				//See if the device is in the one got from the server
				var found = false;
				for (var j in devices) {
					if (devices[j].id == deviceModel.get(i).id) {
						found = true;
						break;
					}
				}
				if (found) {
					continue;
				}
				ids.push(deviceModel.get(i).id);
				tx.executeSql('DELETE FROM Device WHERE id = ?', [deviceModel.get(i).id]);
			}
			for(var i in ids) {
				for (var j = 0; j < deviceModel.length; ++j) {
					if (deviceModel.get(j).id == ids[i]) {
						deviceModel.splice(j, 1);
						break;
					}
				}
			}
		});
	});

	db.transaction(function(tx) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS Device(id INTEGER PRIMARY KEY, name TEXT, methods INTEGER, type INTEGER, favorite INTEGER, state INTEGER, statevalue TEXT)');
		var rs = tx.executeSql('SELECT id, name, methods, type, favorite, state, statevalue FROM Device ORDER BY name');
		var deviceList = [];
		var haveFav = false;
		for(var i = 0; i < rs.rows.length; ++i) {
			deviceList.push({
				'id': rs.rows.item(i).id,
				'name': rs.rows.item(i).name,
				'methods': parseInt(rs.rows.item(i).methods, 10),
				'type': parseInt(rs.rows.item(i).type, 10),
				'isfavorite': rs.rows.item(i).favorite,
				'state': parseInt(rs.rows.item(i).state, 10),
				'statevalue': rs.rows.item(i).statevalue
			});
			if (rs.rows.item(i).favorite === 'true') {
				haveFav = true;
			}
		}
		if (haveFav) {
			// At lease one is marked as favorite. Switch over to fav view
			favoriteModel.doFilter = true;
		}

		deviceModel.addDevices(deviceList);
	});
}

function save(devices) {
	db.transaction(function(tx) {
		for(var i = 0; i < devices.length; ++i) {
			tx.executeSql('REPLACE INTO Device (id, name, methods, type, favorite, state, statevalue) VALUES(?, ?, ?, ?, ?, ?, ?)',
				[devices[i].id, devices[i].name, devices[i].methods, devices[i].type, devices[i].isFavorite, devices[i].state, devices[i].stateValue]
			);
		}
	});
}


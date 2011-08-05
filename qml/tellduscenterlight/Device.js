var db = openDatabaseSync("TelldusCenterLight", "1.0", "Settings used by TelldusCenter Light", 1000000);

function setupCache(deviceModel) {
	deviceModel.rowsInserted.connect(function(index, start, end) {
		var devices = [];
		for(var i = start; i <= end; ++i) {
			var device = deviceModel.get(i);
			devices.push(device);
			device.isFavoriteChanged.connect(device, function() { save([this]) });
		}
		//Save them to the cache
		save(devices);
	});

	db.transaction(function(tx) {
		//tx.executeSql('DROP TABLE IF EXISTS Device');
		tx.executeSql('CREATE TABLE IF NOT EXISTS Device(id INTEGER PRIMARY KEY, name TEXT, methods INTEGER, favorite INTEGER, state INTEGER, statevalue TEXT)');
		var rs = tx.executeSql('SELECT id, name, methods, favorite, state, statevalue FROM Device');
		var deviceList = [];
		for(var i = 0; i < rs.rows.length; ++i) {
			deviceList.push({
				'id': rs.rows.item(i).id,
				'name': rs.rows.item(i).name,
				'methods': parseInt(rs.rows.item(i).methods, 10),
				'isfavorite': rs.rows.item(i).favorite,
				'state': parseInt(rs.rows.item(i).state, 10),
				'statevalue': rs.rows.item(i).statevalue
			});
		}
		deviceModel.addDevices(deviceList);
	});
}

function save(devices) {
	db.transaction(function(tx) {
		for(var i = 0; i < devices.length; ++i) {
			tx.executeSql('REPLACE INTO Device (id, name, methods, favorite, state, statevalue) VALUES(?, ?, ?, ?, ?, ?)',
				[devices[i].id, devices[i].name, devices[i].methods, devices[i].isFavorite, devices[i].state, devices[i].statevalue]
			);
		}
	});
}


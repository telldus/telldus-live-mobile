var db = openDatabaseSync("TelldusCenterLight", "1.0", "Settings used by TelldusCenter Light", 1000000);

function setupCache(deviceModel) {
	deviceModel.rowsInserted.connect(function(index, start, end) {
		for(var i = start; i <= end; ++i) {
			var device = deviceModel.get(i);
			device.isFavoriteChanged.connect(device, function() { save(this) });
		}
	});

	db.transaction(function(tx) {
		//tx.executeSql('DROP TABLE IF EXISTS Device');
		tx.executeSql('CREATE TABLE IF NOT EXISTS Device(id INTEGER PRIMARY KEY, name TEXT, methods INTEGER, favorite INTEGER, state INTEGER, statevalue TEXT)');
		var rs = tx.executeSql('SELECT id, name, methods, favorite, state, statevalue FROM Device ORDER BY name');
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

function save(device) {
	db.transaction(function(tx) {
		tx.executeSql('REPLACE INTO Device (id, name, methods, favorite, state, statevalue) VALUES(?, ?, ?, ?, ?, ?)',
			[device.id, device.name, device.methods, device.isFavorite, device.state, device.statevalue]
		);
	});
}


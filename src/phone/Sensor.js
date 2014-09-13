var db = LocalStorage.openDatabaseSync("TelldusLiveMobile", "1.0", "Settings used by Telldus Live! mobile", 1000000);

function setupCache(sensorModel) {
	sensorModel.rowsInserted.connect(function(index, start, end) {
		var sensors = [];
		for(var i = start; i <= end; ++i) {
			var sensor = sensorModel.get(i);
			sensors.push(sensor);
			sensor.nameChanged.connect(sensor, function(name) { save(this, "name", name) });
			sensor.lastUpdatedChanged.connect(sensor, function(lastUpdated) { save(this, "lastUpdated", lastUpdated.getTime()/1000) });
			sensor.temperatureChanged.connect(sensor, function(temperature) { save(this, "temperature", temperature) });
			sensor.humidityChanged.connect(sensor, function(humidity) { save(this, "humidity", humidity) });
			save(sensor, "name", sensor.name);
			save(sensor, "lastUpdated", sensor.lastUpdated.getTime()/1000);
		}
	});
	sensorModel.sensorsLoaded.connect(function(sensors) {
		db.transaction(function(tx) {
			var ids = [];
			for (var i = 0; i < sensorModel.length; ++i) {
				//See if the sensor is in the one got from the server
				var found = false;
				for (var j in sensors) {
					if (sensors[j].id == sensorModel.get(i).id) {
						found = true;
						break;
					}
				}
				if (found) {
					continue;
				}
				ids.push(sensorModel.get(i).id);
				tx.executeSql('DELETE FROM Sensor WHERE id = ?', [sensorModel.get(i).id]);
			}
			for(var i in ids) {
				for (var j = 0; j < sensorModel.length; ++j) {
					if (sensorModel.get(j).id == ids[i]) {
						sensorModel.splice(j, 1);
						break;
					}
				}
			}
		});
	});

	db.transaction(function(tx) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS Sensor (id INTEGER PRIMARY KEY, name TEXT, lastUpdated INTEGER, temperature REAL, humidity REAL)');
		var rs = tx.executeSql('SELECT id, name, lastUpdated, temperature, humidity FROM Sensor ORDER BY name');
		var sensorList = [];
		for(var i = 0; i < rs.rows.length; ++i) {
			sensorList.push({
				'id': rs.rows.item(i).id,
				'name': rs.rows.item(i).name,
				'lastUpdated': parseInt(rs.rows.item(i).lastUpdated, 10),
				'temperature': parseFloat(rs.rows.item(i).temperature),
				'humidity':  parseFloat(rs.rows.item(i).humidity)
			});
		}
		sensorModel.addSensors(sensorList);
	});
}

function save(sensor, what, value) {
	db.transaction(function(tx) {
		var rs = tx.executeSql('SELECT id FROM Sensor WHERE id = ?', [sensor.id]);
		if (rs.rows.length > 0) {
			tx.executeSql('UPDATE Sensor SET ' + what + ' = ? WHERE id = ?', [value, sensor.id]);
		} else {
			tx.executeSql('INSERT INTO Sensor (id, ' + what + ') VALUES(?, ?)', [sensor.id, value]);
		}
	});
}


var db;

function setupCache(sensorModel, database) {
	db = database;
	sensorModel.rowsInserted.connect(function(index, start, end) {
		var sensors = [];
		for(var i = start; i <= end; ++i) {
			var sensor = sensorModel.get(i);
			sensors.push(sensor);
			sensor.nameChanged.connect(sensor, function(name) { save(this, "name", name) });
			sensor.lastUpdatedChanged.connect(sensor, function(lastUpdated) { save(this, "lastUpdated", lastUpdated.getTime()/1000) });
			sensor.temperatureChanged.connect(sensor, function(temperature) { save(this, "temperature", temperature) });
			sensor.humidityChanged.connect(sensor, function(humidity) { save(this, "humidity", humidity) });
			sensor.rainRateChanged.connect(sensor, function(value) { save(this, "rainRate", value) });
			sensor.rainTotalChanged.connect(sensor, function(value) { save(this, "rainTotal", value) });
			sensor.uvChanged.connect(sensor, function(value) { save(this, "uv", value) });
			sensor.wattChanged.connect(sensor, function(value) { save(this, "watt", value) });
			sensor.windAvgChanged.connect(sensor, function(value) { save(this, "windAvg", value) });
			sensor.windGustChanged.connect(sensor, function(value) { save(this, "windGust", value) });
			sensor.windDirChanged.connect(sensor, function(value) { save(this, "windDir", value) });
			sensor.luminanceChanged.connect(sensor, function(value) { save(this, "luminance", value) });
			sensor.isFavoriteChanged.connect(sensor, function(value) {  save(this, "favorite", value) });
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
		var rs = tx.executeSql('SELECT id, name, lastUpdated, temperature, humidity, rainRate, rainTotal, uv, watt, windAvg, windGust, windDir, luminance, favorite FROM Sensor ORDER BY name');
		var sensorList = [];
		for(var i = 0; i < rs.rows.length; ++i) {
			sensorList.push({
				'id': rs.rows.item(i).id,
				'name': rs.rows.item(i).name,
				'lastUpdated': parseInt(rs.rows.item(i).lastUpdated, 10),
				'temperature': parseFloat(rs.rows.item(i).temperature),
				'humidity':  parseFloat(rs.rows.item(i).humidity),
				'rainRate':  parseFloat(rs.rows.item(i).rainRate),
				'rainTotal':  parseFloat(rs.rows.item(i).rainTotal),
				'uv':  parseFloat(rs.rows.item(i).uv),
				'watt':  parseFloat(rs.rows.item(i).watt),
				'windAvg':  parseFloat(rs.rows.item(i).windAvg),
				'windGust':  parseFloat(rs.rows.item(i).windGust),
				'windDir':  parseFloat(rs.rows.item(i).windDir),
				'luminance': parseFloat(rs.rows.item(i).luminance),
				'isfavorite': rs.rows.item(i).favorite
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


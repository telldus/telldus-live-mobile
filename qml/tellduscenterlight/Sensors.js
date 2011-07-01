.pragma library

Qt.include("Signal.js");

var list = function() {

	var _list = {};
	var _telldusLive = null;
	var sensorAdded = new Signal();
	var sensorRemoved = new Signal();
	sensorAdded.onConnect(function(signal) {
		for(var i in _list) {
			signal.emit(_list[i]);
		}
	});
	var db = openDatabaseSync("TelldusCenterLight", "1.0", "Settings used by TelldusCenter Light", 1000000);

	function init() {
		//Load cached sensors
		db.transaction(function(tx) {
			//tx.executeSql('DROP TABLE IF EXISTS Sensor');
			//tx.executeSql('DROP TABLE IF EXISTS SensorData');
			tx.executeSql('CREATE TABLE IF NOT EXISTS Sensor(id INTEGER PRIMARY KEY, name TEXT, updated INTEGER)');
			tx.executeSql('CREATE TABLE IF NOT EXISTS SensorData(sensorId INTEGER, dataType TEXT, value TEXT, UNIQUE(sensorId, dataType))');
			var rs = tx.executeSql('SELECT id, name, updated FROM Sensor ORDER BY name');
			for(var i = 0; i < rs.rows.length; ++i) {
				var sensorObj = {
					'id': rs.rows.item(i).id,
					'name': rs.rows.item(i).name,
					'lastUpdated': parseInt(rs.rows.item(i).updated, 10)
				};
				var sensor = addSensor(sensorObj);
				var valueRs = tx.executeSql('SELECT dataType, value FROM SensorData WHERE sensorId = ?', [sensor.id()]);
				for(var j = 0; j < valueRs.rows.length; ++j) {
					sensor.setValue(valueRs.rows.item(j).dataType, valueRs.rows.item(j).value);
				}
			}
		});
	}

	function addSensor(sensorInfo) {
		var sensor = null;
		if (_list[sensorInfo.id]) {
			sensor = _list[sensorInfo.id];
			sensor.update(sensorInfo);
		} else {
			sensor = new Sensor(sensorInfo);
			_list[sensor.id()] = sensor;
			sensorAdded.emit(sensor);
		}
		return sensor;
	}

	function authorizationChanged() {
		if (!_telldusLive.isAuthorized) {
			return;
		}
		_telldusLive.call('sensors/list', { }, function(arg) {
			var ids = [];
			for(var i = 0; i < arg.sensor.length; ++i) {
				var sensor = addSensor(arg.sensor[i]);
				_telldusLive.call('sensor/info', { id: sensor.id() }, function(arg) {
					var sensor = this.sensor;
					this.db.transaction(function(tx) {
						tx.executeSql('DELETE FROM SensorData WHERE sensorId = ?', [sensor.id()]);
						for(var i = 0; i < arg.data.length; ++i) {
							sensor.setValue(arg.data[i].name, arg.data[i].value);
							tx.executeSql('REPLACE INTO SensorData(sensorId, dataType, value) VALUES(?, ?, ?)', [sensor.id(), arg.data[i].name, arg.data[i].value]);
						}
					});
				}, {sensor: sensor, db: db});
				ids.push(arg.sensor[i].id);
			}
			db.transaction(function(tx) {
				//See which sensors has been removed since last run
				for(var i in _list) {
					if (ids.indexOf(_list[i].id()) < 0) {
						//Signal first. Remove later
						sensorRemoved.emit(_list[i]);
						tx.executeSql('DELETE FROM Sensor WHERE id = ?', [_list[i].id()]);
						tx.executeSql('DELETE FROM SensorData WHERE sensorId = ?', [_list[i].id()]);
						delete _list[i];
					}
				}

				for(var i in _list) {
					tx.executeSql('REPLACE INTO Sensor(id, name, updated) VALUES(?, ?, ?)', [_list[i].id(), _list[i].name(), _list[i].updated()]);
				}
			});
		});
	}

	function count() {
		return _list.length;
	}

	function sensor(id) {
		if (!_list[id]) {
			return undefined;
		}
		return _list[id];
	}

	function setTelldusLive(telldusLive) {
		_telldusLive = telldusLive;
		_telldusLive.authorizedChanged.connect(authorizationChanged);
		authorizationChanged();
	}

	function Sensor(data) {
		//Parse new values
		for (var i in data) {
			if(data[i] == undefined){
				this['_' + i] = '';
			} else {
				this['_' + i] = data[i];
			}
		}
		this.onChanged = new Signal();
		this._values = {};
	}

	Sensor.prototype.id = function() { return this._id; }
	Sensor.prototype.name = function() { return this._name; }
	Sensor.prototype.update = function(data) {
		for(var i in data) {
			var value = data[i]
			if(value == undefined){
				value = '';
			}
			if (this['_' + i] == value) {
				continue;
			}
			this['_' + i] = value;
			this.onChanged.emit(i);
		}
	}
	Sensor.prototype.hasValue = function(type) {
		if (this._values[type]) {
			return true;
		}
		return false;
	}

	Sensor.prototype.value = function(type) {
		if (!this.hasValue(type)) {
			return '';
		}
		return this._values[type];
	}
	Sensor.prototype.setValue = function(type, value) {
		this._values[type] = value;
		this.onChanged.emit(type);
	}
	Sensor.prototype.updated = function() {
		return this._lastUpdated;
	}

	init();
	return {
			count: count,
			sensor: sensor,
			sensorAdded: sensorAdded,
			sensorRemoved: sensorRemoved,
			setTelldusLive: setTelldusLive
	}
}();



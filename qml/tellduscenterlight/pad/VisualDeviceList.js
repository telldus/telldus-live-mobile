.pragma library

Qt.include("../Signal.js");

var visualDevicelist = function() {

	var _visualList = {};
	var visualDeviceAdded = new Signal();
	var deviceList = null;

	var db = openDatabaseSync("TelldusCenterLight", "1.0", "Settings used by TelldusCenter Light", 1000000);  //TODO same database? different? Use same instance?

	function init(rawDeviceList) {
		deviceList = rawDeviceList;
		deviceList.deviceAdded.connect(deviceAdded);
	}

	function addDevice(deviceInfo) {
		var device = null;
		/*
		if (_visualList[deviceInfo.id]) {
			device = _list[deviceInfo.id];
			device.update(deviceInfo);
		} else {
		*/
			device = new VisualDevice(deviceInfo);
			_visualList[device.id()] = device;
			visualDeviceAdded.emit(device);  //TODO
		// }
	}

	function addVisualDevice(xvalue, yvalue, deviceId, tabId){
		db.transaction(function(tx) {
			tx.executeSql('INSERT INTO VisualDevice (deviceId, layoutX, layoutY, tabId) VALUES(?, ?, ?, ?)', [deviceId, xvalue, yvalue, tabId]);
			//TODO return an ID to add below!!!
		});
		addDevice({'id': 999, 'deviceId': deviceId, 'layoutX': xvalue, 'layoutY': yvalue, 'tabId': tabId});  //TODO replace this temp value
	}

	function deviceAdded(device){
		db.transaction(function(tx) {
			//tx.executeSql('DROP TABLE IF EXISTS VisualDevice');
			tx.executeSql('CREATE TABLE IF NOT EXISTS VisualDevice(id INTEGER PRIMARY KEY, deviceId INTEGER, layoutX INTEGER, layoutY INTEGER, tabId INTEGER)');
			var rs = tx.executeSql('SELECT id, deviceId, layoutX, layoutY, tabId FROM VisualDevice WHERE deviceId = ?', [device.id()]);
			for(var i = 0; i < rs.rows.length; ++i) {
				var deviceObj = {
					'id': rs.rows.item(i).id,  //TODO remove?
					'deviceId': rs.rows.item(i).deviceId,
					'layoutX': parseInt(rs.rows.item(i).layoutX, 10),
					'layoutY': parseInt(rs.rows.item(i).layoutY, 10),
					'tabId': parseInt(rs.rows.item(i).tabId, 10)
				};
				addDevice(deviceObj);
			}
		});
	}

	function visualDevice(id) {
		if (!_visualList[id]) {
			return undefined;
		}
		return _visualList[id];
	}

	function VisualDevice(data) {

		//Parse new values
		for (var i in data) {
			if(data[i] == undefined){
				this['_' + i] = '';
			} else {
				this['_' + i] = data[i];
			}
		}
		//this.onChanged = new Signal();
	}

	VisualDevice.prototype.id = function() { return this._id; }
	VisualDevice.prototype.device = function() { return deviceList.device(this._deviceId); }
	VisualDevice.prototype.layoutX = function() { return this._layoutX; }
	VisualDevice.prototype.layoutY = function() { return this._layoutY; }
	VisualDevice.prototype.tabId = function() { return this._tabId; }

	VisualDevice.prototype.layoutPosition = function(newX, newY, tabId, visualDeviceId){
		//TODO why is visualDeviceId neccessary? why not this._id?
		this._layoutX = newX;
		this._layoutY = newY;
		this._tabId = tabId;
		db.transaction(function(tx) {
			tx.executeSql('UPDATE VisualDevice SET layoutX = ?, layoutY = ?, tabId = ? WHERE id = ?', [newX, newY, tabId, visualDeviceId]);
		});
	}

	return {
		visualDeviceAdded: visualDeviceAdded,
		addVisualDevice: addVisualDevice,
		init: init,
		visualDevice: visualDevice
	}
}();

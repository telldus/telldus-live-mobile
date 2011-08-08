.pragma library

Qt.include("../Signal.js");
Qt.include("../mainscripts.js")

var visualDevicelist = function() {

	var _visualList = {};
	var visualDeviceAdded = new Signal();
	var visualDeviceRemoved = new Signal();
	var deviceList = null;
	var sensorList = null;

	var db = openDatabaseSync("TelldusCenterLight", "1.0", "Settings used by TelldusCenter Light", 1000000);  //TODO same database? different? Use same instance?

	function init(rawDeviceList, rawSensorList) {
		deviceList = rawDeviceList;

		deviceList.rowsInserted.connect(function(index, start, end) {
			var devices = [];
			for(var i = start; i <= end; ++i) {
				var device = deviceList.get(i);
				added(device, DEVICE)
			}
		});

		deviceList.rowsRemoved.connect(function(index, start, end) {
			var devices = [];
			for(var i = start; i <= end; ++i) {
				var device = deviceList.get(i);
				removed(device, DEVICE)
			}
		});

		for(var i=0; i<deviceList.count; ++i){
			added(deviceList.get(i), DEVICE); //Add all existing
		}

		sensorList = rawSensorList;
		sensorList.sensorAdded.connect(sensorAdded);  //TODO, change to CPP-list
		sensorList.sensorRemoved.connect(sensorRemoved);	//TODO, change to CPP-list
		//TODO, add all existing, change to CPP-list
	}

	function addVisualDevice(xvalue, yvalue, deviceId, tabId, type){
		if(type == undefined){
			type = DEVICE;
		}

		var insertId = 0;
		db.transaction(function(tx) {
			var result = tx.executeSql('INSERT INTO VisualDevice (deviceId, layoutX, layoutY, tabId, type) VALUES(?, ?, ?, ?, ?)', [deviceId, xvalue, yvalue, tabId, type]);
			insertId = result.insertId;
		});
		addDevice({'id': insertId, 'deviceId': deviceId, 'layoutX': xvalue, 'layoutY': yvalue, 'tabId': tabId, 'type': type});
	}

	function sensorAdded(sensor){
		added(sensor, SENSOR);
	}

	function added(device, type){

		db.transaction(function(tx) {
			//tx.executeSql('DROP TABLE IF EXISTS VisualDevice');
			tx.executeSql('CREATE TABLE IF NOT EXISTS VisualDevice(id INTEGER PRIMARY KEY, deviceId INTEGER, layoutX INTEGER, layoutY INTEGER, tabId INTEGER, type INTEGER)');
			var rs = tx.executeSql('SELECT id, deviceId, layoutX, layoutY, tabId, type FROM VisualDevice WHERE deviceId = ? AND type = ?', [device.id, type]);
			for(var i = 0; i < rs.rows.length; ++i) {
				var deviceObj = {
					'id': rs.rows.item(i).id,
					'deviceId': rs.rows.item(i).deviceId,
					'layoutX': parseInt(rs.rows.item(i).layoutX, 10),
					'layoutY': parseInt(rs.rows.item(i).layoutY, 10),
					'tabId': parseInt(rs.rows.item(i).tabId, 10),
					'type': parseInt(rs.rows.item(i).type, 10)
				};

				addDevice(deviceObj);
			}
		});
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
			_visualList[device.id] = device;
			visualDeviceAdded.emit(device);  //TODO
		// }
	}

	function sensorRemoved(device){
		removed(device, SENSOR);
	}

	function removed(device, type){
		db.transaction(function(tx) {
			var rs = tx.executeSql('SELECT id FROM VisualDevice WHERE deviceId = ? AND type = ?', [device.id, type]);
			for(var i = 0; i < rs.rows.length; ++i) {
				removeDevice(rs.rows.item(i).id);  //remove all visualDevices
			}
			tx.executeSql('DELETE FROM VisualDevice WHERE deviceId = ? AND type = ?', [device.id, type]);
		});

	}

	function removeDevice(visualDeviceId){
		_visualList[visualDeviceId] = null; //TODO more?
		visualDeviceRemoved.emit(visualDeviceId)
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
	}

	VisualDevice.prototype.id = function() { return this._id; }
	VisualDevice.prototype.device = function() { if(this._type==DEVICE){ return deviceList.findDevice(this._deviceId); } }  //this._deviceId TODO does this work?
	VisualDevice.prototype.sensor = function() { if(this._type==SENSOR){ return sensorList.sensor(this._deviceId); } }
	VisualDevice.prototype.layoutX = function() { return this._layoutX; }
	VisualDevice.prototype.layoutY = function() { return this._layoutY; }
	VisualDevice.prototype.tabId = function() { return this._tabId; }
	VisualDevice.prototype.type = function() { return this._type; }

	VisualDevice.prototype.layoutPosition = function(newX, newY, tabId){
		var visualDeviceId = this._id;
		this._layoutX = newX;
		this._layoutY = newY;
		this._tabId = tabId;
		db.transaction(function(tx) {
			tx.executeSql('UPDATE VisualDevice SET layoutX = ?, layoutY = ?, tabId = ? WHERE id = ?', [newX, newY, tabId, visualDeviceId]);
		});
	}

	VisualDevice.prototype.deleteDevice = function(){
		var visualDeviceId = this._id; //this is needed, can't use "this" down there
		db.transaction(function(tx) {
			tx.executeSql('DELETE FROM VisualDevice WHERE id = ?', [visualDeviceId]);
		});
	}

	return {
		visualDeviceAdded: visualDeviceAdded,
		visualDeviceRemoved: visualDeviceRemoved,
		addVisualDevice: addVisualDevice,
		init: init,
		visualDevice: visualDevice
	}
}();

var tabAreaList = function(){
	var _tabAreaList = {};
	var _parentTabArea
	var _tabComponent
	var _tabButtonRow
	var _tabSelectionButton

	var db = openDatabaseSync("TelldusCenterLight", "1.0", "Settings used by TelldusCenter Light", 1000000);  //TODO same database? different? Use same instance?

	function init(tabComponent, tabArea, tabButtonRow, tabSelectionButton){
		_parentTabArea = tabArea;
		_tabComponent = tabComponent;
		_tabButtonRow = tabButtonRow;
		_tabSelectionButton = tabSelectionButton

		db.transaction(function(tx) {
			//tx.executeSql('DROP TABLE IF EXISTS TabArea');
			tx.executeSql('CREATE TABLE IF NOT EXISTS TabArea(id INTEGER PRIMARY KEY, name TEXT, backgroundimage TEXT)');
			var rs = tx.executeSql('SELECT id, name, backgroundimage FROM TabArea');
			for(var i = 0; i < rs.rows.length; ++i) {
				var tabObj = {
					'id': rs.rows.item(i).id,
					'name': rs.rows.item(i).name,
					'backgroundimage': rs.rows.item(i).backgroundimage
				};
				addTab(tabObj);
			}
			if(rs.rows.length == 0){
				//no tab areas exists, create a default first one
				insertTabArea('New layout', '');
			}
		});
	}

	function deleteTabArea(id){
		var tabArea = _tabAreaList[id];
		tabArea.button.destroy(); //delete selection button
		tabArea.destroy();  //delete area
		_tabAreaList[id] = null;
		db.transaction(function(tx) {
			tx.executeSql('DELETE FROM TabArea WHERE id = ?', [id]);
		});
	}

	function insertTabArea(name, backgroundimage){
		var insertId = 0;
		db.transaction(function(tx) {
			var result = tx.executeSql('INSERT INTO TabArea (name, backgroundimage) VALUES(?, ?)', [name, backgroundimage]);
			insertId = result.insertId;
		});
		addTab({'id': insertId, 'name': name, 'backgroundimage': backgroundimage});
	}

	function updateTabAreaName(id, newName){
		var tabArea = _tabAreaList[id];
		if(!tabArea){
			return;
		}

		tabArea.name = newName; //TODO bind or even update this?
		db.transaction(function(tx) {
			tx.executeSql('UPDATE TabArea SET name = ? WHERE id = ?', [newName, id]);
		});
	}

	function addTab(tabInfo) {
		var tabAreaObject = _tabComponent.createObject(_parentTabArea);
		tabAreaObject.tabId = tabInfo.id;
		tabAreaObject.name = tabInfo.name;
		tabAreaObject.backgroundimage = tabInfo.backgroundimage;
		_tabAreaList[tabInfo.id] = tabAreaObject;

		var tabButtonObject = _tabSelectionButton.createObject(_tabButtonRow);
		tabButtonObject.name = tabInfo.name;
		tabButtonObject.selectionTabId = tabInfo.id;
		tabAreaObject.button = tabButtonObject;  //TODO delete too
	}

	function tab(id) {
		return _tabAreaList[id];
	}

	return{
		init: init,
		tab: tab,
		insertTabArea: insertTabArea,
		updateTabAreaName: updateTabAreaName,
		deleteTabArea: deleteTabArea
	}
}();

//TODO model or something? CHANGE THIS when tested, this step neccessary?
var visualObjectList = {};

function addVisualObject(visualObject) {
	visualObjectList[visualObject.visualDeviceId] = visualObject;
}

function removeVisualObject(visualDeviceId) {
	visualObjectList[visualDeviceId].destroy();
	visualObjectList[visualDeviceId] = null;
}

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
		var insertId = 0;
		db.transaction(function(tx) {
			var result = tx.executeSql('INSERT INTO VisualDevice (deviceId, layoutX, layoutY, tabId) VALUES(?, ?, ?, ?)', [deviceId, xvalue, yvalue, tabId]);
			insertId = result.insertId;
		});
		addDevice({'id': insertId, 'deviceId': deviceId, 'layoutX': xvalue, 'layoutY': yvalue, 'tabId': tabId});
	}

	function deviceAdded(device){
		db.transaction(function(tx) {
			//tx.executeSql('DROP TABLE IF EXISTS VisualDevice');
			tx.executeSql('CREATE TABLE IF NOT EXISTS VisualDevice(id INTEGER PRIMARY KEY, deviceId INTEGER, layoutX INTEGER, layoutY INTEGER, tabId INTEGER)');
			var rs = tx.executeSql('SELECT id, deviceId, layoutX, layoutY, tabId FROM VisualDevice WHERE deviceId = ?', [device.id()]);
			for(var i = 0; i < rs.rows.length; ++i) {
				var deviceObj = {
					'id': rs.rows.item(i).id,
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
		console.log("id:", this._id );
		db.transaction(function(tx) {
			tx.executeSql('DELETE FROM VisualDevice WHERE id = ?', [visualDeviceId]);
		});
	}

	return {
		visualDeviceAdded: visualDeviceAdded,
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

	function insertTabArea(name, backgroundimage){
		var insertId = 0;
		db.transaction(function(tx) {
			var result = tx.executeSql('INSERT INTO TabArea (name, backgroundimage) VALUES(?, ?)', [name, backgroundimage]);
			insertId = result.insertId;
		});
		console.log("Adding", insertId, "for", name);
		addTab({'id': insertId, 'name': name, 'backgroundimage': backgroundimage});
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
		insertTabArea: insertTabArea
	}
}();

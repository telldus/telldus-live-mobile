.pragma library

Qt.include("Signal.js");

var METHOD_TURNON = 1;
var METHOD_TURNOFF = 2;
var METHOD_BELL = 4;
var METHOD_DIM = 16;

var list = function() {

	var _list = {};
	var _telldusLive = null;
	var deviceAdded = new Signal();
	var deviceRemoved = new Signal();
	deviceAdded.onConnect(function(signal) {
		for(var i in _list) {
			signal.emit(_list[i]);
		}
	});
	var db = openDatabaseSync("TelldusCenterLight", "1.0", "Settings used by TelldusCenter Light", 1000000);

	function init() {
		//Load cached devices
		db.transaction(function(tx) {
			//tx.executeSql('DROP TABLE IF EXISTS Device');
			tx.executeSql('CREATE TABLE IF NOT EXISTS Device(id INTEGER PRIMARY KEY, name TEXT, methods INTEGER, favorite INTEGER, state INTEGER, statevalue TEXT)');
			var rs = tx.executeSql('SELECT id, name, methods, favorite, state, statevalue FROM Device ORDER BY name');
			for(var i = 0; i < rs.rows.length; ++i) {
				var deviceObj = {
					'id': rs.rows.item(i).id,
					'name': rs.rows.item(i).name,
					'methods': parseInt(rs.rows.item(i).methods, 10),
					'favorite': rs.rows.item(i).favorite,
					'state': parseInt(rs.rows.item(i).state, 10),
					'statevalue': rs.rows.item(i).statevalue
				};
				addDevice(deviceObj);
			}
		});
	}

	function addDevice(deviceInfo) {
		var device = null;
		if (_list[deviceInfo.id]) {
			device = _list[deviceInfo.id];
			device.update(deviceInfo);
		} else {
			device = new Device(deviceInfo);
			_list[device.id()] = device;
			deviceAdded.emit(device);
		}
	}

	function authorizationChanged() {
		if (!_telldusLive.isAuthorized) {
			return;
		}
		_telldusLive.call('devices/list', {'supportedMethods': 23}, function(arg) {
			var ids = [];
			for(var i = 0; i < arg.device.length; ++i) {
				addDevice(arg.device[i]);
				ids.push(arg.device[i].id);
			}
			db.transaction(function(tx) {
				//See which devices has been removed since last run
				for(var i in _list) {
					if (ids.indexOf(_list[i].id()) < 0) {
						//Signal first. Remove later
						deviceRemoved.emit(_list[i]);
						tx.executeSql('DELETE FROM Device WHERE id = ?', [_list[i].id()]);
						delete _list[i];
					}
				}

				for(var i in _list) {
					tx.executeSql('REPLACE INTO Device (id, name, methods, favorite, state, statevalue) VALUES(?, ?, ?, ?, ?, ?)', [_list[i].id(), _list[i].name(), _list[i].methods(), _list[i].isFavorite(), _list[i].state(), _list[i].statevalue()]);
				}
			});
		});
	}

	function count() {
		//return _list.length;
		var count = 0;
		for(var i in _list) {
			count++;
		}
		return count;
	}

	function favoriteCount(){
		var numFavorites = 0;
		for(var i in _list){
			if(_list[i].isFavorite() === 'true'){
				numFavorites = numFavorites + 1;
			}
		}
		return numFavorites;
	}

	function device(id) {
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

	function Device(data) {
		//Default values for values not received from Telldus API
		this._favorite = false;

		//Parse new values
		for (var i in data) {
			if(data[i] == undefined){
				this['_' + i] = '';
			} else {
				this['_' + i] = data[i];
			}
		}
		this.onChanged = new Signal();
	}

	Device.prototype.id = function() { return this._id; }
	Device.prototype.isFavorite = function() { return this._favorite; }
	Device.prototype.setIsFavorite = function(favorite) {
		if (this._favorite == favorite) {
			return;
		}
		this._favorite = favorite;
		var id = this._id;
		db.transaction(function(tx) {
			tx.executeSql('UPDATE Device SET favorite = ? WHERE id = ?', [favorite, id]);
		});
		this.onChanged.emit('favorite');
	}
	Device.prototype.methods = function() { return this._methods; }
	Device.prototype.name = function() { return this._name; }
	Device.prototype.state = function() { return this._state; }
	Device.prototype.statevalue = function() { return this._statevalue; }
	Device.prototype.turnOn = function() {
		_telldusLive.call('device/turnOn', {id: this._id}, function(arg){ this.updateStatus(arg, METHOD_TURNON); }, this );
	}
	Device.prototype.turnOff = function() {
		_telldusLive.call('device/turnOff', {id: this._id}, function(arg){ this.updateStatus(arg, METHOD_TURNOFF); }, this );
	}
	Device.prototype.bell = function() {
		_telldusLive.call('device/bell', {id: this._id}, 0 );
	}
	Device.prototype.dim = function(dimvalue) {
		_telldusLive.call('device/dim', {id: this._id, level: dimvalue}, function(arg){ this.updateStatus(arg, METHOD_DIM); }, this );
	}

	Device.prototype.update = function(data) {
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

	Device.prototype.updateStatus = function(arg, newState){
		if(arg.status == 'success'){
			if (this._state == newState) {
				return;
			}
			this._state = newState;
			var id = this._id;
			db.transaction(function(tx) {
				tx.executeSql('UPDATE Device SET state = ? WHERE id = ?', [newState, id]);
			});
			this.onChanged.emit('state');
		}
	}

	init();
	return {
		count: count,
		device: device,
		deviceAdded: deviceAdded,
		deviceRemoved: deviceRemoved,
		favoriteCount: favoriteCount,
		setTelldusLive: setTelldusLive
	}
}();



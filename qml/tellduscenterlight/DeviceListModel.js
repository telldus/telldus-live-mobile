var deviceList = null;

function init(list) {
	deviceList = list;
	list.deviceAdded.connect(deviceAdded);
	list.deviceRemoved.connect(deviceRemoved);
}

function deviceAdded(device) {
	device.onChanged.connect(function(what) {
		var device = null;
		for(var i = 0; i < this.m.count; ++i) {
			if (this.m.get(i).deviceId != this.d.id()) {
				continue;
			}
			device = this.m.get(i);
			break;
		}
		if (!device) {
			//Not found, should not happen
			return;
		}

		if (what == 'name') {
			device.deviceName = this.d.name();
		} else if (what == 'favorite') {
			device.deviceIsFavorite = this.d.isFavorite();
		} else if (what == 'state') {
			device.deviceState = this.d.state();
		} else if (what == 'statevalue') {
			device.deviceStateValue = this.d.statevalue();
		}

	}, {d: device, m: deviceListModel});

	deviceListModel.append( {
		'deviceId': device.id(),
		'deviceName': device.name(),
		'deviceIsFavorite': device.isFavorite(),
		'deviceMethods': device.methods(),
		'deviceState': device.state(),
		'deviceStateValue': device.statevalue()
	});
}

function deviceRemoved(device) {
	for(var i = 0; i < deviceListModel.count; ++i) {
		if (deviceListModel.get(i).device != device.id()) {
			continue;
		}
		deviceListModel.remove(i);
	}
}

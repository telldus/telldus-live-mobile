var deviceList = null;

function init(list) {
	deviceList = list;
	list.deviceAdded.connect(deviceAdded);
	list.deviceRemoved.connect(deviceRemoved);
}

function deviceAdded(device) {
	deviceListModel.append( { 'device': device.id() });
}

function deviceRemoved(device) {
	for(var i = 0; i < deviceListModel.count; ++i) {
		if (deviceListModel.get(i).device != device.id()) {
			continue;
		}
		deviceListModel.remove(i);
	}
}

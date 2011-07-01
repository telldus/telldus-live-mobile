var sensorList = null;

function init(list) {
	sensorList = list;
	list.sensorAdded.connect(sensorAdded);
	list.sensorRemoved.connect(sensorRemoved);
}

function sensorAdded(sensor) {
	sensorListModel.append( { 'sensor': sensor.id() });
}

function sensorRemoved(sensor) {
	for(var i = 0; i < sensorListModel.count; ++i) {
		if (sensorListModel.get(i).sensor != sensor.id()) {
			continue;
		}
		sensorListModel.remove(i);
	}
}

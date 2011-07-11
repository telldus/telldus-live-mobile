import Qt 4.7
import ".."
import "../DeviceList.js" as DeviceList
import "../DeviceListModel.js" as Script

ListModel {
	id: favoriteLayoutObjects

	Component.onCompleted: {
		Script.init(DeviceList.list);
		DeviceList.list.deviceAdded.connect(deviceAdded);
	}

	property int favoriteCount: 0

	function deviceAdded(device){
		var visualDevice = Qt.createComponent("VisualDevice.qml");

		//TODO do like this at all? Or own list somehow?

		if(device.layoutTab() > 0){ //Check for correct tab, property of this favoriteLayoutObjects...
			var visualObject = visualDevice.createObject(tabArea);
			visualObject.x = device.layoutX();
			visualObject.y = device.layoutY();

			visualObject.deviceId = device.id();
			visualObject.deviceName = device.name();
			visualObject.deviceMethods = device.methods();
			visualObject.deviceState = device.state();
			visualObject.deviceStateValue = device.statevalue();
		}
	}
}

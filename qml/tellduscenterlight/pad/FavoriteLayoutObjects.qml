import Qt 4.7
import ".."
import "VisualDeviceList.js" as VisualDeviceList
import "../DeviceList.js" as DeviceList
//import "../DeviceListModel.js" as Script

ListModel {
	id: favoriteLayoutObjects

	Component.onCompleted: {
		VisualDeviceList.visualDevicelist.visualDeviceAdded.connect(visualDeviceAdded);
		VisualDeviceList.visualDevicelist.init(DeviceList.list);  //TODO can this be done in other way?
		//TODO remove the visual object too...
	}

	property int favoriteCount: 0

	function visualDeviceAdded(device){
		var visualDevice = Qt.createComponent("VisualDevice.qml");

		//TODO do like this at all? Or own list somehow? is this the right "level"?

		if(device.tabId() > 0){ //Check for correct tab, property of this favoriteLayoutObjects...
			var visualObject = visualDevice.createObject(tabArea);
			visualObject.x = device.layoutX();
			visualObject.y = device.layoutY();
			visualObject.tabId = device.tabId();
			visualObject.visualDeviceId = device.id();
			visualObject.deviceId = device.device().id();
			visualObject.deviceName = device.device().name();
			visualObject.deviceMethods = device.device().methods();
			visualObject.deviceState = device.device().state();
			visualObject.deviceStateValue = device.device().statevalue();
		}
	}
}

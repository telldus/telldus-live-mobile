import Qt 4.7
import ".."
import "VisualDeviceList.js" as VisualDeviceList
import "../DeviceList.js" as DeviceList

ListModel {
	id: favoriteLayoutObjects

	Component.onCompleted: {
		VisualDeviceList.tabAreaList.init(tabArea, favoriteLayout);
		VisualDeviceList.visualDevicelist.visualDeviceAdded.connect(visualDeviceAdded);
		VisualDeviceList.visualDevicelist.init(DeviceList.list);  //TODO can this be done in other way?
		//TODO remove the visual object too on device removal...
	}

	function visualDeviceAdded(device){
		var visualDevice = Qt.createComponent("VisualDevice.qml");

		var tabAreaObject = VisualDeviceList.tabAreaList.tab(device.tabId());

		//TODO do like this at all? Or own list somehow? is this the right "level"?

		if(device.tabId() > 0){ //Check for correct tab, property of this favoriteLayoutObjects...
			var visualObject = visualDevice.createObject(tabAreaObject);
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

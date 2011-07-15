import Qt 4.7
import ".."
import "VisualDeviceList.js" as VisualDeviceList
import "../DeviceList.js" as DeviceList
import "../Sensors.js" as Sensors
import "../mainscripts.js" as MainScripts

ListModel {
	id: favoriteLayoutObjects
	property variant visualList: {}

	Component.onCompleted: {
		VisualDeviceList.tabAreaList.init(tabArea, favoriteLayout, tabSelection.tabButtonRow, tabSelectionButton);
		VisualDeviceList.visualDevicelist.visualDeviceAdded.connect(visualDeviceAdded);
		VisualDeviceList.visualDevicelist.visualDeviceRemoved.connect(visualDeviceRemoved);
		VisualDeviceList.visualDevicelist.init(DeviceList.list, Sensors.list);  //TODO can this be done in other way?
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
			visualObject.type = device.type();

			if(device.type() == MainScripts.DEVICE){
				visualObject.deviceId = device.device().id();
				visualObject.deviceName = device.device().name();
				visualObject.deviceMethods = device.device().methods();
				visualObject.deviceState = device.device().state();
				visualObject.deviceStateValue = device.device().statevalue();
			}
			else if(device.type() == MainScripts.SENSOR){
				visualObject.deviceId = device.sensor().id();
				visualObject.deviceName = device.sensor().name();
			}
			favoriteLayout.selectedVisualDevice = visualObject.visualDeviceId
			VisualDeviceList.addVisualObject(visualObject);
		}
	}

	function visualDeviceRemoved(visualDeviceId){
		VisualDeviceList.removeVisualObject(visualDeviceId);
	}
}

import Qt 4.7
import ".."
import "VisualDeviceList.js" as VisualDeviceList
import "../mainscripts.js" as MainScripts

ListModel {
	id: favoriteLayoutObjects
	property variant visualList: {}

	Component.onCompleted: {
		VisualDeviceList.tabAreaList.init(tabArea, favoriteLayout, tabSelection.tabButtonRow, tabSelectionButton);
		VisualDeviceList.visualDevicelist.visualDeviceAdded.connect(visualDeviceAdded);
		VisualDeviceList.visualDevicelist.visualDeviceRemoved.connect(visualDeviceRemoved);
		VisualDeviceList.visualDevicelist.init(deviceModelController, sensorModel);  //TODO can this be done in other way?
	}

	function visualDeviceAdded(device){
		var visualDevice = Qt.createComponent("VisualDevice.qml");

		var tabAreaObject = VisualDeviceList.tabAreaList.tab(device.tabId());

		if(device.tabId() > 0){ //Check for correct tab, property of this favoriteLayoutObjects...
			var visualObject = visualDevice.createObject(tabAreaObject);
			visualObject.x = device.layoutX();
			visualObject.y = device.layoutY();
			visualObject.tabId = device.tabId();
			visualObject.visualDeviceId = device.id();
			visualObject.type = device.type();
			visualObject.expanded = device.expanded();

			if(device.type() == MainScripts.DEVICE){
				visualObject.device = device.device();
				visualObject.deviceId = device.device().id;
				visualObject.action = device.action();
				visualObject.actionvalue = device.actionvalue();
			}
			else if(device.type() == MainScripts.SENSOR){
				visualObject.device = device.sensor();
				visualObject.deviceId = device.sensor().id;
			}
			favoriteLayout.selectedVisualDevice = visualObject.visualDeviceId
			VisualDeviceList.addVisualObject(visualObject);
		}
	}

	function visualDeviceRemoved(visualDeviceId){
		VisualDeviceList.removeVisualObject(visualDeviceId);
	}
}

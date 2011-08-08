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
		VisualDeviceList.visualDevicelist.init(deviceModel, sensorModel);  //TODO can this be done in other way?
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

			if(device.type() == MainScripts.DEVICE){
				visualObject.deviceId = device.device().id;
				visualObject.deviceName = device.device().name;
				visualObject.deviceMethods = device.device().methods;
				visualObject.deviceState = device.device().state;
				visualObject.deviceStateValue = device.device().stateValue;
			}
			else if(device.type() == MainScripts.SENSOR){
				visualObject.deviceId = device.sensor().id;
				visualObject.deviceName = device.sensor().name;
				visualObject.hasHumidity = device.sensor().hasHumidity;
				visualObject.hasTemperature = device.sensor().hasTemperature;
				visualObject.humidity = device.sensor().humidity;
				visualObject.temperature = device.sensor().temperature;
			}
			favoriteLayout.selectedVisualDevice = visualObject.visualDeviceId
			VisualDeviceList.addVisualObject(visualObject);
		}
	}

	function visualDeviceRemoved(visualDeviceId){
		VisualDeviceList.removeVisualObject(visualDeviceId);
	}
}

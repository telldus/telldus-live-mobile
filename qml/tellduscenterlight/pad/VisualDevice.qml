import Qt 4.7
import ".."
import "../DeviceList.js" as DeviceList
import "../mainscripts.js" as MainScripts
import "VisualDeviceList.js" as VisualDeviceList

Rectangle {
	id: visualDevice
	height: MainScripts.VISUALDEVICEHEIGHT
	width: MainScripts.VISUALDEVICEWIDTH
	color: statusColor()
	z: selectedVisualDevice == visualDeviceId ? 150 : 5

	property int deviceId: 0
	property int visualDeviceId: 0
	property string deviceName: ''
	property int deviceMethods: 0
	property int deviceState: 0
	property string deviceStateValue: ''
	property int tabId: 1 //TODO
	property int type

	//make this default, then the content and size may differ, depending on for exampele sensor or device, and onclick event, but move etc common

	//TODO edit mode? When it's ok to move around stuff?

	Sensor {
		id: sensorItem
		sensorId: deviceId //type == MainScripts.SENSOR ? deviceId : -1
	}

	Text{

		anchors.centerIn: parent
		text: shortSensorText()

		visible: type == MainScripts.SENSOR

		function shortSensorText(){
			var shortString = "";
			if(sensorItem.hasHumidity){
				shortString = sensorItem.humidity + ' %';
			}
			if(sensorItem.hasHumidity && sensorItem.hasTemperature){
				shortString = shortString + ', '
			}
			if(sensorItem.hasTemperature){
				shortString = shortString + sensorItem.temperature + ' C';
			}
			return shortString;
		}
	}

	MouseArea {
		property int movedX: 0
		property int movedY: 0
		anchors.fill: parent
		drag.target: visualDevice
		drag.axis: Drag.XandYAxis
		drag.minimumX: 0
		drag.maximumX: favoriteLayout.width - visualDevice.width - MainScripts.TOOLBARWIDTH
		drag.minimumY: 0
		drag.maximumY: favoriteLayout.height - visualDevice.height
		onPressed: {
			favoriteLayout.selectedVisualDevice = visualDeviceId
			movedX = visualDevice.x
			movedY = visualDevice.y
		}

		onClicked: {
			infoBubble.visible = !infoBubble.visible
		}
		onReleased: {
			if(movedX != visualDevice.x || movedY != visualDevice.y){
				VisualDeviceList.visualDevicelist.visualDevice(visualDevice.visualDeviceId).layoutPosition(visualDevice.x, visualDevice.y, tabId);
			}
		}
		onPressAndHold: {
			visualDeviceMenu.visible = true
		}
	}

	DefaultMenu{
		//TODO here or only one for whole layout?
		id: visualDeviceMenu

		model: ListModel{
			ListElement{
				text: "Device options"
				showArrow: true
				isHeader: true
			}
			ListElement{
				text: "Remove from layout"
				optionValue: 'removefromlayout'
			}
		}

		onOptionSelected: {
			addToGroupMenu.visible = false
			if(value == "removefromlayout"){
				visualDevice.destroy();
				VisualDeviceList.visualDevicelist.visualDevice(visualDevice.visualDeviceId).deleteDevice();
			}
		}
		visible: false
	}

	Rectangle{
		id: infoBubble
		height: 200 //TODO
		width: 200 //TODO
		anchors.bottom: visualDevice.top
		anchors.bottomMargin: 110
		anchors.horizontalCenter: visualDevice.horizontalCenter

		Rectangle{
			id: infoSensor
			color: "white"
			height: 200 //TODO
			width: parent.width
			anchors.top: parent.top
			visible: type == MainScripts.SENSOR
			z: 3

			Column{
				anchors.centerIn: parent
				Text{
					text: sensorItem.name
				}
				Text{
					text: "Temperature: " + sensorItem.temperature + " C"
					visible: sensorItem.hasTemperature
				}
				Text{
					text: "Humidity: " + sensorItem.humidity + " %"
					visible: sensorItem.hasHumidity
				}
			}
		}

		Rectangle{
			id: infoDevice
			color: "white"
			height: 200 //TODO
			width: parent.width
			anchors.top: parent.top
			visible: type == MainScripts.DEVICE
			z:2

			Column{

				anchors.centerIn: parent
				Text{
					text: deviceName
				}

				Text{
					text: "Next run time: 23:45 070911" //TODO
				}

				Row{  //TODO possibly reuse?
					id: buttonrow

					ActionButton{
						text: "OFF"
						visible: MainScripts.methodContains(deviceMethods, "off")
						onClicked: {
							console.log("CLICKED off");
							DeviceList.list.device(deviceId).turnOff();
						}
					}

					ActionButton{
						text: "ON"
						visible: MainScripts.methodContains(deviceMethods, "on")
						onClicked: {
							console.log("CLICKED on");
							DeviceList.list.device(deviceId).turnOn();
						}
					}

					ActionButton{
						text: "BELL"
						visible: MainScripts.methodContains(deviceMethods, "bell")
						onClicked: {
							console.log("CLICKED BELL");
							DeviceList.list.device(deviceId).bell();
						}
					}
				}

				Slider{
					id: slider
					width: parent.width
					//anchors.top: buttonrow.bottom
					height: MainScripts.SLIDERHEIGHT
					visible: MainScripts.methodContains(deviceMethods, "dim")
					onSlided: {
						console.log("DIMMED to " + dimvalue);
						DeviceList.list.device(deviceId).dim(dimvalue);
					}

					Item {
						//This is a pseudo-item only for listening for changes in the model data
						property int state: deviceState
						onStateChanged: {
							if (state == DeviceList.METHOD_TURNON) {
								slider.value = slider.maximum;
							} else if (state == DeviceList.METHOD_TURNOFF) {
								slider.value = slider.minimum;
							}
						}
						property string stateValue: deviceStateValue
						onStateValueChanged: {
							if (state == DeviceList.METHOD_DIM) {
								slider.value = parseInt(stateValue, 10);
							}
						}
					}
				}
			}
		}
		Rectangle{
			id: bubblebottom
			height: 141  //TODO check out transformOrigin if this should be used at all
			width: 141
			rotation: 45
			color: "white"
			anchors.verticalCenter: parent.bottom
			anchors.horizontalCenter: parent.horizontalCenter
			z:1
		}

		visible:false

	}

	function statusColor(){  //TODO to icon
		if(deviceState == DeviceList.METHOD_TURNON){
			return "blue";
		}
		if(type == MainScripts.SENSOR){
			return "green";
		}

		return "red";
	}
}

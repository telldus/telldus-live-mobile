import Qt 4.7
import ".."
import "../mainscripts.js" as MainScripts
import "VisualDeviceList.js" as VisualDeviceList

Rectangle {
	id: visualDevice
	height: MainScripts.VISUALDEVICEHEIGHT
	width: type == MainScripts.SENSOR ? MainScripts.VISUALSENSORWIDTH : MainScripts.VISUALDEVICEWIDTH
	color: statusColor()
	z: infoBubble.visible || visualDeviceMenu.visible ? (selectedVisualDevice == visualDeviceId ? 160 : 150) : 5

	property int deviceId: 0
	property int visualDeviceId: 0
	property variant device: undefined
	property string deviceName: device == undefined ? '' : device.name
	property int deviceMethods: device == undefined || type != MainScripts.DEVICE ? 0 : device.methods
	property int deviceState: device == undefined || type != MainScripts.DEVICE ? 0 : device.state
	property string deviceStateValue: device == undefined || type != MainScripts.DEVICE ? '' : device.stateValue
	property int tabId: 1 //TODO
	property int type
	property int rotationAngle: (visualDevice.x - infoBubble.width/2)/2 * -1
	property bool hasHumidity: device == undefined || type != MainScripts.SENSOR ? false : device.hasHumidity
	property bool hasTemperature: device == undefined || type != MainScripts.SENSOR ? false : device.hasTemperature
	property string humidity: device == undefined || type != MainScripts.SENSOR ? '' : device.humidity
	property string temperature: device == undefined || type != MainScripts.SENSOR ? '' : device.temperature

	//make this default, then the content and size may differ, depending on for exampele sensor or device, and onclick event, but move etc common

	//TODO edit mode? When it's ok to move around stuff?

	Text{

		anchors.centerIn: parent
		text: shortSensorText()

		visible: type == MainScripts.SENSOR

		function shortSensorText(){
			var shortString = "";
			if(hasHumidity){
				shortString = humidity + ' %';
			}
			if(hasHumidity && hasTemperature){
				shortString = shortString + ', '
			}
			if(hasTemperature){
				shortString = shortString + temperature + ' C';
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
				favoriteLayout.visibleMenu = undefined
				visualDevice.destroy();
				VisualDeviceList.visualDevicelist.visualDevice(visualDevice.visualDeviceId).deleteDevice();
			}
		}
		visible: false

		onVisibleChanged: {
			if(visible){
				favoriteLayout.visibleMenu = visualDeviceMenu
			}
			else{
				favoriteLayout.visibleMenu = undefined
			}
		}
	}

	Rectangle{
		id: infoBubble
		height: MainScripts.INFOBUBBLEHEIGHT
		width: MainScripts.INFOBUBBLEWIDTH

		//transform: Rotation { origin.x: infoBubble.width/2; origin.y: infoBubble.height; angle: rotationAngle > 0 ? rotationAngle : 0 }
		//anchors.bottom: visualDevice.top
		//anchors.bottomMargin: 110

		states: [
			State {
				name: ""
				AnchorChanges {
					target: infoBubble
					anchors.horizontalCenter: visualDevice.horizontalCenter
					anchors.bottom: visualDevice.top
				}
			},
			State {
				name: "upperleft"; when: visualDevice.x - MainScripts.INFOBUBBLEWIDTH/2 < 0 && (visualDevice.y - MainScripts.INFOBUBBLEHEIGHT) < 0
				AnchorChanges {
					target: infoBubble
					anchors.horizontalCenter: undefined
					anchors.left: visualDevice.right
					anchors.bottom: undefined //TODO why is this needed
					anchors.top: visualDevice.bottom
				}
			},
			State {
				name: "upperright"; when: (visualDevice.x + MainScripts.VISUALDEVICEWIDTH/2 + MainScripts.INFOBUBBLEWIDTH/2 + MainScripts.TOOLBARWIDTH) > favoriteLayout.width && (visualDevice.y - MainScripts.INFOBUBBLEHEIGHT) < 0
				AnchorChanges {
					target: infoBubble
					anchors.horizontalCenter: undefined
					anchors.right: visualDevice.left
					anchors.bottom: undefined //TODO why is this needed
					anchors.top: visualDevice.bottom
				}
			}
			,
			State {
				name: "uppercenter"; when: (visualDevice.y - infoBubble.height) < 0
				AnchorChanges {
					target: infoBubble
					anchors.horizontalCenter: visualDevice.horizontalCenter
					anchors.bottom: undefined //TODO why is this needed
					anchors.top: visualDevice.bottom
				}
			},
			State {
				name: "lowerleft"; when: visualDevice.x - MainScripts.INFOBUBBLEWIDTH/2 < 0
				AnchorChanges {
					target: infoBubble
					anchors.horizontalCenter: undefined
					anchors.left: visualDevice.right
					anchors.top: undefined //TODO why is this needed
					anchors.bottom: visualDevice.top
				}
			},
			State {
				name: "lowerright"; when: (visualDevice.x + MainScripts.VISUALDEVICEWIDTH/2 + MainScripts.INFOBUBBLEWIDTH/2 + MainScripts.TOOLBARWIDTH) > favoriteLayout.width
				AnchorChanges {
					target: infoBubble
					anchors.horizontalCenter: undefined
					anchors.right: visualDevice.left
				}
			}
		]

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
					text: deviceName
				}
				Text{
					text: "Temperature: " + temperature + " C"
					visible: hasTemperature
				}
				Text{
					text: "Humidity: " + humidity + " %"
					visible: hasHumidity
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
							device.turnOff();
						}
					}

					ActionButton{
						text: "ON"
						visible: MainScripts.methodContains(deviceMethods, "on")
						onClicked: {
							console.log("CLICKED on");
							device.turnOn();
						}
					}

					ActionButton{
						text: "BELL"
						visible: MainScripts.methodContains(deviceMethods, "bell")
						onClicked: {
							console.log("CLICKED BELL");
							device.bell();
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
						device.dim(dimvalue);
					}

					Item {
						//This is a pseudo-item only for listening for changes in the model data
						property int state: deviceState
						onStateChanged: {
							if (state == MainScripts.METHOD_TURNON) {
								slider.value = slider.maximum;
							} else if (state == MainScripts.METHOD_TURNOFF) {
								slider.value = slider.minimum;
							}
						}
						property string stateValue: deviceStateValue
						onStateValueChanged: {
							if (state == MainScripts.METHOD_DIM) {
								slider.value = parseInt(stateValue, 10);
							}
						}
					}
				}
			}
		}
		/*
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
		*/

		visible:false

	}

	function statusColor(){  //TODO to icon
		if(deviceState == MainScripts.METHOD_TURNON){
			return "blue";
		}
		if(type == MainScripts.SENSOR){
			return "green";
		}

		return "red";
	}
}

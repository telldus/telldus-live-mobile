import Qt 4.7
import "mainscripts.js" as MainScripts
import "DeviceList.js" as DeviceList
import Telldus 1.0

Item{
	id: deviceElement
	property bool hideFavoriteToggle: false
	height: setElementHeight()
	width: parent == undefined ? 0 : parent.width

	MouseArea{
		anchors.fill: parent
		onClicked: {
			//TODO will this work (or is it too small, hard to avoid dim for example?), or press (for a while, "wasHeld") and then release to trigger this?
			if(selectedPane == MainScripts.FULL_DEVICE){
				selectedDevice = device;
				grouplist.wasHeld = false;
				var menu = deviceMenu;
				if(device.type == MainScripts.GROUPTYPE){
					menu = groupContentMenu;
					groupContentMenu.selectedGroup = device;
				}
				var newX = menuX(deviceElement, menu);
				menu.x = newX //TODO would rather use binding somehow, but isn't "parent or sibling"
				menu.y = deviceElement.y + deviceElement.height/4
			}
		}
		onPressAndHold: {
			if(selectedPane == MainScripts.FULL_DEVICE){
				grouplist.wasHeld = true;
				selectedDevice = device;
				var comp = Qt.createComponent("pad/GroupAddRemoveMenu.qml");

				var groupAddRemoveMenu = comp.createObject(main, {}); //TODO set initial values here (and remove undefined-checks)...

				groupAddRemoveMenu.selectedGroup = device;
				var newX = menuX(deviceElement, groupAddRemoveMenu);
				groupAddRemoveMenu.x = newX //TODO would rather use binding somehow, but isn't "parent or sibling"
				groupAddRemoveMenu.y = deviceElement.y + deviceElement.height/4
				main.groupAddRemoveMenu = groupAddRemoveMenu;
			}
		}
	}

	Item{
		anchors.fill: parent

		/*
		Image{
			id: status
			source: "/bla/bla"
		}
		*/
		Text{
			id: status
			text: statusIcon(device.state)
			font.pointSize: 25
		}

		Text{
			text: device.name
			anchors.left: status.right
			color: "red"
		}

		Text{
			id: favoriteicon
			anchors.right: parent.right
			text: device.isFavorite==true ? "\u2605" : "\u2606"
			font.pointSize: 30
			MouseArea{
				anchors.fill: parent
				onClicked: {
					device.isFavorite = !device.isFavorite
				}
			}
			visible: !hideFavoriteToggle
		}

		Row{
			id: buttonrow

			ActionButton{
				text: "OFF"
				visible: MainScripts.methodContains(device.methods, "off")
				onClicked: {
					console.log("CLICKED off");
					device.turnOff();
				}
			}

			ActionButton{
				text: "ON"
				visible: MainScripts.methodContains(device.methods, "on")
				onClicked: {
					console.log("CLICKED on");
					device.turnOn();
				}
			}

			ActionButton{
				text: "BELL"
				visible: MainScripts.methodContains(device.methods, "bell")
				onClicked: {
					console.log("CLICKED BELL");
					device.bell();
				}
			}
			anchors.right: favoriteicon.left
		}

		Slider{
			id: slider
			width: parent.width
			anchors.top: buttonrow.bottom
			height: MainScripts.SLIDERHEIGHT
			visible: MainScripts.methodContains(device.methods, "dim")
			//statevalue: deviceStateValue
			//state: deviceState
			onSlided: {
				console.log("DIMMED to " + dimvalue);
				device.dim(dimvalue);
			}

			Item {
				//This is a pseudo-item only for listening for changes in the model data
				property int state: device.state
				onStateChanged: {
					if (state == DeviceList.METHOD_TURNON) {
						slider.value = slider.maximum;
					} else if (state == DeviceList.METHOD_TURNOFF) {
						slider.value = slider.minimum;
					}
				}
				property string stateValue: device.stateValue
				onStateValueChanged: {
					if (state == DeviceList.METHOD_DIM) {
						slider.value = parseInt(stateValue, 10);
					}
				}
			}
		}
	}

	function menuX(deviceElement, menu){
		var newX = deviceElement.mapToItem(main, deviceElement.x, deviceElement.y).x + deviceElement.width;
		menu.align = 'right'
		if(newX >= main.width){
			newX = deviceElement.mapToItem(main, deviceElement.x, deviceElement.y).x - menu.width;  //place to the left instead, so that it's visible
			menu.align = 'left'
		}
		return newX;

	}

	function setElementHeight(){
		var height = MainScripts.DEVICEROWHEIGHT;
		if(slider.visible){
			height = height + MainScripts.SLIDERHEIGHT;
		}
		return height;
	}

	function statusIcon(state){ //TODO remove deviceItem later on
		//return state + " " + parseInt(deviceItem.statevalue, 10)
		if(state == DeviceList.METHOD_TURNON){
			return "\u263C";
		}
		else if(state == DeviceList.METHOD_TURNOFF){
			return "\u263D";
		}
		else if(state == DeviceList.METHOD_DIM){
			return "\u2601";
		}
		return "";
	}
}

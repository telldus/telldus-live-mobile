import Qt 4.7
import "mainscripts.js" as MainScripts
import "DeviceList.js" as DeviceList

Item{
	id: deviceElement
	height: setElementHeight()
	width: parent == undefined ? 0 : parent.width
	property bool hideFavorites: false
	visible: !hideFavorites || deviceIsFavorite

	MouseArea{
		anchors.fill: parent
		onClicked: {
			//TODO will this work (or is it too small, hard to avoid dim for example?), or press (for a while, "wasHeld") and then release to trigger this?
			if(selectedPane == MainScripts.FULL_DEVICE){
				selectedDevice = deviceId;
				var newX = deviceElement.mapToItem(main, deviceElement.x, deviceElement.y).x + deviceElement.width;
				deviceMenu.align = 'right'
				if(newX >= main.width){
					newX = deviceElement.mapToItem(main, deviceElement.x, deviceElement.y).x - deviceMenu.width;  //place to the left instead, so that it's visible
					deviceMenu.align = 'left'
				}

				deviceMenu.x = newX //TODO would rather use binding somehow, but isn't "parent or sibling"
				deviceMenu.y = deviceElement.y + deviceElement.height/4
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
			text: statusIcon(deviceState)
			font.pointSize: 25
		}

		Text{
			text: deviceName
			anchors.left: status.right
			color: "red"
		}

		Text{
			id: favoriteicon
			anchors.right: parent.right
			text: deviceIsFavorite==true ? "\u2605" : "\u2606"
			font.pointSize: 30
			MouseArea{
				anchors.fill: parent
				onClicked: {
					DeviceList.list.device(deviceId).setIsFavorite(!deviceIsFavorite)
				}
			}
			visible: !hideFavorites
		}

		Row{
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
			anchors.right: favoriteicon.left
		}

		Slider{
			id: slider
			width: parent.width
			anchors.top: buttonrow.bottom
			height: MainScripts.SLIDERHEIGHT
			visible: MainScripts.methodContains(deviceMethods, "dim")
			//statevalue: deviceStateValue
			//state: deviceState
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

	function setElementHeight(){
		var height = (!hideFavorites || deviceIsFavorite) ? MainScripts.DEVICEROWHEIGHT : 0;  //must set height to 0 to avoid space when hidden
		if(slider.visible){
			height = height + MainScripts.SLIDERHEIGHT;
		}
		return height;
	}

	function statusIcon(state){ //TODO remove deviceItem later on
		//return state + " " + parseInt(deviceItem.statevalue, 10)
		if(state == 1){
			return "\u263C";
		}
		else if(state == 2){
			return "\u263D";
		}
		else if(state == 16){
			return "\u2601";
		}
		return "";
	}
}

import Qt 4.7
import "mainscripts.js" as MainScripts
import "DeviceList.js" as DeviceList

Item{
	id: deviceElement
	height: setElementHeight()
	width: parent == undefined ? 0 : parent.width
	property bool hideFavorites: false
	visible: !hideFavorites || deviceIsFavorite

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

			Button{
				text: "OFF"
				visible: MainScripts.methodContains(deviceMethods, "off")
				onClicked: {
					console.log("CLICKED off");
					DeviceList.list.device(deviceId).turnOff();
				}
			}

			Button{
				text: "ON"
				visible: MainScripts.methodContains(deviceMethods, "on")
				onClicked: {
					console.log("CLICKED on");
					DeviceList.list.device(deviceId).turnOn();
				}
			}

			Button{
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

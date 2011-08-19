import Qt 4.7
import "mainscripts.js" as MainScripts
import "DeviceList.js" as DeviceList
import Telldus 1.0

Item{
	id: deviceElement
	property bool hideFavoriteToggle: false
	property bool showMenu: false
	height: setElementHeight()
	width: parent == undefined ? 0 : parent.width

	Item{
		anchors.fill: parent
		z: 2 //place above mousearea for whole device to allow clicks here
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

	/*
	function menuX(deviceElement, menu){
		menu.deviceElementLeftX = deviceElement.mapToItem(main, deviceElement.x, deviceElement.y).x;
		menu.deviceElementRightX = menu.deviceElementLeftX + deviceElement.width;
		menu.align = 'right'
		if(menu.deviceElementRightX >= main.width){
			menu.align = 'left'
		}
	}
	*/

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

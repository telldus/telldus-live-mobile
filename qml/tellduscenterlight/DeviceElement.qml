import QtQuick 1.1
import com.nokia.meego 1.0
import "mainscripts.js" as MainScripts
import "DeviceList.js" as DeviceList
import Telldus 1.0

Item{
	id: deviceElement
	height: layout.height
	anchors.left: parent == undefined ? undefined : parent.left
	anchors.right: parent == undefined ? undefined : parent.right
	anchors.margins: 16
	property bool hideFavoriteToggle: false

	/*MouseArea{ //TODO tablet
		anchors.fill: parent
		onClicked: {
			//TODO will this work (or is it too small, hard to avoid dim for example?), or press (for a while, "wasHeld") and then release to trigger this?
			if(selectedPane == MainScripts.FULL_DEVICE){
				selectedDevice = device;
				grouplist.wasHeld = false;
				var menu = deviceMenu;
				if(device.type == MainScripts.GROUPTYPE){
					menu = groupContentMenu;
				}
				var newX = menuX(deviceElement, menu);
				menu.x = newX //TODO would rather use binding somehow, but isn't "parent or sibling"
				menu.y = deviceElement.y + deviceElement.height/4
			}
		}
	}*/

	Column {
		id: layout
		width: parent.width
		spacing: 16

		Item {
			id: firstRowItem
			height:  firstRow.height
			width: parent.width
			Row {
				id: firstRow
				spacing: 10
				Text{
					id: status
					text: statusIcon(device.state)
					font.pointSize: 40
				}
				Text{
					anchors.verticalCenter: parent.verticalCenter
					text: device.name
					font.pixelSize: 26
					font.family: "Nokia Pure Text"
				}
			}
			Text{
				id: favoriteicon
				anchors.right: parent.right
				text: device.isFavorite==true ? "\u2605" : "\u2606"
				font.pointSize: 40
				MouseArea{
					anchors.fill: parent
					onClicked: {
						device.isFavorite = !device.isFavorite
					}
				}
				visible: !hideFavoriteToggle
			}
		}
		ButtonRow {
			exclusive: false

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
		}
		Slider {
			id: dimSlider
			stepSize:1
			valueIndicatorVisible: true
			minimumValue:0
			maximumValue:255
			width: parent.width
			visible: MainScripts.methodContains(device.methods, "dim")

			function formatValue ( v ) {
				return Math.round(v/255*100) + "%";
			}

			onPressedChanged: {
				if (pressed) {
					return;
				}
				device.dim(value);
				console.log("DIMMED to " + value);
			}
			Item {
				//This is a pseudo-item only for listening for changes in the model data
				property int state: device.state
				onStateChanged: {
					if (state == DeviceList.METHOD_TURNON) {
						dimSlider.value = dimSlider.maximumValue;
					} else if (state == DeviceList.METHOD_TURNOFF) {
						dimSlider.value = dimSlider.minimumValue;
					}
				}
				property string stateValue: device.stateValue
				onStateValueChanged: {
					if (state == DeviceList.METHOD_DIM) {
						dimSlider.value = parseInt(stateValue, 10);
					}
				}
			}
		}
	}

	/*Item{
		anchors.fill: parent
		anchors.margins: 16






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
	}*/

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

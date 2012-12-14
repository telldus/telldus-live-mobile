import QtQuick 1.0
import "mainscripts.js" as MainScripts
import "DeviceList.js" as DeviceList
import Telldus 1.0

Column{
	id: deviceElement
	spacing: 1
	property bool hideFavoriteToggle: false
	property bool showMenu: false
	width: parent == undefined ? 0 : parent.width

	Item {
		id: header
		anchors.left: parent.left
		anchors.right: parent.right
		height: 72
		BorderImage {
			source: "header_bg.png"
			anchors.fill: parent
			border.left: 10; border.top: 10
			border.right: 10; border.bottom: 10
		}

		Text{
			id: status
			anchors.left: parent.left
			anchors.leftMargin: 10
			anchors.verticalCenter: parent.verticalCenter
			text: statusIcon(device.state)
			font.pointSize: 25
		}
		Text{
			text: device.name
			anchors.left: status.right
			anchors.leftMargin: 10
			anchors.right: favoriteicon.right
			anchors.rightMargin: 10
			color: "white"
			font.weight: Font.Bold
			height: parent.height
			verticalAlignment: Text.AlignVCenter
		}
		Text{
			id: favoriteicon
			anchors.right: parent.right
			anchors.rightMargin: 10
			anchors.verticalCenter: parent.verticalCenter
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
	}

	BorderImage {
		source: "row_bg.png"
		height: actionContent.height + 10
		anchors.left: parent.left
		anchors.right: parent.right
		border.left: 10; border.top: 10
		border.right: 10; border.bottom: 10

		Column {
			id: actionContent
			y: 5
			anchors.left: parent.left
			anchors.leftMargin: 5
			anchors.right: parent.right
			anchors.rightMargin: 5
			spacing: 5

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
			}

			Slider{
				id: slider
				width: parent.width
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
	}

	function statusIcon(state){
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

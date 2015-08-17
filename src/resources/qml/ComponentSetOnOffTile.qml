import QtQuick 2.0
import Telldus 1.0

Item {
	property var deviceState: device.state
	anchors.fill: parent
	onDeviceStateChanged: {
		if (deviceState == 1 || deviceState == 16) {
			tile.saturation = tile.saturationDefault
			tile.lightness = tile.lightnessDefault
		} else {
			tile.saturation = 0
			tile.lightness = tile.lightnessDefault * 1.2
		}
	}

	MouseArea {
		id: buttonsMouseArea
		preventStealing: true
		anchors.fill: parent
//		onPressAndHold: pressedAndHeld()
//		onPressedChanged: {
//			if (!pressed) {
				//dimArea.shown = false
//			}
//		}
		onReleased: {
			var maxY = dimArea.height - dimHandle.height;
			var value = Math.round(dimHandle.y / maxY * 255);
			console.log("Sending new dim value: " + value);
			device.dim(value);
		}
		drag.target: dimHandle
		drag.axis: Drag.XandYAxis
		drag.minimumX: 0
		drag.maximumX: 0
		drag.minimumY: 0
		drag.maximumY: dimArea.height - dimHandle.height
	}

	Rectangle {
		id: onButtonBackgroundSquarer1
		width: onButton.width / 2
		anchors.top: onButton.top
		anchors.right: onButton.right
		anchors.bottom: onButton.bottom
		color: onButton.color
	}
	Rectangle {
		id: onButtonBackgroundSquarer2
		height: onButton.height / 2
		anchors.left: onButton.left
		anchors.right: onButton.right
		anchors.bottom: onButton.bottom
		color: onButton.color
	}
	Rectangle {
		id: onButton
		height: parent.height
		width: parent.width / 2
		anchors.left: parent.left
		color: (deviceState == 1 || deviceState == 16) ? Qt.hsla(tile.hue, tile.saturation, tile.lightness * 1.2, 1) : "#ffffff"
		radius: tileWhite.radius
		Rectangle {
			anchors.verticalCenter: parent.verticalCenter
			anchors.horizontalCenter: parent.horizontalCenter
			color: (deviceState == 1 || deviceState == 16) ? "#ffffff" : Qt.hsla(tile.hue, tile.saturation, tile.lightness * 1.2, 1)
			width: parent.width / 15
			height: parent.height / 3.25
		}
		MouseArea {
			id: onMouseArea
			preventStealing: true
			anchors.fill: parent
			drag.target: dimHandle
			drag.axis: Drag.XandYAxis
			drag.minimumX: 0
			drag.maximumX: 0
			drag.minimumY: 0
			drag.maximumY: dimArea.height - dimHandle.height
			onPressAndHold: pressedAndHeld()
			onClicked: {
				device.turnOn()
			}
			onPressedChanged: {
				if (!pressed) {
					//dimArea.shown = false
				}
			}
		}
	}

	Rectangle {
		id: offButtonBackgroundSquarer1
		width: offButton.width / 2
		anchors.top: offButton.top
		anchors.left: offButton.left
		anchors.bottom: offButton.bottom
		color: offButton.color
	}
	Rectangle {
		id: offButtonBackgroundSquarer2
		height: offButton.height / 2
		anchors.left: offButton.left
		anchors.right: offButton.right
		anchors.bottom: offButton.bottom
		color: offButton.color
	}
	Rectangle {
		id: offButton
		height: parent.height
		width: parent.width / 2
		anchors.right: parent.right
		color: deviceState == 2 ? Qt.hsla(tile.hue, tile.saturation, tile.lightness * 1.2, 1) : "#ffffff"
		radius: tileWhite.radius
		Rectangle {
			anchors.verticalCenter: parent.verticalCenter
			anchors.horizontalCenter: parent.horizontalCenter
			color: deviceState == 2 ? "#ffffff" : Qt.hsla(tile.hue, tile.saturation, tile.lightness * 1.2, 1)
			height: parent.height / 3.25
			width: height
			radius: width / 2
			Rectangle {
				anchors.fill: parent
				anchors.margins: offButton.width / 15
				color: deviceState == 2 ? Qt.hsla(tile.hue, tile.saturation, tile.lightness * 1.2, 1) : "#ffffff"
				radius: width / 2
			}
		}
		MouseArea {
			id: offMouseArea
			preventStealing: true
			anchors.fill: parent
			drag.target: dimHandle
			drag.axis: Drag.XandYAxis
			drag.minimumX: 0
			drag.maximumX: 0
			drag.minimumY: 0
			drag.maximumY: dimArea.height - dimHandle.height
			onClicked: device.turnOff()
			onPressAndHold: pressedAndHeld()
			onPressedChanged: {
				if (!pressed) {
					//dimArea.shown = false
				}
			}
		}
	}
	Item {
		id: dimArea
		anchors.fill: parent
		visible: !((methods & 16) == 0)
		Rectangle {
			id: dimHandle
			height: parent.height * 0.15
			width: height
			radius: height / 2
			anchors.horizontalCenter: parent.horizontalCenter
			y: dimValue()
			onYChanged: {
				// Code below would enable live updating of dimmers
				//	var maxY = dimArea.height - dimHandle.height;
				//	var value = Math.round(dimHandle.y / maxY * 255);
				//	console.log("Sending new dim value: " + value);
				//	device.dim(value);
			}
			color: Qt.hsla(tile.hue, tile.saturation, tile.lightness * 0.8, 1)
			Connections {
				target: device
				onStateValueChanged: {
					dimHandle.y = dimValue()
				}
			}
		}
	}
	function dimValue() {
		var maxY = dimArea.height - dimHandle.height;
		var dimValue = maxY - ((device.stateValue / 255) * maxY);
		return dimValue;
	}
	function pressedAndHeld() {
		if ((methods & 16) == 0) {
			return;
		}
	}
}

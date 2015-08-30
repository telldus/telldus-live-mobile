import QtQuick 2.0
import Telldus 1.0

Item {
	property var deviceState: device.state
	anchors.fill: parent
	Component.onCompleted: {
		tile.showBorder = true;
	}
	onDeviceStateChanged: {
		if (deviceState == 1 || deviceState == 16) {
			tile.hue = 0.08
			tile.saturation = 0.99
			tile.lightness = 0.45
//			tile.hue = 0.33
//			tile.saturation = 1
//			tile.lightness = 0.3
		} else if (deviceState == 2) {
			tile.hue = 0.08
			tile.saturation = 0.25
			tile.lightness = 0.8
		} else {
			tile.hue = tile.hueDefault
			tile.saturation = tile.saturationDefault
			tile.lightness = tile.lightnessDefault
		}
	}

	MouseArea {
		id: buttonsMouseArea
		preventStealing: true
		anchors.fill: parent
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
		visible: tile.hasNameInTile
		height: onButton.height / 2
		anchors.left: onButton.left
		anchors.right: onButton.right
		anchors.bottom: onButton.bottom
		color: onButton.color
	}
	Rectangle {
		id: onButton
		height: parent.height
		anchors.right: tileSeperator.left
		anchors.left: parent.left
		color: (deviceState == 1 || deviceState == 16) ? Qt.hsla(tile.hue, 0.1, 0.95, 1) : "#ffffff"
		radius: tileBorder.radius
		Text {
			id: onButtonText
			anchors.verticalCenter: parent.verticalCenter
			anchors.horizontalCenter: parent.horizontalCenter
			color: (deviceState == 1 || deviceState == 16) ? Qt.hsla(tile.hue, tile.saturation, tile.lightness, 1) : Qt.hsla(0, 0, 0.8, 1)
			font.pixelSize: parent.width / 3
			font.weight: Font.Bold
			text: "On"
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
			onPressed: {
				onButton.color = Qt.hsla(tile.hue, 0.2, 0.9, 1)
				onButtonText.color = "#ffffff"

			}
			onClicked: {
				device.turnOn()
			}
			onReleased: {
				onButton.color = ((deviceState == 1 || deviceState == 16) ? Qt.hsla(tile.hue, 0.1, 0.95, 1) : "#ffffff")
				offButton.color = (deviceState == 2 ? Qt.hsla(tile.hue, 0.1, 0.95, 1) : "#ffffff")
				onButtonText.color = ((deviceState == 1 || deviceState == 16) ? Qt.hsla(tile.hue, tile.saturation, tile.lightness, 1) : Qt.hsla(0, 0, 0.8, 1))
				offButtonText.color = (deviceState == 2 ? Qt.hsla(tile.hue, tile.saturation, tile.lightness, 1) : Qt.hsla(0, 0, 0.8, 1))
			}
		}
	}

	Rectangle {
		id: tileSeperator
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		anchors.horizontalCenter: parent.horizontalCenter
		width: 1 * SCALEFACTOR
		color: Qt.hsla(tile.hue, 0.3, 0.7, 1)
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
		visible: tile.hasNameInTile
		height: offButton.height / 2
		anchors.left: offButton.left
		anchors.right: offButton.right
		anchors.bottom: offButton.bottom
		color: offButton.color
	}
	Rectangle {
		id: offButton
		height: parent.height
		anchors.left: tileSeperator.right
		anchors.right: parent.right
		color: deviceState == 2 ? Qt.hsla(tile.hue, 0.1, 0.95, 1) : "#ffffff"
		radius: tileBorder.radius
		Text {
			id: offButtonText
			anchors.verticalCenter: parent.verticalCenter
			anchors.horizontalCenter: parent.horizontalCenter
			color: deviceState == 2 ? Qt.hsla(tile.hue, tile.saturation, tile.lightness, 1) : Qt.hsla(0, 0, 0.8, 1)
			font.pixelSize: parent.width / 3
			font.weight: Font.Bold
			text: "Off"
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
			onPressed: {
				offButton.color = Qt.hsla(tile.hue, 0.2, 0.9, 1)
				offButtonText.color = "#ffffff"
			}
			onClicked: {
				device.turnOff()
			}
			onReleased: {
				onButton.color = ((deviceState == 1 || deviceState == 16) ? Qt.hsla(tile.hue, 0.1, 0.95, 1) : "#ffffff")
				offButton.color = (deviceState == 2 ? Qt.hsla(tile.hue, 0.1, 0.95, 1) : "#ffffff")
				onButtonText.color = ((deviceState == 1 || deviceState == 16) ? Qt.hsla(tile.hue, tile.saturation, tile.lightness, 1) : Qt.hsla(0, 0, 0.8, 1))
				offButtonText.color = (deviceState == 2 ? Qt.hsla(tile.hue, tile.saturation, tile.lightness, 1) : Qt.hsla(0, 0, 0.8, 1))
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
			color: Qt.hsla(tile.hue, tile.saturation, tile.lightness, 1)
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

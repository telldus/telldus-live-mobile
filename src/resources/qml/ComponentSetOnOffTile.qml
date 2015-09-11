import QtGraphicalEffects 1.0
import QtQuick 2.0
import Telldus 1.0
import Tui 0.1

Item {
	property var deviceState: device.state
	anchors.fill: parent
	focus: true

	Component.onCompleted: {
		tile.showBorder = true;
	}

	Keys.onPressed: {
		if (properties.ui.supportsKeys) {
			if (event.key == Qt.Key_Enter) {
				if (deviceState == 1 || deviceState == 16) {
					device.turnOff();
				} else {
					device.turnOn();
				}
				event.accepted = true;
			}
		}
	}

	onDeviceStateChanged: {
		if (deviceState == 1 || deviceState == 16) {
			tile.hue = 0.08
			tile.saturation = 0.99
			tile.lightness = 0.45
			onButtonText.color = "#43A047"
			offButtonText.color = "#757575"
		} else if (deviceState == 2) {
			tile.hue = 0.0
			tile.saturation = 0.0
			tile.lightness = 0.74
			onButtonText.color = "#757575"
			offButtonText.color = "#E53935"
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
		anchors.left: onButton.left
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
		anchors.right: parent.right
		anchors.left: tileSeperator.right
		color: (deviceState == 1 || deviceState == 16) ? "#FAFAFA" : "#EEEEEE"
		radius: tileCard.radius
		Text {
			id: onButtonText
			anchors.verticalCenter: parent.verticalCenter
			anchors.horizontalCenter: parent.horizontalCenter
			color: (deviceState == 1 || deviceState == 16) ? Qt.hsla(tile.hue, tile.saturation, tile.lightness, 1) : Qt.hsla(0, 0, 0.8, 1)
			font.pixelSize: onButton.height < onButton.width ? parent.height * 0.4 : parent.height * 0.2
			font.weight: Font.Bold
			text: "On"
		}
		LinearGradient {
			visible: deviceState == 1 || deviceState == 16
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.bottom: parent.bottom
			width: 3 * SCALEFACTOR
			start: Qt.point(0, 0)
			end: Qt.point(3 * SCALEFACTOR, 0)
			gradient: Gradient {
				GradientStop { position: 0.0; color: "#609E9E9E" }
				GradientStop { position: 1.0; color: "#009E9E9E" }
			}
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
				device.turnOn()
//				onButton.color = Qt.hsla(tile.hue, 0.2, 0.9, 1)
			}
			onReleased: {
//				onButton.color = (deviceState == 1 || deviceState == 16) ? "#FFFFFF" : Qt.hsla(tile.hue, 0.1, 0.92, 1)
//				offButton.color = deviceState == 2 ? "#FFFFFF" : Qt.hsla(tile.hue, 0.1, 0.92, 1)
			}
		}
	}
	Rectangle {
		id: tileSeperator
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		anchors.horizontalCenter: parent.horizontalCenter
		width: 1 * SCALEFACTOR
		color: "#BDBDBD"
	}

	Rectangle {
		id: offButtonBackgroundSquarer1
		width: offButton.width / 2
		anchors.top: offButton.top
		anchors.right: offButton.right
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
		anchors.left: parent.left
		anchors.right: tileSeperator.left
		color: deviceState == 2 ? "#FAFAFA" : "#EEEEEE"
		radius: tileCard.radius
		Text {
			id: offButtonText
			anchors.verticalCenter: parent.verticalCenter
			anchors.horizontalCenter: parent.horizontalCenter
			color: deviceState == 2 ? Qt.hsla(tile.hue, tile.saturation, tile.lightness, 1) : Qt.hsla(0, 0, 0.8, 1)
			font.pixelSize: offButton.height < offButton.width ? parent.height * 0.4 : parent.height * 0.2
			font.weight: Font.Bold
			text: "Off"
		}
		LinearGradient {
			visible: deviceState == 2
			anchors.top: parent.top
			anchors.right: parent.right
			anchors.bottom: parent.bottom
			width: 3 * SCALEFACTOR
			start: Qt.point(0, 0)
			end: Qt.point(3 * SCALEFACTOR, 0)
			gradient: Gradient {
				GradientStop { position: 0.0; color: "#009E9E9E" }
				GradientStop { position: 1.0; color: "#609E9E9E" }
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
			onPressed: {
				device.turnOff()
//				offButton.color = Qt.hsla(tile.hue, 0.2, 0.9, 1)
			}
			onReleased: {
//				onButton.color = (deviceState == 1 || deviceState == 16) ? "#FFFFFF" : Qt.hsla(tile.hue, 0.1, 0.92, 1)
//				offButton.color = deviceState == 2 ? "#FFFFFF" : Qt.hsla(tile.hue, 0.1, 0.92, 1)
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
			Image {
				id: dimHandleArrows
				width: parent.width
				height: parent.height
				anchors.centerIn: parent
				source: "../svgs/deviceIconDim.svg"
				asynchronous: true
				smooth: true
				sourceSize.width: width * 2
				sourceSize.height: height * 2
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

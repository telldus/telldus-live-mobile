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

	onDeviceStateChanged: updateButtonColors()

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
			anchors.fill: parent
			drag.target: dimHandle
			drag.axis: Drag.XandYAxis
			drag.minimumX: 0
			drag.maximumX: 0
			drag.minimumY: 0
			drag.maximumY: dimArea.height - dimHandle.height
			onPressed: updateButtonColors()
			onReleased: buttonReleased("onMouseArea")
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
			anchors.fill: parent
			drag.target: dimHandle
			drag.axis: Drag.XandYAxis
			drag.minimumX: 0
			drag.maximumX: 0
			drag.minimumY: 0
			drag.maximumY: dimArea.height - dimHandle.height
			onPressed: updateButtonColors()
			onReleased: buttonReleased("offMouseArea")
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
			color: Qt.hsla(tile.hue, tile.saturation, tile.lightness, 1)
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
	function buttonReleased(sender) {
		updateButtonColors()
		var maxY = dimArea.height - dimHandle.height;
		var value = 255 - Math.round(dimHandle.y / maxY * 255);
		if (value == device.stateValue) {
			if (sender == "offMouseArea") {
				device.turnOff()
			} else if (sender == "onMouseArea") {
				device.turnOn()
			}
		} else {
			if (value == 0) {
				device.turnOff();
			} else if (value == 255) {
				device.turnOn();
			} else {
				device.dim(value);
			}
		}
	}
	function dimValue() {
		var maxY = dimArea.height - dimHandle.height;
		var dimValue = maxY - ((device.stateValue / 255) * maxY);
		return dimValue;
	}
	function updateButtonColors() {
		if (deviceState == 1 || deviceState == 16) {
			tile.hue = 0.08
			tile.saturation = 0.99
			tile.lightness = 0.45
			offButton.color = offMouseArea.pressed ? "#DDDDDD" : "#EEEEEE"
			onButton.color = onMouseArea.pressed ? "#EAEAEA" : "#FAFAFA"
			onButtonText.color = "#43A047"
			offButtonText.color = "#757575"
		} else if (deviceState == 2) {
			tile.hue = 0.0
			tile.saturation = 0.0
			tile.lightness = 0.74
			offButton.color = offMouseArea.pressed ? "#EAEAEA" : "#FAFAFA"
			onButton.color = onMouseArea.pressed ? "#DDDDDD" : "#EEEEEE"
			onButtonText.color = "#757575"
			offButtonText.color = "#E53935"
		} else {
			offButton.color = offMouseArea.pressed ? "#DDDDDD" : "#EEEEEE"
			onButton.color = onMouseArea.pressed ? "#DDDDDD" : "#EEEEEE"
			tile.hue = tile.hueDefault
			tile.saturation = tile.saturationDefault
			tile.lightness = tile.lightnessDefault
		}
	}
}

import QtQuick 2.0
import Telldus 1.0

Item {
	property bool supportsStop: methods & 512
	property var deviceState: device.state
	anchors.fill: parent
	Component.onCompleted: {
		tile.showBorder = true;
		tile.hue = 0.08
		tile.saturation = 0.99
		tile.lightness = 0.45
	}

	Rectangle {
		id: upButtonBackgroundSquarer1
		width: upButton.width / 2
		anchors.top: upButton.top
		anchors.right: upButton.right
		anchors.bottom: upButton.bottom
		color: upButton.color
	}
	Rectangle {
		id: upButtonBackgroundSquarer2
		visible: tile.hasNameInTile
		height: upButton.height / 2
		anchors.left: upButton.left
		anchors.right: upButton.right
		anchors.bottom: upButton.bottom
		color: upButton.color
	}
	Rectangle {
		id: upButton
		height: parent.height / 2
		anchors.right: tileSeperator.left
		anchors.left: parent.left
		color: (deviceState == 1 || deviceState == 16) ? Qt.hsla(tile.hue, 0.1, 0.95, 1) : "#ffffff"
		radius: tileCard.radius
		Text {
			id: upButtonText
			anchors.verticalCenter: parent.verticalCenter
			anchors.horizontalCenter: parent.horizontalCenter
			color: (deviceState == 1 || deviceState == 16) ? Qt.hsla(tile.hue, tile.saturation, tile.lightness, 1) : Qt.hsla(0, 0, 0.8, 1)
			font.pixelSize: parent.width / 3
			font.weight: Font.Bold
			text: "Up"
		}
		MouseArea {
			id: upMouseArea
			preventStealing: true
			anchors.fill: parent
			onPressed: {
				upButton.color = Qt.hsla(tile.hue, 0.2, 0.9, 1)
				upButtonText.color = "#ffffff"

			}
			onClicked: {
				device.up()
			}
			onReleased: {
				upButton.color = ((deviceState == 1 || deviceState == 16) ? Qt.hsla(tile.hue, 0.1, 0.95, 1) : "#ffffff")
				stopButton.color = (deviceState == 2 ? Qt.hsla(tile.hue, 0.1, 0.95, 1) : "#ffffff")
				upButtonText.color = ((deviceState == 1 || deviceState == 16) ? Qt.hsla(tile.hue, tile.saturation, tile.lightness, 1) : Qt.hsla(0, 0, 0.8, 1))
				stopButtonText.color = (deviceState == 2 ? Qt.hsla(tile.hue, tile.saturation, tile.lightness, 1) : Qt.hsla(0, 0, 0.8, 1))
			}
		}
	}
	Rectangle {
		id: downButton
		height: parent.height / 2
		anchors.top: upButton.bottom
		anchors.right: tileSeperator.left
		anchors.left: parent.left
		color: (deviceState == 1 || deviceState == 16) ? Qt.hsla(tile.hue, 0.1, 0.95, 1) : "#ffffff"
		radius: tileCardti.radius
		Text {
			id: downButtonText
			anchors.verticalCenter: parent.verticalCenter
			anchors.horizontalCenter: parent.horizontalCenter
			color: (deviceState == 1 || deviceState == 16) ? Qt.hsla(tile.hue, tile.saturation, tile.lightness, 1) : Qt.hsla(0, 0, 0.8, 1)
			font.pixelSize: parent.width / 3
			font.weight: Font.Bold
			text: "Down"
		}
		MouseArea {
			id: downMouseArea
			preventStealing: true
			anchors.fill: parent
			onPressed: {
				downButton.color = Qt.hsla(tile.hue, 0.2, 0.9, 1)
				downButtonText.color = "#ffffff"

			}
			onClicked: {
				device.down()
			}
			onReleased: {
				downButton.color = ((deviceState == 1 || deviceState == 16) ? Qt.hsla(tile.hue, 0.1, 0.95, 1) : "#ffffff")
				stopButton.color = (deviceState == 2 ? Qt.hsla(tile.hue, 0.1, 0.95, 1) : "#ffffff")
				downButtonText.color = ((deviceState == 1 || deviceState == 16) ? Qt.hsla(tile.hue, tile.saturation, tile.lightness, 1) : Qt.hsla(0, 0, 0.8, 1))
				stopButtonText.color = (deviceState == 2 ? Qt.hsla(tile.hue, tile.saturation, tile.lightness, 1) : Qt.hsla(0, 0, 0.8, 1))
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
		id: stopButtonBackgroundSquarer1
		width: stopButton.width / 2
		anchors.top: stopButton.top
		anchors.left: stopButton.left
		anchors.bottom: stopButton.bottom
		color: stopButton.color
	}
	Rectangle {
		id: stopButtonBackgroundSquarer2
		visible: tile.hasNameInTile
		height: stopButton.height / 2
		anchors.left: stopButton.left
		anchors.right: stopButton.right
		anchors.bottom: stopButton.bottom
		color: stopButton.color
	}
	Rectangle {
		id: stopButton
		height: parent.height
		anchors.left: tileSeperator.right
		anchors.right: parent.right
		color: deviceState == 2 ? Qt.hsla(tile.hue, 0.1, 0.95, 1) : "#ffffff"
		radius: tileCard.radius
		Text {
			id: stopButtonText
			anchors.verticalCenter: parent.verticalCenter
			anchors.horizontalCenter: parent.horizontalCenter
			color: deviceState == 2 ? Qt.hsla(tile.hue, tile.saturation, tile.lightness, 1) : Qt.hsla(0, 0, 0.8, 1)
			font.pixelSize: parent.width / 3
			font.weight: Font.Bold
			text: "Stop"
		}
		MouseArea {
			id: stopMouseArea
			preventStealing: true
			anchors.fill: parent
			onPressed: {
				stopButton.color = Qt.hsla(tile.hue, 0.2, 0.9, 1)
				stopButtonText.color = "#ffffff"
			}
			onClicked: {
				device.stop()
			}
			onReleased: {
				upButton.color = ((deviceState == 1 || deviceState == 16) ? Qt.hsla(tile.hue, 0.1, 0.95, 1) : "#ffffff")
				stopButton.color = (deviceState == 2 ? Qt.hsla(tile.hue, 0.1, 0.95, 1) : "#ffffff")
				upButtonText.color = ((deviceState == 1 || deviceState == 16) ? Qt.hsla(tile.hue, tile.saturation, tile.lightness, 1) : Qt.hsla(0, 0, 0.8, 1))
				stopButtonText.color = (deviceState == 2 ? Qt.hsla(tile.hue, tile.saturation, tile.lightness, 1) : Qt.hsla(0, 0, 0.8, 1))
			}
		}
	}
}
/*
import QtQuick 2.0
import Telldus 1.0

Item {
	property bool supportsStop: methods & 512
	anchors.fill: parent
	anchors.margins: 10 * SCALEFACTOR
	Component.onCompleted: {
		tile.showBorder = true;
	}
	Item {
		id: downButton
		height: parent.height
		anchors.left: parent.left
		anchors.right: supportsStop ? stopButton.left : parent.horizontalCenter
		BorderImage {
			anchors.fill: parent
			border {left: 15; top: 49; right: 0; bottom: 49 }
			source: "../images/buttonBgClickLeft.png"
			opacity: downMouseArea.pressed ? 1 : 0
		}
		Image {
			anchors.centerIn: parent
			source: device.state == 256 ? "../images/buttonActionDownActive.png" : "../images/buttonActionDown.png"
		}
		MouseArea {
			id: downMouseArea
			preventStealing: true
			anchors.fill: parent
			onClicked: device.down()
		}
	}
	Item {
		id: stopButton
		visible: supportsStop ? true : false
		height: parent.height
		width: parent.width/3
		anchors.horizontalCenter: parent.horizontalCenter
		Image {
			anchors.fill: parent
			source: "../images/buttonBgClickMiddle.png"
			opacity: stopMouseArea.pressed ? 1 : 0
			fillMode: Image.TileHorizontally
		}
		Image {
			anchors.centerIn: parent
			source: device.state == 512 ? "../images/buttonActionStopActive.png" : "../images/buttonActionStop.png"
		}
		MouseArea {
			id: stopMouseArea
			preventStealing: true
			anchors.fill: parent
			onClicked: device.stop()
		}
	}
	Item {
		id: upButton
		anchors.left: supportsStop ? stopButton.right : downButton.right
		anchors.right: parent.right
		height: parent.height
		BorderImage {
			anchors.fill: parent
			border {left: 0; top: 49; right: 15; bottom: 49 }
			source: "../images/buttonBgClickRight.png"
			opacity: upMouseArea.pressed ? 1 : 0
		}
		Image {
			anchors.centerIn: parent
			source: device.state == 128 ? "../images/buttonActionUpActive.png" : "../images/buttonActionUp.png"
		}
		MouseArea {
			id: upMouseArea
			preventStealing: true
			anchors.fill: parent
			onClicked: device.up()
		}
	}
	Item {
		anchors.left: downButton.right
		anchors.leftMargin: -2
		width: childrenRect.width
		height: parent.height
		Image {
			anchors.verticalCenter: parent.verticalCenter
			source: "../images/buttonDivider.png"
			height: 70
			fillMode: Image.TileVertically
		}
	}
	Item {
		anchors.right: upButton.left
		anchors.rightMargin: -2
		visible: supportsStop ? true : false
		height: parent.height
		width: childrenRect.width
		Image {
			anchors.verticalCenter: parent.verticalCenter
			source: "../images/buttonDivider.png"
			height: 70
			fillMode: Image.TileVertically
		}
	}
}*/

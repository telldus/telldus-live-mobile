import QtQuick 2.0
import Telldus 1.0
import Tui 0.1

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

	onDeviceStateChanged: updateButtons();

	Row {
		anchors.fill: parent
		Item {
			height: parent.height
			width: parent.width / 3
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
				anchors.fill: parent
				color: "#ffffff"
				radius: tileCard.radius
				Item {
					id: upButtonIcon
					anchors.centerIn: parent
					height: Math.min(parent.width, parent.height)
					width: height
					Image {
						id: upButtonIconImage
						anchors.fill: parent
						anchors.margins: Units.dp(8)
						source: "image://icons/arrowUp/" + (deviceState == 128 ? Qt.hsla(0.6, 0.55, 0.24, 1) : Qt.hsla(0, 0, 0.8, 1))
						asynchronous: true
						smooth: true
						fillMode: Image.PreserveAspectFit
						sourceSize.width: width * 2
						sourceSize.height: height * 2
					}
				}
				MouseArea {
					id: upMouseArea
					anchors.fill: parent
					onPressed: {
						upButton.color = "#EAEAEA"
					}
					onClicked: {
						device.up()
					}
					onReleased: updateButtons();
				}
			}
		}
		Item {
			height: parent.height
			width: parent.width / 3
			Rectangle {
				id: downButton
				anchors.fill: parent
				color: "#ffffff"
				radius: tileCard.radius
				Item {
					id: downButtonIcon
					anchors.centerIn: parent
					height: Math.min(parent.width, parent.height)
					width: height
					Image {
						id: downButtonIconImage
						anchors.fill: parent
						anchors.margins: Units.dp(8)
						source: "image://icons/arrowDown/" + (deviceState == 256 ? Qt.hsla(0.6, 0.55, 0.24, 1) : Qt.hsla(0, 0, 0.8, 1))
						asynchronous: true
						smooth: true
						fillMode: Image.PreserveAspectFit
						sourceSize.width: width * 2
						sourceSize.height: height * 2
					}
				}
				MouseArea {
					id: downMouseArea
					anchors.fill: parent
					onPressed: {
						downButton.color = "#EAEAEA"
					}
					onClicked: {
						device.down()
					}
					onReleased: updateButtons();
				}
			}
		}
		Item {
			height: parent.height
			width: parent.width / 3
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
				anchors.fill: parent
				color: "#ffffff"
				radius: tileCard.radius
				Item {
					id: stopButtonIcon
					anchors.centerIn: parent
					height: Math.min(parent.width, parent.height)
					width: height
					Image {
						id: stopButtonIconImage
						anchors.fill: parent
						anchors.margins: Units.dp(8)
						source: "image://icons/stop/" + (deviceState == 512 ? Qt.hsla(0.6, 0.55, 0.24, 1) : Qt.hsla(0, 0, 0.8, 1))
						asynchronous: true
						smooth: true
						fillMode: Image.PreserveAspectFit
						sourceSize.width: width * 2
						sourceSize.height: height * 2
					}
				}
				MouseArea {
					id: stopMouseArea
					anchors.fill: parent
					onPressed: {
						stopButton.color = "#EAEAEA"
					}
					onClicked: {
						device.stop()
					}
					onReleased: updateButtons();
				}
			}
		}
	}
	function updateButtons() {
		upButton.color = "#ffffff"
		downButton.color = "#ffffff"
		stopButton.color = "#ffffff"
	}
}
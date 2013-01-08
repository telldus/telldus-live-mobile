import QtQuick 1.1
import Telldus 1.0

Row {
	property bool supportsStop: methods & 512
	Item {
		height: parent.height
		width: supportsStop ? 71 : 109
		BorderImage {
			anchors.fill: parent
			anchors.rightMargin: -2
			border {left: 15; top: 49; right: 0; bottom: 49 }
			source: "buttonBgClickLeft.png"
			opacity: downMouseArea.pressed ? 1 : 0
		}
		Image {
			anchors.centerIn: parent
			source: device.state == 256 ? "buttonActionDownActive.png" : "buttonActionDown.png"
		}
		MouseArea {
			id: downMouseArea
			anchors.fill: parent
			onClicked: device.down()
		}
	}
	Item {
		height: parent.height
		width: childrenRect.width
		Image {
			anchors.verticalCenter: parent.verticalCenter
			source: "buttonDivider.png"
			height: 70
			fillMode: Image.TileVertically
		}
	}
	Item {
		visible: supportsStop ? true : false
		height: parent.height
		width: 71
		Image {
			anchors.fill: parent
			anchors.leftMargin: -2
			anchors.rightMargin: -2
			source: "buttonBgClickMiddle.png"
			opacity: stopMouseArea.pressed ? 1 : 0
			fillMode: Image.TileHorizontally
		}
		Image {
			anchors.centerIn: parent
			source: device.state == 512 ? "buttonActionStopActive.png" : "buttonActionStop.png"
		}
		MouseArea {
			id: stopMouseArea
			anchors.fill: parent
			onClicked: device.stop()
		}
	}
	Item {
		visible: supportsStop ? true : false
		height: parent.height
		width: childrenRect.width
		Image {
			anchors.verticalCenter: parent.verticalCenter
			source: "buttonDivider.png"
			height: 70
			fillMode: Image.TileVertically
		}
	}
	Item {
		height: parent.height
		width: supportsStop ? 71 : 109
		BorderImage {
			anchors.fill: parent
			anchors.leftMargin: -2
			border {left: 0; top: 49; right: 15; bottom: 49 }
			source: "buttonBgClickRight.png"
			opacity: upMouseArea.pressed ? 1 : 0
		}
		Image {
			anchors.centerIn: parent
			source: device.state == 128 ? "buttonActionUpActive.png" : "buttonActionUp.png"
		}
		MouseArea {
			id: upMouseArea
			anchors.fill: parent
			onClicked: device.up()
		}
	}
}

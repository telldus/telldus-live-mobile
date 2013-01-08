import QtQuick 1.1
import Telldus 1.0

Item {
	property bool supportsStop: methods & 512
	Item {
		id: downButton
		height: parent.height
		anchors.left: parent.left
		anchors.right: supportsStop ? stopButton.left : parent.horizontalCenter
		BorderImage {
			anchors.fill: parent
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
		id: stopButton
		visible: supportsStop ? true : false
		height: parent.height
		width: parent.width/3
		anchors.horizontalCenter: parent.horizontalCenter
		Image {
			anchors.fill: parent
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
		id: upButton
		anchors.left: supportsStop ? stopButton.right : downButton.right
		anchors.right: parent.right
		height: parent.height
		BorderImage {
			anchors.fill: parent
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
	Item {
		anchors.left: downButton.right
		anchors.leftMargin: -2
		width: childrenRect.width
		height: parent.height
		Image {
			anchors.verticalCenter: parent.verticalCenter
			source: "buttonDivider.png"
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
			source: "buttonDivider.png"
			height: 70
			fillMode: Image.TileVertically
		}
	}
}

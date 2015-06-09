import QtQuick 2.0
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
}

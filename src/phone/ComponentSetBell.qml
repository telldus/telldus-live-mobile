import QtQuick 1.1
import Telldus 1.0

Item {
	BorderImage {
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		anchors.right: parent.horizontalCenter
		border {left: 15; top: 49; right: 0; bottom: 49 }
		source: "buttonBgClickLeft.png"
		opacity: bellMouseArea.pressed ? 1 : 0
	}
	BorderImage {
		anchors.left: parent.horizontalCenter
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		anchors.right: parent.right
		border {left: 0; top: 49; right: 15; bottom: 49 }
		source: "buttonBgClickRight.png"
		opacity: bellMouseArea.pressed ? 1 : 0
	}
	Image {
		anchors.centerIn: parent
		source: "buttonActionBell.png"
	}
	MouseArea {
		id: bellMouseArea
		anchors.fill: parent
		onClicked: device.bell()
	}
}

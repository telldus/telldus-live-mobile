import QtQuick 2.0
import Telldus 1.0
import ".."

Item {
	id: contentBackground
	width: parent.width
	height: parent.height
	anchors.verticalCenter: parent.verticalCenter
	anchors.horizontalCenter: parent.horizontalCenter
	clip: true
	Item {
		id: contentHeader
		height: deviceName.height + (10 * SCALEFACTOR)
		anchors.left: parent.left
		anchors.bottom: parent.bottom
		anchors.right: parent.right
		Text {
			id: deviceName
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.verticalCenter: parent.verticalCenter
			color: wrapper.color
			font.pixelSize: 12 * SCALEFACTOR
			font.bold: true
			text: dashboardItem.childObject.name
			width: parent.width - (10 * SCALEFACTOR)
			elide: Text.ElideMiddle
			horizontalAlignment: Text.AlignHCenter
			verticalAlignment: Text.AlignVCenter
		}
	}
	Item {
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.right: parent.right
		anchors.bottom: contentHeader.top
		ButtonSet {
			id: buttons
			device: dashboardItem.childObject
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.verticalCenter: parent.verticalCenter
		}

	}
}
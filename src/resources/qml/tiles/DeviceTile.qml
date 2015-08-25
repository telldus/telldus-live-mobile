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
	Rectangle {
		id: contentHeaderBackgroundSquarer
		height: contentHeader.height / 2
		anchors.left: contentHeader.left
		anchors.top: contentHeader.top
		anchors.right: contentHeader.right
		color: contentHeader.color
	}
	Rectangle {
		id: contentHeader
		height: Math.floor(contentBackground.height / 3.5)
		anchors.left: parent.left
		anchors.bottom: parent.bottom
		anchors.right: parent.right
		color: Qt.hsla(0, 0, 0.99, 1)
		radius: tileBorder.radius
		Text {
			id: deviceName
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.verticalCenter: parent.verticalCenter
			color: Qt.hsla(tile.hue, tile.saturation, tile.lightness, 1)
			font.pixelSize: contentBackground.height / 10
			font.bold: true
			text: dashboardItem.childObject.name
			width: parent.width - (10 * SCALEFACTOR)
			elide: Text.ElideMiddle
			horizontalAlignment: Text.AlignHCenter
			verticalAlignment: Text.AlignVCenter
		}
	}
	Rectangle {
		id: contentHeaderSeperator
		height: 1 * SCALEFACTOR
		anchors.left: contentHeader.left
		anchors.top: contentHeaderBackgroundSquarer.top
		anchors.right: contentHeader.right
		color: Qt.hsla(tile.hue, 0.3, 0.7, 1)
	}
	Item {
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.right: parent.right
		anchors.bottom: contentHeader.top
		ButtonSetTile {
			id: buttons
			device: dashboardItem.childObject
			anchors.fill: parent
		}

	}
}
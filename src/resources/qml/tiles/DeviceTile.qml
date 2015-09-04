import QtQuick 2.0
import Telldus 1.0
import Tui 0.1
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
		height: list.tileLabelHeight
		anchors.left: parent.left
		anchors.bottom: parent.bottom
		anchors.right: parent.right
		color: Qt.hsla(tile.hue, tile.saturation, tile.lightness, 1)
		radius: tileCard.radius
		Text {
			id: deviceName
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.verticalCenter: parent.verticalCenter
			color: "#ffffff" //Qt.hsla(tile.hue, tile.saturation, tile.lightness, 1)
			font.pixelSize: contentBackground.height / 9
			text: dashboardItem.childObject.name
			width: parent.width - Units.dp(16)
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
		Item {
			id: buttons

			anchors.fill: parent
			Loader {
				id: loader
				property Device device: dashboardItem.childObject
				property int methods: device.methods
				source: {
					var set =  primarySet()
					if (set == 0) {
						return '../ComponentSetOnOffTile.qml';
					} else if (set == 1) {
						return '../ComponentSetUpDown.qml';
					} else if (set == 2) {
						return '../ComponentSetBell.qml';
					} else if (set == 3) {
						return '../ComponentSetLearn.qml';
					}
					return '';
				}
				anchors.fill: parent
			}
		}
	}
	function primarySet() {
		var methods = dashboardItem.childObject.methods
		if (methods & (128+256)) {
			return 1; // Up and Down
		}
		if (methods & 4) {
			return 2;
		}

		return 0;
	}
}
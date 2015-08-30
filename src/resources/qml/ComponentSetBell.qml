import QtQuick 2.0
import Telldus 1.0

Item {
	Component.onCompleted: {
		tile.showBorder = true;
		tile.hue = 0.08
		tile.saturation = 0.99
		tile.lightness = 0.45
	}
	Image {
		id: bellIcon
		source: "../svgs/deviceIconBell.svg"
		anchors.centerIn: parent
		height: parent.height * 0.6
		width: height
		smooth: true
		fillMode: Image.PreserveAspectFit
		sourceSize.width: width * 2
		sourceSize.height: height * 2
		opacity: 1
	}
	MouseArea {
		id: bellMouseArea
		preventStealing: true
		anchors.fill: parent
		onPressed: {
			bellIcon.opacity = 0.85
			tileWhite.color = Qt.hsla(tile.hue, 0.2, 0.9, 1)
		}
		onReleased: {
			bellIcon.opacity = 1
			tileWhite.color = "#ffffff"
		}
		onClicked: {
			device.bell()
		}
	}
}

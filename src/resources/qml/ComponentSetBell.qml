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
		asynchronous: true
		anchors.centerIn: parent
		height: parent.height * 0.5
		width: height
		smooth: true
		fillMode: Image.PreserveAspectFit
		sourceSize.width: width * 2
		sourceSize.height: height * 2
		opacity: 1
	}
	Rectangle {
		id: progressBarComponent
		visible: device.changesInQueue > 0
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.topMargin: Units.dp(4)
		anchors.leftMargin: Units.dp(4)
		width: Units.dp(8)
		height: width
		radius: width
		color: properties.theme.colors.telldusOrange
	}
	MouseArea {
		id: bellMouseArea
		anchors.fill: parent
		onPressed: {
			bellIcon.opacity = 0.85
			tileCard.tintColor = "#EAEAEA"
		}
		onReleased: {
			bellIcon.opacity = 1
			tileCard.tintColor = "#FAFAFA"
		}
		onClicked: {
			device.bell()
		}
	}
}

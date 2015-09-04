import QtQuick 2.0
import Tui 0.1

Item {
	id: sensorValue
	property string icon
	property alias value: valueText.text
	property alias textColor: valueText.color
	width: sensorIcon.width + Units.dp(8) + valueText.width
	height: Units.dp(40)
	Image {
		id: sensorIcon
		anchors.verticalCenter: parent.verticalCenter
		source: "../svgs/" + icon + ".svg"
		asynchronous: true
		height: Units.dp(28)
		width: Units.dp(28)
		smooth: true
		fillMode: Image.PreserveAspectFit
		sourceSize.width: width * 2
		sourceSize.height: height * 2
	}
	Text {
		id: valueText
		anchors.left: sensorIcon.right
		anchors.leftMargin: Units.dp(8)
		anchors.verticalCenter: parent.verticalCenter
		color: properties.theme.colors.telldusBlue
		font.pixelSize: Units.dp(16)
	}
}

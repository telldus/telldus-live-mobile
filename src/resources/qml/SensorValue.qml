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
		height: screen.width <=360 ? Units.dp(20) : Units.dp(32)
		width: height
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
		font.pixelSize: screen.width <=360 ? Units.dp(12) : Units.dp(16)
	}
}

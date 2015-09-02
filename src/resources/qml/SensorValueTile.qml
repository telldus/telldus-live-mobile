import QtQuick 2.0

Item {
	id: sensorValue
	property string icon
	property alias value: valueText.text
	property alias textColor: valueText.color
	property real textSizeScaleFactor: 1
	anchors.fill: parent
	Item {
		id: splitLeft
		width: parent.width * 0.4
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		Image {
			id: sensorIcon
			source: "../svgs/" + icon + ".svg"
			asynchronous: true
			width: splitLeft.width * 0.8
			height: splitLeft.height * 0.9
			anchors.centerIn: parent
			smooth: true
			fillMode: Image.PreserveAspectFit
			sourceSize.width: width * 2
			sourceSize.height: height * 2
		}
	}
	Item {
		id: splitRight
		anchors.left: splitLeft.right
		anchors.top: parent.top
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		Text {
			id: valueText
			anchors.centerIn: parent
			color: properties.theme.colors.telldusBlue
			font.pixelSize: sensorValue.height * 0.2 * textSizeScaleFactor
			font.weight: Font.Bold
		}
	}
}

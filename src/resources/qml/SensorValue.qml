import QtQuick 2.0

Item {
	id: sensorValue
	property string icon
	property alias value: valueText.text
	property alias textColor: valueText.color
	width: sensorIcon.width + (5 * SCALEFACTOR) + valueText.width
	height: Math.max(sensorIcon.height, valueText.height)
	Image {
		id: sensorIcon
		source: "../svgs/" + icon + ".svg"
		height: 20 * SCALEFACTOR
		width: 20 * SCALEFACTOR
		smooth: true
		fillMode: Image.PreserveAspectFit
		sourceSize.width: width * 2
		sourceSize.height: height * 2
	}
	Text {
		id: valueText
		anchors.left: sensorIcon.right
		anchors.leftMargin: 5 * SCALEFACTOR
		anchors.verticalCenter: parent.verticalCenter
		color: properties.theme.colors.telldusBlue
		font.pixelSize: 12 * SCALEFACTOR
		font.weight: Font.Bold
		//text: 'sensor.temperature' + '\u00B0C'
	}
}

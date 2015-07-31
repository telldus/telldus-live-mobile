import QtQuick 2.0

Item {
	id: sensorValue
	property string icon
	property alias value: valueText.text
	width: sensorIcon.width + (5 * SCALEFACTOR) + valueText.width
	height: Math.max(sensorIcon.height, valueText.height)
	Image {
		id: sensorIcon
		source: "../images/" + icon + ".png"
		height: 20 * SCALEFACTOR
		width: 20 * SCALEFACTOR
	}
	Text {
		id: valueText
		anchors.left: sensorIcon.right
		anchors.leftMargin: 5 * SCALEFACTOR
		anchors.verticalCenter: parent.verticalCenter
		color: '#00659F'
		font.pixelSize: 12 * SCALEFACTOR
		font.weight: Font.Bold
		//text: 'sensor.temperature' + '\u00B0C'
	}
}

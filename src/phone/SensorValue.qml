import QtQuick 2.0

Item {
	id: sensorValue
	property string icon
	property alias value: valueText.text
	width: childrenRect.width
	height: sensorIcon.height
	Image {
		id: sensorIcon
		source: icon + ".png"
		height: sourceSize.height*SCALEFACTOR
		width: sourceSize.width*SCALEFACTOR
	}
	Text {
		id: valueText
		anchors.left: sensorIcon.right
		anchors.leftMargin: 10
		anchors.verticalCenter: parent.verticalCenter
		color: '#00659F'
		font.pixelSize: 28*SCALEFACTOR
		font.weight: Font.Bold
		//text: 'sensor.temperature' + '\u00B0C'
	}
}

import QtQuick 2.0
import Telldus 1.0
import ".."

Item {
	id: contentBackground
	property Sensor sensor: dashboardItem.childObject

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
		color: Qt.hsla(0.6, 0.55, 0.24, 1)
		radius: tileWhite.radius
		Text {
			id: deviceName
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.verticalCenter: parent.verticalCenter
			color:  sensor.name !== '' ? '#ffffff' : '#80ffffff'
			font.pixelSize: contentBackground.height / 10
			font.bold: true
			text: sensor.name !== '' ? sensor.name : '(no name)'
			width: parent.width - (10 * SCALEFACTOR)
			elide: Text.ElideMiddle
			horizontalAlignment: Text.AlignHCenter
			verticalAlignment: Text.AlignVCenter
		}
	}
		Flow {
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.right: parent.right
		anchors.bottom: contentHeader.top
		anchors.margins: 10
		SensorValue {
			icon: "sensorIconHumidity"
			visible: sensor.hasHumidity
			value: Number(sensor.humidity).toLocaleString(Qt.locale("en_GB"), 'f', 0) + '%'
			textColor: Qt.hsla(0.6, 0.55, 0.24, 1)
		}
		SensorValue {
			icon: "sensorIconTemperature"
			visible: sensor.hasTemperature
			value: Number(sensor.temperature).toLocaleString(Qt.locale("en_GB"), 'f', 1) + '\u00B0C'
			textColor: Qt.hsla(0.6, 0.55, 0.24, 1)
		}
		SensorValue {
			icon: "sensorIconRain"
			visible: sensor.hasRainRate
			value: Number(sensor.rainRate).toLocaleString(Qt.locale("en_GB"), 'f', 0) + ' mm/h\n' + Number(sensor.rainTotal).toLocaleString(Qt.locale("en_GB"), 'f', 0) + ' mm'
			textColor: Qt.hsla(0.6, 0.55, 0.24, 1)
		}
		SensorValue {
			icon: "sensorIconWind"
			visible: sensor.hasWindGust
			value: Number(sensor.windAvg).toLocaleString(Qt.locale("en_GB"), 'f', 1) + ' m/s\n' + Number(sensor.windGust).toLocaleString(Qt.locale("en_GB"), 'f', 1) + ' m/s*\n' + Number(sensor.windDir).toLocaleString(Qt.locale("en_GB"), 'f', 0) + '\u00B0'
			textColor: Qt.hsla(0.6, 0.55, 0.24, 1)
		}
		SensorValue {
			icon: "sensorIconUv"
			visible: sensor.hasUv
			value: Number(sensor.uv).toLocaleString(Qt.locale("en_GB"), 'f', 0)
			textColor: Qt.hsla(0.6, 0.55, 0.24, 1)
		}
		SensorValue {
			icon: "sensorIconWatt"
			visible: sensor.hasWatt
			value: Number(sensor.watt).toLocaleString(Qt.locale("en_GB"), 'f', 1) + ' W'
			textColor: Qt.hsla(0.6, 0.55, 0.24, 1)
		}
		SensorValue {
			icon: "sensorIconLuminance"
			visible: sensor.hasLuminance
			value: Number(sensor.luminance).toLocaleString(Qt.locale("en_GB"), 'f', 0) + ' lx'
			textColor: Qt.hsla(0.6, 0.55, 0.24, 1)
		}
	}
}
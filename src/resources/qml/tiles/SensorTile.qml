import QtQuick 2.0
import Telldus 1.0
import ".."

Item {
	property Sensor sensor: dashboardItem.childObject

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
			textColor: wrapper.color
		}
		SensorValue {
			icon: "sensorIconTemperature"
			visible: sensor.hasTemperature
			value: Number(sensor.temperature).toLocaleString(Qt.locale("en_GB"), 'f', 1) + '\u00B0C'
			textColor: wrapper.color
		}
		SensorValue {
			icon: "sensorIconRain"
			visible: sensor.hasRainRate
			value: Number(sensor.rainRate).toLocaleString(Qt.locale("en_GB"), 'f', 0) + ' mm/h\n' + Number(sensor.rainTotal).toLocaleString(Qt.locale("en_GB"), 'f', 0) + ' mm'
			textColor: wrapper.color
		}
		SensorValue {
			icon: "sensorIconWind"
			visible: sensor.hasWindGust
			value: Number(sensor.windAvg).toLocaleString(Qt.locale("en_GB"), 'f', 1) + ' m/s\n' + Number(sensor.windGust).toLocaleString(Qt.locale("en_GB"), 'f', 1) + ' m/s*\n' + Number(sensor.windDir).toLocaleString(Qt.locale("en_GB"), 'f', 0) + '\u00B0'
			textColor: wrapper.color
		}
		SensorValue {
			icon: "sensorIconUv"
			visible: sensor.hasUv
			value: Number(sensor.uv).toLocaleString(Qt.locale("en_GB"), 'f', 0)
			textColor: wrapper.color
		}
		SensorValue {
			icon: "sensorIconWatt"
			visible: sensor.hasWatt
			value: Number(sensor.watt).toLocaleString(Qt.locale("en_GB"), 'f', 1) + ' W'
			textColor: wrapper.color
		}
		SensorValue {
			icon: "sensorIconLuminance"
			visible: sensor.hasLuminance
			value: Number(sensor.luminance).toLocaleString(Qt.locale("en_GB"), 'f', 0) + ' lx'
			textColor: wrapper.color
		}
	}
	Item {
		id: contentHeader
		height: sensorName.height + (10 * SCALEFACTOR)
		anchors.left: parent.left
		anchors.bottom: parent.bottom
		anchors.right: parent.right
		Text {
			id: sensorName
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.verticalCenter: parent.verticalCenter
			color: wrapper.color
			font.pixelSize: 12 * SCALEFACTOR
			font.bold: true
			text: sensor.name
			width: parent.width - (10 * SCALEFACTOR)
			elide: Text.ElideMiddle
			horizontalAlignment: Text.AlignHCenter
			verticalAlignment: Text.AlignVCenter
		}
	}
}
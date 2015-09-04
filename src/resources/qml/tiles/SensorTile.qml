import QtQuick 2.0
import Telldus 1.0
import Tui 0.1
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
		radius: tileCard.radius
		Text {
			id: deviceName
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.verticalCenter: parent.verticalCenter
			color:  sensor.name !== '' ? '#ffffff' : '#80ffffff'
			font.pixelSize: contentBackground.height / 9
			text: sensor.name !== '' ? sensor.name : '(no name)'
			width: parent.width - Units.dp(16)
			elide: Text.ElideMiddle
			horizontalAlignment: Text.AlignHCenter
			verticalAlignment: Text.AlignVCenter
		}
	}
	Item {
		id: sensorScreens
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.right: parent.right
		anchors.bottom: contentHeader.top
		anchors.margins: 10

		property bool allowFade: false
		property var tileScreens: []
		property int currentTileScreen: 0

		Component.onCompleted: {
			if (sensor.hasHumidity) {
				tileScreens.push('sensorIconHumidity');
			}
			if (sensor.hasTemperature) {
				tileScreens.push('sensorIconTemperature');
			}
			if (sensor.hasRainRate) {
				tileScreens.push('sensorIconRain');
			}
			if (sensor.hasWindGust) {
				tileScreens.push('sensorIconWind');
			}
			if (sensor.hasUv) {
				tileScreens.push('sensorIconUv');
			}
			if (sensor.hasWatt) {
				tileScreens.push('sensorIconWatt');
			}
			if (sensor.hasLuminance) {
				tileScreens.push('sensorIconLuminance');
			}
			eval(tileScreens[0] + ".opacity = 1");
		}

		SensorValueTile {
			id: sensorIconHumidity
			icon: "sensorIconHumidity"
			visible: sensor.hasHumidity
			value: Number(sensor.humidity).toLocaleString(Qt.locale("en_GB"), 'f', 0) + '%'
			textColor: Qt.hsla(0.6, 0.55, 0.24, 1)
			textSizeScaleFactor: 1.2
			opacity: 0

			Behavior on opacity {
				enabled: sensorScreens.allowFade
				NumberAnimation { easing.type: Easing.InOutQuad; duration: 500 }
			}
		}
		SensorValueTile {
			id: sensorIconTemperature
			icon: "sensorIconTemperature"
			visible: sensor.hasTemperature
			value: Number(sensor.temperature).toLocaleString(Qt.locale("en_GB"), 'f', 1) + '\u00B0C'
			textColor: Qt.hsla(0.6, 0.55, 0.24, 1)
			textSizeScaleFactor: 1.2
			opacity: 0

			Behavior on opacity {
				enabled: sensorScreens.allowFade
				NumberAnimation { easing.type: Easing.InOutQuad; duration: 500 }
			}
		}
		SensorValueTile {
			id: sensorIconRain
			icon: "sensorIconRain"
			visible: sensor.hasRainRate
			value: Number(sensor.rainRate).toLocaleString(Qt.locale("en_GB"), 'f', 0) + ' mm/h\n' + Number(sensor.rainTotal).toLocaleString(Qt.locale("en_GB"), 'f', 0) + ' mm'
			textColor: Qt.hsla(0.6, 0.55, 0.24, 1)
			textSizeScaleFactor: 0.9
			opacity: 0

			Behavior on opacity {
				enabled: sensorScreens.allowFade
				NumberAnimation { easing.type: Easing.InOutQuad; duration: 500 }
			}
		}
		SensorValueTile {
			id: sensorIconWind
			icon: "sensorIconWind"
			visible: sensor.hasWindGust
			value: Number(sensor.windAvg).toLocaleString(Qt.locale("en_GB"), 'f', 1) + ' m/s\n' + Number(sensor.windGust).toLocaleString(Qt.locale("en_GB"), 'f', 1) + ' m/s*\n' + Number(sensor.windDir).toLocaleString(Qt.locale("en_GB"), 'f', 0) + '\u00B0'
			textColor: Qt.hsla(0.6, 0.55, 0.24, 1)
			textSizeScaleFactor: 0.8
			opacity: 0

			Behavior on opacity {
				enabled: sensorScreens.allowFade
				NumberAnimation { easing.type: Easing.InOutQuad; duration: 500 }
			}
		}
		SensorValueTile {
			id: sensorIconUv
			icon: "sensorIconUv"
			visible: sensor.hasUv
			value: Number(sensor.uv).toLocaleString(Qt.locale("en_GB"), 'f', 0)
			textColor: Qt.hsla(0.6, 0.55, 0.24, 1)
			textSizeScaleFactor: 2.3
			opacity: 0

			Behavior on opacity {
				enabled: sensorScreens.allowFade
				NumberAnimation { easing.type: Easing.InOutQuad; duration: 500 }
			}
		}
		SensorValueTile {
			id: sensorIconWatt
			icon: "sensorIconWatt"
			visible: sensor.hasWatt
			value: Number(sensor.watt).toLocaleString(Qt.locale("en_GB"), 'f', 1) + ' W'
			textColor: Qt.hsla(0.6, 0.55, 0.24, 1)
			textSizeScaleFactor: 1.2
			opacity: 0

			Behavior on opacity {
				enabled: sensorScreens.allowFade
				NumberAnimation { easing.type: Easing.InOutQuad; duration: 500 }
			}
		}
		SensorValueTile {
			id: sensorIconLuminance
			icon: "sensorIconLuminance"
			visible: sensor.hasLuminance
			value: Number(sensor.luminance).toLocaleString(Qt.locale("en_GB"), 'f', 0) + ' lx'
			textColor: Qt.hsla(0.6, 0.55, 0.24, 1)
			textSizeScaleFactor: 1.2
			opacity: 0

			Behavior on opacity {
				enabled: sensorScreens.allowFade
				NumberAnimation { easing.type: Easing.InOutQuad; duration: 500 }
			}
		}
	}

	function switchTileSlides() {
		if (sensorScreens.tileScreens.length > 1) {
			sensorScreens.allowFade = true;
			eval(sensorScreens.tileScreens[sensorScreens.currentTileScreen] + ".opacity = 0");
			sensorScreens.currentTileScreen ++;
			if (sensorScreens.currentTileScreen == sensorScreens.tileScreens.length) {
				sensorScreens.currentTileScreen = 0;
			}
			eval(sensorScreens.tileScreens[sensorScreens.currentTileScreen] + ".opacity = 1");
			sensorScreens.allowFade = false;
		}
	}
}
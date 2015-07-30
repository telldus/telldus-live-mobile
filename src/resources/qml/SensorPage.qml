import QtQuick 2.4
import Telldus 1.0

Item {
	id: sensorPage

	Component {
		id: sensorDelegate
		Item {
			id: wrapper
			width: list.width
			z: model.index
			height: Math.max(dataTitleRow.height, dataRow.height) + (20 * SCALEFACTOR)
			Text {
				id: sensorName
				font.weight: Font.Bold
				text: sensor.name !== '' ? sensor.name : '(no name)'
				visible: false
			}
			Text {
				id: sensorLastUpdated
				font.pixelSize: 10 * SCALEFACTOR
				text: formatLastUpdated(sensor.minutesAgo)
				visible: false
			}
			BorderImage {
				id: border
				source: "../images/rowBg.png"
				anchors.right: parent.right
				anchors.left: parent.left
				anchors.leftMargin: 10 * SCALEFACTOR
				anchors.rightMargin: 10 * SCALEFACTOR
				border { left: 21; top: 21; right: 21; bottom: 28 }
				height: wrapper.height

				Column {
					id: dataTitleRow
					anchors.left: parent.left
					anchors.leftMargin: 10 * SCALEFACTOR
					anchors.top: parent.top
					anchors.topMargin: 10 * SCALEFACTOR
					height: sensorNameText.height + sensorLastUpdatedText.height
					width: Math.min(Math.max(sensorName.width, sensorLastUpdated.width), (list.width/2)-50)
					Text {
						id: sensorNameText
						color: sensor.name !== '' ? '#00659F' : '#8cabc5'
						font.weight: Font.Bold
						text: sensor.name !== '' ? sensor.name : '(no name)'
						elide: Text.ElideRight
						width: parent.width
						font.pixelSize: 16 * SCALEFACTOR
					}
					//Text {
					//	color: "#999999"
					//	font.pixelSize: 28*SCALEFACTOR
					//	text: ""  // TODO(micke): Add location name
					//}
					Text {
						id: sensorLastUpdatedText
						color: "#999999"  // TODO(micke): Red color if minutesAgo > some large number
						font.pixelSize: 12 * SCALEFACTOR
						text: formatLastUpdated(sensor.minutesAgo)
						width: parent.width
					}
				}
				Flow {
						id: dataRow
						layoutDirection: Qt.RightToLeft
						anchors.left: dataTitleRow.right
						anchors.leftMargin: 10 * SCALEFACTOR
						anchors.right: parent.right
						anchors.rightMargin: 10 * SCALEFACTOR
						anchors.verticalCenter: parent.verticalCenter
						spacing: 10 * SCALEFACTOR
						SensorValue {
							icon: "sensorIconHumidity"
							visible: sensor.hasHumidity
							value: sensor.humidity + '%'
						}
						SensorValue {
							icon: "sensorIconTemperature"
							visible: sensor.hasTemperature
							value: sensor.temperature + '\u00B0C'
						}
						SensorValue {
							icon: "sensorIconRain"
							visible: sensor.hasRainRate
							value: sensor.rainRate + ' mm/h\n' + sensor.rainTotal + ' mm'
						}
						SensorValue {
							icon: "sensorIconWind"
							visible: sensor.hasWindGust
							value: sensor.windAvg + ' m/s\n' + sensor.windGust + ' m/s*\n' + sensor.windDir + '\u00B0'
						}
						SensorValue {
							icon: "sensorIconUv"
							visible: sensor.hasUv
							value: sensor.uv
						}
						SensorValue {
							icon: "sensorIconWatt"
							visible: sensor.hasWatt
							value: sensor.watt + ' W'
						}
						SensorValue {
							icon: "sensorIconLuminance"
							visible: sensor.hasLuminance
							value: sensor.luminance + ' lx'
						}
				}
			}
		}
	}

	SwipeArea {
		anchors.fill: list
		filterTouchEvent: true
		filterMouseEvent: false
		onSwipeLeft: mainInterface.swipeLeft()
		onSwipeRight: mainInterface.swipeRight()
	}
	ListView {
		id: list
		header: Item {
			height: header.height + (10 * SCALEFACTOR)
			width: parent.width
		}
		footer: Item {
			height: 10 * SCALEFACTOR
			width: parent.width
		}

		anchors.fill: parent
		model: sensorModel
		delegate: sensorDelegate
		spacing: 5 * SCALEFACTOR
	}

	Header {
		id: header
		anchors.topMargin: Math.min(0, -list.contentY-header.height-10)
	}

	function formatLastUpdated(minutes) {
		if (minutes === 0) {
			return 'Just now'
		}
		if (minutes === 1) {
			return '1 minute ago'
		}
		if (minutes < 60) {
			return minutes + ' minutes ago'
		}
		var hours = Math.round(minutes / 60);
		if (hours === 1) {
			return '1 hour ago'
		}
		if (hours < 24) {
			return hours + ' hours ago';
		}
		var days = Math.round(minutes / 60 / 24);
		if (days == 1) {
			return '1 day ago';
		}
		return days + ' days ago';
	}
}

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
			BorderImage {
				id: border
				source: "../images/rowBg.png"
				anchors.top: parent.top
				anchors.left: parent.left
				anchors.leftMargin: 10 * SCALEFACTOR
				anchors.rightMargin: 10 * SCALEFACTOR
				height: wrapper.height / SCALEFACTOR * 2
				width: (wrapper.width / SCALEFACTOR * 2) - 40
				border {left: 21; top: 21; right: 21; bottom: 28 }
				scale: SCALEFACTOR / 2
				transformOrigin: Item.TopLeft
			}
			Column {
				id: dataTitleRow
				anchors.left: parent.left
				anchors.leftMargin: 20 * SCALEFACTOR
				anchors.top: parent.top
				anchors.topMargin: 10 * SCALEFACTOR
				height: sensorNameText.height + sensorLastUpdatedText.height
				width: (wrapper.width / 2) - (50 * SCALEFACTOR)
				Text {
					id: sensorNameText
					color: sensor.name !== '' ? '#00659F' : '#8cabc5'
					font.weight: Font.Bold
					text: sensor.name !== '' ? sensor.name : '(no name)'
					width: parent.width
					font.pixelSize: 16 * SCALEFACTOR
					wrapMode: Text.Wrap
					elide: Text.ElideRight
					maximumLineCount: 3
				}
				//Text {
				//	color: "#999999"
				//	font.pixelSize: 28*SCALEFACTOR
				//	text: ""  // TODO(micke): Add location name
				//}
				Text {
					id: sensorLastUpdatedText
					color: sensor.minutesAgo < 1440 ? "#999999" : "#80990000"
					font.pixelSize: 12 * SCALEFACTOR
					text: formatLastUpdated(sensor.minutesAgo)
					wrapMode: Text.Wrap
					elide: Text.ElideRight
					maximumLineCount: 3
				}
			}
			Flow {
				id: dataRow
				layoutDirection: Qt.RightToLeft
				anchors.left: dataTitleRow.right
				anchors.leftMargin: 10 * SCALEFACTOR
				anchors.right: parent.right
				anchors.rightMargin: 20 * SCALEFACTOR
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
			height: header.height + (15 * SCALEFACTOR)
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
		maximumFlickVelocity: 1500 * SCALEFACTOR
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

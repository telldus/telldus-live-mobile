import QtQuick 2.4
import Telldus 1.0

Item {
	id: sensorPage
	property bool showEditButtons: false

	Component {
		id: sensorDelegate
		Rectangle {
			color: "#eeeeee"
			height: wrapper.height + 1
			width: parent.width
			Rectangle {
				id: wrapper
				width: sensorPage.width
				z: model.index
				height: childrenRect.height + (20 * SCALEFACTOR)
	//			color: index % 2 == 0 ? "#eaeaea" : "#ffffff"
				color: "#ffffff"
				state: showEditButtons ? 'showEditButtons' : ''
				anchors.left: parent.left
				anchors.leftMargin: 0
				anchors.top: parent.top
				Column {
					id: dataTitleRow
					anchors.left: parent.left
					anchors.leftMargin: 10 * SCALEFACTOR
					anchors.top: parent.top
					anchors.topMargin: 10 * SCALEFACTOR
					width: (list.width - 30) / 2
					Text {
						id: sensorName
						color: properties.theme.colors.telldusBlue
						opacity: sensor.name !== '' ? 1 : 0.5
						font.weight: Font.Bold
						text: sensor.name !== '' ? sensor.name : '(no name)'
						font.pixelSize: 14 * SCALEFACTOR
						width: parent.width
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
						id: sensorUpdated
						color: "#999999"  // TODO(micke): Red color if minutesAgo > some large number
						font.pixelSize: 12 * SCALEFACTOR
						text: formatLastUpdated(sensor.minutesAgo)
						wrapMode: Text.Wrap
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
					anchors.top: parent.top
					anchors.topMargin: 10 * SCALEFACTOR
					spacing: 10 * SCALEFACTOR
					SensorValue {
						icon: "sensorIconHumidity"
						visible: sensor.hasHumidity
						value: Number(sensor.humidity).toLocaleString(Qt.locale("en_GB"), 'f', 0) + '%'
					}
					SensorValue {
						icon: "sensorIconTemperature"
						visible: sensor.hasTemperature
						value: Number(sensor.temperature).toLocaleString(Qt.locale("en_GB"), 'f', 1) + '\u00B0C'
					}
					SensorValue {
						icon: "sensorIconRain"
						visible: sensor.hasRainRate
						value: Number(sensor.rainRate).toLocaleString(Qt.locale("en_GB"), 'f', 0) + ' mm/h\n' + Number(sensor.rainTotal).toLocaleString(Qt.locale("en_GB"), 'f', 0) + ' mm'
					}
					SensorValue {
						icon: "sensorIconWind"
						visible: sensor.hasWindGust
						value: Number(sensor.windAvg).toLocaleString(Qt.locale("en_GB"), 'f', 1) + ' m/s\n' + Number(sensor.windGust).toLocaleString(Qt.locale("en_GB"), 'f', 1) + ' m/s*\n' + Number(sensor.windDir).toLocaleString(Qt.locale("en_GB"), 'f', 0) + '\u00B0'
					}
					SensorValue {
						icon: "sensorIconUv"
						visible: sensor.hasUv
						value: Number(sensor.uv).toLocaleString(Qt.locale("en_GB"), 'f', 0)
					}
					SensorValue {
						icon: "sensorIconWatt"
						visible: sensor.hasWatt
						value: Number(sensor.watt).toLocaleString(Qt.locale("en_GB"), 'f', 1) + ' W'
					}
					SensorValue {
						icon: "sensorIconLuminance"
						visible: sensor.hasLuminance
						value: Number(sensor.luminance).toLocaleString(Qt.locale("en_GB"), 'f', 0) + ' lx'
					}
				}
				/*MouseArea {
					anchors.fill: parent
					enabled: showEditButtons
					onClicked: {
						devicePage.showEditButtons = false
					}
				}*/
				states: [
					State {
						name: 'showEditButtons'
						PropertyChanges { target: wrapper; anchors.leftMargin: 50 * SCALEFACTOR * underMenu.children.length }
					}
				]
				transitions: [
					Transition {
						to: 'showEditButtons'
						reversible: true
						PropertyAnimation { property: "anchors.leftMargin";  duration: 300; easing.type: Easing.InOutQuad }
					}
				]
			}
			Rectangle {
				id: underMenu
				anchors.right: wrapper.left
				anchors.top: parent.top
				anchors.left: parent.left
				anchors.bottom: parent.bottom
				color: "#f8f8f8"
				clip: true
				Item {
					id: editButton1
					height: parent.height
					width: 50 * SCALEFACTOR
					anchors.left: parent.left
					anchors.top: parent.top
					Image {
						anchors.centerIn: parent
						source: sensor.isFavorite ? "../images/iconFavouriteActive.png" : "../images/iconFavourite.png"
						height: 30 * SCALEFACTOR
						width: 30 * SCALEFACTOR
						smooth: true
					}
					MouseArea {
						anchors.fill: parent
						onClicked: sensor.isFavorite = !sensor.isFavorite
					}
				}
			}
		}
	}
	ListView {
		id: list
		anchors.fill: parent
		anchors.topMargin: screen.isPortrait ? header.height : 0
		anchors.leftMargin: screen.isPortrait ? 0 : header.width
		model: sensorModel
		delegate: sensorDelegate
		maximumFlickVelocity: 1500 * SCALEFACTOR
		spacing: 0
	}
	Header {
		id: header
		title: "Sensors"
		editButtonVisible: true
		onEditClicked: showEditButtons = !showEditButtons;
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

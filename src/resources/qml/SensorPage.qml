import QtGraphicalEffects 1.0
import QtQuick 2.4
import Telldus 1.0
import Tui 0.1

Item {
	id: sensorPage
	property bool showEditButtons: false

	Component {
		id: sensorDelegate
		Rectangle {
			color: "#EEEEEE"
			height: wrapper.height
			width: list.width
			Rectangle {
				id: wrapper
				width: list.width
				z: model.index
				height: Units.dp(72)
				color: "#ffffff"
				state: showEditButtons ? 'showEditButtons' : ''
				anchors.left: parent.left
				anchors.leftMargin: 0
				anchors.top: parent.top
				Rectangle {
					id: divider
					anchors.left: parent.left
					anchors.right: parent.right
					anchors.bottom: parent.bottom
					height: Units.dp(1)
					color: "#F5F5F5"
				}
				Column {
					id: dataTitleRow
					anchors.left: parent.left
					anchors.leftMargin: Units.dp(16)
					anchors.verticalCenter: parent.verticalCenter
					width: (list.width - 30) / 2
					Text {
						id: sensorName
						color: properties.theme.colors.telldusBlue
						opacity: sensor.name !== '' ? 1 : 0.5
						text: sensor.name !== '' ? sensor.name : '(no name)'
						font.pixelSize: Units.dp(16)
						width: parent.width
						wrapMode: Text.Wrap
						elide: Text.ElideRight
						maximumLineCount: 3
					}
					Text {
						id: sensorUpdated
						color: sensor.minutesAgo < 1440 ? "#999999" : "#80990000"
						font.pixelSize: Units.dp(14)
						text: formatLastUpdated(sensor.minutesAgo)
						wrapMode: Text.Wrap
						width: parent.width
					}
				}
				Row {
					id: dataRow
					layoutDirection: Qt.RightToLeft
					anchors.left: dataTitleRow.right
					anchors.leftMargin: Units.dp(16)
					anchors.right: parent.right
					anchors.rightMargin: Units.dp(16)
					anchors.verticalCenter: parent.verticalCenter
					spacing: Units.dp(16)
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
						PropertyChanges { target: wrapper; anchors.leftMargin: (50 * SCALEFACTOR) * (underMenu.children.length-1) }
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
					id: favouriteButton
					height: parent.height
					width: 50 * SCALEFACTOR
					anchors.left: parent.left
					anchors.top: parent.top
					Image {
						id: favouriteButtonImage
						anchors.centerIn: parent
						height: 30 * SCALEFACTOR
						width: height
						source: "image://icons/favourite/" + properties.theme.colors.telldusOrange
						asynchronous: true
						smooth: true
						fillMode: Image.PreserveAspectFit
						sourceSize.width: width * 2
						sourceSize.height: height * 2
						opacity: sensor.isFavorite ? 1 : 0.2
					}
					MouseArea {
						anchors.fill: parent
						onClicked: sensor.isFavorite = !sensor.isFavorite
					}
				}
				LinearGradient {
					anchors.top: parent.top
					anchors.right: parent.right
					anchors.bottom: parent.bottom
					width: 3 * SCALEFACTOR
					start: Qt.point(0, 0)
					end: Qt.point(3 * SCALEFACTOR, 0)
					gradient: Gradient {
						GradientStop { position: 0.0; color: "#00999999" }
						GradientStop { position: 1.0; color: "#80999999" }
					}
				}
			}
		}
	}
	Rectangle {
		id: listPage
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		anchors.right: parent.right
		width: parent.width
		color: "#80999999"
		ListView {
			id: list
			anchors.fill: parent
			anchors.topMargin: screen.showHeaderAtTop ? header.height : 0
			anchors.leftMargin: screen.showHeaderAtTop ? 0 : header.width
			model: sensorModel
			delegate: sensorDelegate
			maximumFlickVelocity: Units.dp(1500)
		}
		Header {
			id: header
			title: "Sensors"
			editButtonVisible: true
			onEditClicked: showEditButtons = !showEditButtons;
		}
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

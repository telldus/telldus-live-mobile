import QtGraphicalEffects 1.0
import QtQuick 2.4
import Telldus 1.0
import Tui 0.1

Item {
	id: sensorPage
	property bool showEditButtons: false

	Component {
		id: sensorDelegate
		FocusScope {
			height: wrapper.height
			width: list.width
			Keys.onPressed: {
				if (properties.ui.supportsKeys) {
					if (event.key == Qt.Key_Enter) {
						sensor.isFavorite = !sensor.isFavorite
						event.accepted = true;
					}
					if (event.key == Qt.Key_MediaPlay) {
						showEditButtons = !showEditButtons
						event.accepted = true;
					}
				}
			}
			Rectangle {
				color: "#EEEEEE"
				height: parent.height
				width: parent.width
				Rectangle {
					id: wrapper
					width: list.width
					z: model.index
					height: Units.dp(72)
					color: index ==  list.currentIndex && properties.ui.supportsKeys ? "#f5f5f5" : "#ffffff"
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
							font.pixelSize: Units.dp(12)
							text: "Last update: " + formatLastUpdated(sensor.minutesAgo, sensor.lastUpdated)
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
						width: Units.dp(48)
						anchors.left: parent.left
						anchors.top: parent.top
						Image {
							id: favouriteButtonImage
							anchors.centerIn: parent
							height: Units.dp(30)
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
	}
	Component {
		id: sensorListHeader
		Item {
			height: Units.dp(60)
			width: parent.width
			y: -list.contentY - height

			property bool refresh: state == "pulled" ? true : false

			Item {
				id: arrow
				anchors.fill: parent
				Image {
					id: arrowImage
					visible: !refreshTimer.running
					anchors.centerIn: parent
					height: parent.height * 0.5
					width: height
					source: "image://icons/refreshArrow/#999999"
					asynchronous: true
					smooth: true
					fillMode: Image.PreserveAspectFit
					sourceSize.width: width * 2
					sourceSize.height: height * 2
				}
				Image {
					id: arrowImageRunning
					visible: closeTimer.running
					anchors.centerIn: parent
					height: parent.height * 0.5
					width: height
					source: "image://icons/refresh/#999999"
					asynchronous: true
					smooth: true
					fillMode: Image.PreserveAspectFit
					sourceSize.width: width * 2
					sourceSize.height: height * 2
					transformOrigin: Item.Center
					RotationAnimation on rotation {
						loops: Animation.Infinite
						from: 0
						to: 360
						duration: 1000
						running: closeTimer.running
					}
				}
				transformOrigin: Item.Center
				Behavior on rotation { NumberAnimation { duration: 200 } }
			}
			Text {
				anchors.centerIn: parent
				visible: refreshTimer.running && !closeTimer.running
				color: properties.theme.colors.telldusBlue
				font.pixelSize: Units.dp(12)
				text: "You can refresh once every 10 seconds."
				elide: Text.ElideRight
			}
			states: [
				State {
					name: "base"; when: list.contentY >= -Units.dp(140)
					PropertyChanges { target: arrow; rotation: 180 }
				},
				State {
					name: "pulled"; when: list.contentY < -Units.dp(140)
					PropertyChanges { target: arrow; rotation: 0 }
				}
			]
		}
	}
	Component {
		id: sensorListSectionHeader
		Rectangle {
			width: parent.width
			height: Units.dp(28)
			color: "#dddddd"

			Rectangle {
				anchors.fill: parent
				anchors.topMargin: Units.dp(1)
				anchors.bottomMargin: Units.dp(1)
				color: "#f5f5f5"

				Text {
					anchors.verticalCenter: parent.verticalCenter
					anchors.left: parent.left
					anchors.leftMargin: Units.dp(20)
					//anchors.left: parent.left
					//anchors.leftMargin: Units.dp(10)
					text: section
					font.bold: true
					font.pixelSize: Units.dp(14)
					color: "#999999"
				}

			}
		}
	}
	Rectangle {
		id: listEmptyView
		anchors.fill: parent
		visible : sensorModel.count == 0
		color: "#F5F5F5"
		onVisibleChanged: {
			if (sensorModel.count == 0) {
				refreshTimer.stop()
				closeTimer.stop()
			}
		}

		Text {
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.verticalCenter: parent.verticalCenter
			anchors.leftMargin: Units.dp(20)
			anchors.rightMargin:Units.dp(20)
			color: properties.theme.colors.telldusBlue
			font.pixelSize: Units.dp(16)
			wrapMode: Text.Wrap
			horizontalAlignment: Text.AlignHCenter
			text: refreshTimer.running ? "Refreshing...\n\nyou can only refresh once every 10 seconds!" : "No sensors have been detected.\n\nTap here to refresh!"
		}
		MouseArea {
			anchors.fill: parent
			enabled: listEmptyView.visible && !refreshTimer.running
			onReleased: {
				refreshTimer.start();
				sensorModel.authorizationChanged();
			}
		}
	}
	Item {
		id: listPage
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		anchors.right: parent.right
		width: parent.width
		visible : sensorModel.count > 0
		ListView {
			id: list
			anchors.fill: parent
			anchors.topMargin: closeTimer.running ? 0 : -headerItem.height
			model: sensorListSortFilterModel
			delegate: sensorDelegate
			maximumFlickVelocity: Units.dp(1500)
			focus: true
			header: sensorListHeader
			section.property: "sensor.clientName"
			section.criteria: ViewSection.FullString
			section.delegate: sensorListSectionHeader
			pressDelay: 100
			onDragEnded: {
				if (headerItem.refresh && !refreshTimer.running) {
					console.log("Refreshing SensorModel")
					sensorModel.authorizationChanged()
					refreshTimer.start()
					closeTimer.start()
				}
			}
		}
		Timer {
			id: closeTimer
			interval: 1000
			running: false
			repeat: false
		}
		Timer {
			id: refreshTimer
			interval: 10000
			running: false
			repeat: false
		}
	}

	function formatLastUpdated(minutes, lastUpdated) {
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
		if (days <= 7) {
			return days + ' days ago';
		}
		return lastUpdated.toLocaleString(Qt.locale(), "yyyy-MM-dd");
	}

	function updateHeader() {
		header.title = "Sensors"
		header.editButtonVisible = true
		header.onEditClicked.connect(function() {
			sensorPage.showEditButtons = !sensorPage.showEditButtons;
		})
		header.backClickedMethod = function() {
			if (sensorPage.showEditButtons) {
				sensorPage.showEditButtons = false;
			} else {
				mainInterface.setActivePage(0);
			}
		}
	}
}

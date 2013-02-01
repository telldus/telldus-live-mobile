import QtQuick 1.0
import Telldus 1.0

Item {
	id: sensorPage
	Component {
		id: sensorDelegate
		Item {
			id: wrapper
			width: list.width
			height: 150*SCALEFACTOR
			clip: false
			z: model.index
			BorderImage {
				source: "rowBg.png"
				anchors.top: parent.top
				anchors.right: parent.right
				anchors.left: parent.left
				anchors.leftMargin: 20*SCALEFACTOR
				anchors.rightMargin: 20*SCALEFACTOR
				height: 140*SCALEFACTOR
				border {left: 21; top: 21; right: 21; bottom: 28 }

				Item {
					anchors.fill: parent
					anchors.topMargin: 1
					anchors.bottomMargin: 11

					Column {
						anchors.left: parent.left
						anchors.leftMargin: 20
						anchors.right: dataRow.left
						anchors.verticalCenter: parent.verticalCenter
						Text {
							color: sensor.name !== '' ? '#00659F' : '#8cabc5'
							width: parent.width
							font.pixelSize: 32*SCALEFACTOR
							font.weight: Font.Bold
							text: sensor.name !== '' ? sensor.name : '(no name)'
							elide: Text.ElideRight
						}
						Text {
							color: "#999999"
							font.pixelSize: 28*SCALEFACTOR
							text: ""  // TODO(micke): Add location name
						}
						Text {
							color: "#999999"  // TODO(micke): Red color if minutesAgo > some large number
							font.pixelSize: 25*SCALEFACTOR
							text: formatLastUpdated(sensor.minutesAgo)
						}
					}
					Row {
						id: dataRow
						spacing: 20
						anchors.right: parent.right
						anchors.rightMargin: 20
						anchors.verticalCenter: parent.verticalCenter
						Item {
							width: childrenRect.width
							height: humidityIcon.height
							visible: sensor.hasHumidity
							Image {
								id: humidityIcon
								source: "sensorIconHumidity.png"
								height: sourceSize.height*SCALEFACTOR
								width: sourceSize.width*SCALEFACTOR
							}
							Text {
								anchors.left: humidityIcon.right
								anchors.leftMargin: 10
								anchors.verticalCenter: parent.verticalCenter
								color: '#00659F'
								font.pixelSize: 28*SCALEFACTOR
								font.weight: Font.Bold
								text: sensor.humidity + '%'
							}
						}
						Item {
							width: childrenRect.width
							height: temperatureIcon.height
							visible: sensor.hasTemperature
							Image {
								id: temperatureIcon
								source: "sensorIconTemperature.png"
								height: sourceSize.height*SCALEFACTOR
								width: sourceSize.width*SCALEFACTOR
							}
							Text {
								anchors.left: temperatureIcon.right
								anchors.leftMargin: 10
								anchors.verticalCenter: parent.verticalCenter
								color: '#00659F'
								font.pixelSize: 28*SCALEFACTOR
								font.weight: Font.Bold
								text: sensor.temperature + '\u00B0C'
							}
						}
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
			height: header.height + 20
			width: parent.width
		}
		footer: Item {
			height: 10
			width: parent.width
		}

		anchors.fill: parent
		model: sensorModel
		delegate: sensorDelegate
		spacing: 0
	}

	Header {
		id: header
		anchors.topMargin: Math.min(0, -list.contentY)
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

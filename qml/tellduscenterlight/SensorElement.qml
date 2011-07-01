import Qt 4.7

Item{
	id: sensorElement
	height: col.height
	width: parent.width

	Sensor {
		id: sensorItem
		sensorId: sensor
	}

	Column {
		id: col
		width: parent.width

		Row {
			width: parent.width
			Text{
				id: name
				text: sensorItem.name
			}

			Text {
				id: lastUpdated
				text: 'Last updated: ' + Qt.formatDateTime(sensorItem.lastUpdated)
			}
		}

		Text{
			id: temperature
			text: 'Temperature: ' + sensorItem.temperature + '\u00B0'
			visible: sensorItem.hasTemperature
		}

		Text{
			id: humidity
			text: 'Humidity: ' + sensorItem.humidity + '%'
			visible: sensorItem.hasHumidity
		}
	}
}

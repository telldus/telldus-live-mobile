import Qt 4.7

Item{
	id: sensorElement
	height: col.height
	width: parent.width

	Column {
		id: col
		width: parent.width

		Row {
			width: parent.width
			Text{
				id: name
				text: sensor.name
			}

			Text {
				id: lastUpdated
				text: 'Last updated: ' + Qt.formatDateTime(sensor.lastUpdated)
			}
		}

		Text{
			id: temperature
			text: 'Temperature: ' + sensor.temperature + '\u00B0'
			visible: sensor.hasTemperature
		}

		Text{
			id: humidity
			text: 'Humidity: ' + sensor.humidity + '%'
			visible: sensor.hasHumidity
		}
	}
}

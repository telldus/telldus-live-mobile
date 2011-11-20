import Qt 4.7

Content {
	id: contentSensor

	ListView {
		id: sensorlist
		anchors.horizontalCenter: parent.horizontalCenter
		height: parent.height
		width: parent.width
		model: sensorModel
		delegate: SensorElement{ }
		z: 1
	}
}

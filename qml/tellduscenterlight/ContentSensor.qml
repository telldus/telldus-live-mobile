import Qt 4.7

Content {
	id: contentSensor

	ListView {
		id: favoritelist
		anchors.horizontalCenter: parent.horizontalCenter
		height: parent.height
		width: parent.width
		model: SensorListModel{ }
		delegate: SensorElement{ }
		z: 1
	}
}

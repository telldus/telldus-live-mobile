import QtQuick 1.1

Item {
	id: root
	property bool running: true
	width: 90
	height: 90
	Image {
		id: spinner
		property int index: 1
		source: "throbber/throbber_" + index + ".svg"
		smooth: true
		width: root.width
		height: root.height
		sourceSize.height: root.height
		sourceSize.width: root.width
		NumberAnimation on index {
			from: 1; to: 12
			duration: 1000
			running: root.running && root.visible
			loops: Animation.Infinite
		}
	}
}

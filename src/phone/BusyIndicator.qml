import QtQuick 1.1

Item {
	id: root
	property bool running: true
	width: spinner.width
	height: spinner.height
	Image {
		id: spinner
		property int index: 1
		source: "throbber/throbber" + index + ".png"
		smooth: true
		NumberAnimation on index {
			from: 1; to: 12
			duration: 1000
			running: root.running && root.visible
			loops: Animation.Infinite
		}
	}
}

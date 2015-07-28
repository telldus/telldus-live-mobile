import QtQuick 2.0

Item {
	id: root
	property bool running: true
	width: 45 * SCALEFACTOR
	height: 45 * SCALEFACTOR
	Image {
		id: spinner
		property int index: 1
		source: "../images/throbber/throbber_" + index + ".svg"
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

import QtQuick 1.1
import Telldus 1.0

Row {
	Item {
		height: parent.height
		width: 64
		Image {
			anchors.centerIn: parent
			source: "buttonActionDownActive.png"
		}
	}
	Item {
		height: parent.height
		width: 64
		Image {
			anchors.centerIn: parent
			source: "buttonActionStop.png"
		}
	}
	Item {
		height: parent.height
		width: 64
		Image {
			anchors.centerIn: parent
			source: "buttonActionUp.png"
		}
	}
}

import QtQuick 1.1
import Telldus 1.0

BorderImage {
	id: buttonSet
	property int set: primarySet()
	property Device device
	source: "buttonBg.png"
	border {left: 15; top: 49; right: 15; bottom: 49 }
	width: 222
	height: 100

	ComponentSetOnOff {
		id: componentSetOnOff
	}
	Component {
		id: component_setUpDown
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
	}

	Loader {
		id: loader
		sourceComponent: {
			if (set == 0) {
				return componentSetOnOff;
			}
			return undefined
		}
		anchors.fill: parent
	}

	/*MouseArea {
		anchors.fill: parent
	}*/

	function primarySet() {
		if (set < 0) {
			// Autodetect
		}
		return 0;
	}

}

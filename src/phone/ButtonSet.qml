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

	Loader {
		id: loader
		source: {
			if (set == 0) {
				return 'ComponentSetOnOff.qml';
			} else if (set == 1) {
				return 'ComponentSetUpDown.qml';
			}
			return '';
		}
		anchors.fill: parent
	}

	function primarySet() {
		if (device.methods & (128+256)) {
			return 1; // Up and Down
		}

		return 0;
	}

}

import QtQuick 1.1
import Telldus 1.0

Item {
	id: buttonSet
	property int set: primarySet()
	property Device device
	property int methods: device.methods

	width: 222 * SCALEFACTOR
	height: 100 * SCALEFACTOR

	BorderImage {
		source: "buttonBg.png"
		border {left: 15; top: 49; right: 15; bottom: 49 }
		width: parent.width/SCALEFACTOR
		height: parent.height/SCALEFACTOR
		scale: SCALEFACTOR
		transformOrigin: Item.TopLeft
		Loader {
			id: loader
			source: {
				if (set == 0) {
					return 'ComponentSetOnOff.qml';
				} else if (set == 1) {
					return 'ComponentSetUpDown.qml';
				} else if (set == 2) {
					return 'ComponentSetBell.qml';
				}

				return '';
			}
			anchors.fill: parent
		}
	}

	function primarySet() {
		if (methods & (128+256)) {
			return 1; // Up and Down
		}
		if (methods & 4) {
			return 2;
		}

		return 0;
	}

}

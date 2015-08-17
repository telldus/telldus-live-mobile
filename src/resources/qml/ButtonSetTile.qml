import QtQuick 2.0
import Telldus 1.0

Item {
	id: buttonSet
	property int set: primarySet()
	property Device device
	property int methods: device.methods

	anchors.fill: parent

	Loader {
		id: loader
		source: {
			if (set == 0) {
				return 'ComponentSetOnOffTile.qml';
			} else if (set == 1) {
				return 'ComponentSetUpDown.qml';
			} else if (set == 2) {
				return 'ComponentSetBell.qml';
			} else if (set == 3) {
				return 'ComponentSetLearn.qml';
			}

			return '';
		}
		anchors.fill: parent
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

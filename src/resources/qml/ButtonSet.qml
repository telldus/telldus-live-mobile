import QtQuick 2.0
import Telldus 1.0
import Tui 0.1

Item {
	id: tile
	property int set: primarySet()
	property Device device
	property int methods: device.methods
	property var showBorder: false
	property var hue: 0.6
	property var saturation: 0.55
	property var lightness: 0.24
	readonly property var hueDefault: 0.6
	readonly property var saturationDefault: 0.55
	readonly property var lightnessDefault: 0.24
	readonly property var hasNameInTile: false

	width: Units.dp(100)
	height: Units.dp(40)
	Card {
		id: tileBorder
		anchors.fill: parent
		tintColor: "#BDBDBD"
		radius: height / 6
		Rectangle {
			id: tileCard
			anchors.fill: parent
			anchors.margins: tile.showBorder ? 1 * SCALEFACTOR : 0
			color: "#ffffff"
			radius: height / 6
			Loader {
				id: tileContent
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

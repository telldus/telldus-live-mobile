import QtQuick 2.0
import QtQuick.Window 2.2
import Telldus 1.0

Rectangle {
	id: dashboardPage
	color: "#ffffff"

	Component {
		id: dashboardItemDelegate
		Rectangle {
			id: wrapper
			width: list.cellWidth
			height: list.cellHeight
			clip: true
			z: model.index
			color: calculateTileColor(index)

			ListView.onRemove: SequentialAnimation {
				PropertyAction { target: wrapper; property: "ListView.delayRemove"; value: true }
				PropertyAction { target: wrapper; property: "z"; value: -1 }
//				NumberAnimation { target: wrapper; properties: "height,opacity"; to: 0; duration: 250; easing.type: Easing.InOutQuad }
				PropertyAction { target: wrapper; property: "ListView.delayRemove"; value: false }
			}
			ListView.onAdd: SequentialAnimation {
				PropertyAction { target: wrapper; property: "z"; value: -1 }
				ParallelAnimation {
//					NumberAnimation { target: wrapper; properties: "height"; from: 0; to: 150; duration: 250; easing.type: Easing.InOutQuad }
//					NumberAnimation { target: wrapper; properties: "opacity"; from: 0; to: 1; duration: 250; easing.type: Easing.InOutQuad }
				}
				PropertyAction { target: wrapper; property: "z"; value: 0 }
			}
			Rectangle {
				anchors.fill: parent
				color: "#ffffff"
			}
			Rectangle {
				anchors.fill: parent
				anchors.margins: 2 * SCALEFACTOR
				color: wrapper.color
			}
			Rectangle {
				anchors.fill: parent
				anchors.margins: 4 * SCALEFACTOR
				color: "#ffffff"
			}
			Loader {
				id: tileContent
				source: {
					if (dashboardItem.childObjectType == DashboardItem.DeviceChildObjectType) {
						return 'tiles/DeviceTile.qml';
					} else if (dashboardItem.childObjectType == DashboardItem.SensorChildObjectType) {
						return 'tiles/SensorTile.qml';
					} else if (dashboardItem.childObjectType == DashboardItem.WeatherChildObjectType) {
						return 'tiles/WeatherTile.qml';
					}
					return 'UnknownTile.qml';
				}
				anchors.fill: parent
			}
		}
	}
	Item {
		id: listPage
		anchors.fill: parent
		clip: true

		GridView {
			id: list
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.topMargin: screen.isPortrait ? header.height + (2 * SCALEFACTOR) : 2 * SCALEFACTOR
			anchors.leftMargin: screen.isPortrait ? 2 * SCALEFACTOR : header.width + (2 * SCALEFACTOR)
			anchors.bottomMargin: 2 * SCALEFACTOR
			anchors.rightMargin: 2 * SCALEFACTOR
			width: parent.width - list.anchors.leftMargin
			height: parent.height - list.anchors.topMargin
			model: dashboardModel
			delegate: dashboardItemDelegate
			cellWidth: calculateTileSize(listPage.width - list.anchors.leftMargin - (2 * SCALEFACTOR))
			cellHeight: list.cellWidth
			maximumFlickVelocity: 1500 * SCALEFACTOR
		}
		Header {
			id: header
		}
	}
	function calculateTileSize(listWidth) {
		console.log("List width: " + listWidth);
		var numberOfTiles = Math.floor(listWidth / (116 * SCALEFACTOR));
		if (numberOfTiles == 0) {
			return (100 * SCALEFACTOR);
		}
		console.log("Number of tiles: " + numberOfTiles);
		var tileSize = listWidth / numberOfTiles;
		console.log("Tile Size:" + tileSize);
		return tileSize;
	}
	function calculateTileColor(index) {
		var tilesForFullHueRange = list.count
		var saturation = 0.5;
		var lightness = 0.4;
		var alpha = 1;
		var minHue = 0.25;
		var maxHue = 0.85;
		var indexedHue = (index / tilesForFullHueRange) - Math.floor(index / tilesForFullHueRange)
		var hue = (indexedHue * (maxHue - minHue)) + minHue
		return Qt.hsla(hue, saturation, lightness, alpha);
	}

}

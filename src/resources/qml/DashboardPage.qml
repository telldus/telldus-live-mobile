import QtGraphicalEffects 1.0
import QtQuick 2.0
import QtQuick.Window 2.2
import Telldus 1.0
import Tui 0.1

Rectangle {
	id: dashboardPage
	color: properties.theme.colors.dashboardBackground
	readonly property real tilePadding: Units.dp(properties.theme.core.tilePadding)

	Component {
		id: dashboardItemDelegate
		Item {
			id: tile
			property bool showBorder: false
			property real hue: 0.6
			property real saturation: 0.55
			property real lightness: 0.24
			readonly property real hueDefault: 0.6
			readonly property real saturationDefault: 0.55
			readonly property real lightnessDefault: 0.24
			readonly property bool hasNameInTile: true

			width: list.tileSize
			height: list.tileSize
			z: model.index

			Card {
				id: tileCard
				anchors.fill: parent
				anchors.rightMargin: tilePadding
				anchors.bottomMargin: tilePadding
				tintColor: "#FAFAFA"
				Loader {
					id: tileContent
					asynchronous: true
					Connections {
						target: tileTimer
						onTriggered: {
							if (tileContent.item.switchTileSlides) {
								tileContent.item.switchTileSlides()
							}
						}
					}
					source: {
						if (dashboardItem.childObjectType == DashboardItem.DeviceChildObjectType) {
							return 'tiles/DeviceTile.qml';
						} else if (dashboardItem.childObjectType == DashboardItem.SensorChildObjectType) {
							return 'tiles/SensorTile.qml';
						} else if (dashboardItem.childObjectType == DashboardItem.WeatherChildObjectType) {
							return 'tiles/WeatherTile.qml';
						}
						return 'tiles/UnknownTile.qml';
					}
					anchors.fill: parent
				}
			}
		}
	}
	Item {
		id: listPage
		anchors.fill: parent

		Timer {
			id: tileTimer
			interval: 5000
			running: true
			repeat: true
		}
		GridView {
			id: list
			property int tileSize: 0
			property int tileLabelHeight: 0
			onWidthChanged: calculateTileSize()

			anchors.top: parent.top
			anchors.left: parent.left
			anchors.topMargin: screen.showHeaderAtTop ? header.height + tilePadding : tilePadding
			anchors.leftMargin: screen.showHeaderAtTop ? tilePadding : header.width + tilePadding
			anchors.bottomMargin: tilePadding
			anchors.rightMargin: tilePadding
			width: parent.width - list.anchors.leftMargin
			height: parent.height - list.anchors.topMargin
			model: dashboardModel
			delegate: dashboardItemDelegate
			cellWidth: this.tileSize
			cellHeight: this.tileSize
			maximumFlickVelocity: Units.dp(1500)
		}
		Header {
			id: header
		}
	}

	function calculateTileSize() {
		var listWidth = list.width
		if (listWidth > 0) {
//			console.log("List width: " + listWidth);
			var numberOfTiles = Math.floor(listWidth / Units.dp(100));
//			console.log("Number of tiles: " + numberOfTiles);
			var tileSize = listWidth / numberOfTiles;
			if (numberOfTiles == 0) {
				tileSize = Units.dp(100)
			}
//			console.log("Tile Size:" + tileSize);
			list.tileSize = Math.floor(tileSize);
			list.tileLabelHeight = Math.floor(tileSize * 0.25);
		}
	}

}

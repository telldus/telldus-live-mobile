import QtGraphicalEffects 1.0
import QtQuick 2.0
import QtQuick.Window 2.2
import Telldus 1.0

Rectangle {
	id: dashboardPage
	color: properties.theme.colors.dashboardBackground
	readonly property real tilePadding: properties.theme.core.tilePadding * SCALEFACTOR

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

			width: list.cellWidth
			height: list.cellHeight
			z: model.index

			DropShadow {
				visible: properties.theme.isMaterialDesign
				anchors.fill: tileBorder
				horizontalOffset: 0
				verticalOffset: 1.5 * SCALEFACTOR
				radius: 8.0
				spread: 0.0
				samples: 16
				cached: true
				color: "#000000"
				source: tileBorder
				transparentBorder: true
				smooth: true
				opacity: 0.16
			}
			DropShadow {
				visible: properties.theme.isMaterialDesign
				anchors.fill: tileBorder
				horizontalOffset: 0
				verticalOffset: 1.5 * SCALEFACTOR
				radius: 8.0
				spread: 0.0
				samples: 16
				cached: true
				color: "#000000"
				source: tileBorder
				transparentBorder: true
				smooth: true
				opacity: 0.23
			}
			Rectangle {
				id: tileBorder
				anchors.fill: parent
				anchors.rightMargin: tilePadding
				anchors.bottomMargin: tilePadding
				color: Qt.hsla(tile.hue, tile.saturation, tile.lightness, 1)
				radius: width / 15
				Rectangle {
					id: tileWhite
					anchors.fill: parent
					anchors.margins: tile.showBorder ? 1 * SCALEFACTOR : 0
					color: "#ffffff"
					radius: width / 15
					Loader {
						id: tileContent
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
			cellWidth: calculateTileSize(list.width)
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

}

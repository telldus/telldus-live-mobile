import QtGraphicalEffects 1.0
import QtQuick 2.0
import QtQuick.Window 2.2
import Telldus 1.0

Rectangle {
	id: dashboardPage
	color: properties.theme.colors.dashboardBackground
	readonly property var tilePadding: properties.theme.core.tilePadding * SCALEFACTOR

	Component {
		id: dashboardItemDelegate
		Item {
			id: tile
			property var hue: calculateTileHue(dashboardItem)
			property var saturation: calculateTileSaturation(dashboardItem)
			property var lightness: calculateTileLightness(dashboardItem)
			readonly property var saturationDefault: calculateTileSaturation(dashboardItem)
			readonly property var lightnessDefault: calculateTileLightness(dashboardItem)

			width: list.cellWidth
			height: list.cellHeight
			z: model.index

			ListView.onRemove: SequentialAnimation {
				PropertyAction { target: tile; property: "ListView.delayRemove"; value: true }
				PropertyAction { target: tile; property: "z"; value: -1 }
//				NumberAnimation { target: tile; properties: "height,opacity"; to: 0; duration: 250; easing.type: Easing.InOutQuad }
				PropertyAction { target: tile; property: "ListView.delayRemove"; value: false }
			}
			ListView.onAdd: SequentialAnimation {
				PropertyAction { target: tile; property: "z"; value: -1 }
				ParallelAnimation {
//					NumberAnimation { target: tile; properties: "height"; from: 0; to: 150; duration: 250; easing.type: Easing.InOutQuad }
//					NumberAnimation { target: tile; properties: "opacity"; from: 0; to: 1; duration: 250; easing.type: Easing.InOutQuad }
				}
				PropertyAction { target: tile; property: "z"; value: 0 }
			}
			Rectangle {
				id: tileWhite
				anchors.fill: parent
				anchors.rightMargin: tilePadding
				anchors.bottomMargin: tilePadding
				color: "#ffffff"
				radius: width / 15
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
			DropShadow {
				anchors.fill: tileWhite
				horizontalOffset: 2 * SCALEFACTOR
				verticalOffset: horizontalOffset
				radius: horizontalOffset / 2
				spread: 0.0
				samples: horizontalOffset * 2
				color: "#40000000"
				source: tileWhite
				transparentBorder: true
			}
		}
	}
	Item {
		id: listPage
		anchors.fill: parent

		GridView {
			id: list
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.topMargin: screen.isPortrait ? header.height + tilePadding : tilePadding
			anchors.leftMargin: screen.isPortrait ? tilePadding : header.width + tilePadding
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
	function calculateTileHue(dashboardItem) {
		//var tilesForFullHueRange = list.count
		//var minHue = 0.2;
		//var maxHue = 0.85;
		//var indexedHue = (index / tilesForFullHueRange) - Math.floor(index / tilesForFullHueRange)
		//var hue = (indexedHue * (maxHue - minHue)) + minHue
		//return 1 - hue;
		if (dashboardItem.childObjectType == DashboardItem.DeviceChildObjectType) {
			return rgbToHsl(properties.theme.colors.telldusOrange).hue;
		} else if (dashboardItem.childObjectType == DashboardItem.SensorChildObjectType) {
			return rgbToHsl(properties.theme.colors.telldusBlue).hue;
		} else if (dashboardItem.childObjectType == DashboardItem.WeatherChildObjectType) {
			return 0.16;
		}
		return 0;
	}
	function calculateTileSaturation(dashboardItem) {
		if (dashboardItem.childObjectType == DashboardItem.DeviceChildObjectType) {
			return rgbToHsl(properties.theme.colors.telldusOrange).saturation;
		} else if (dashboardItem.childObjectType == DashboardItem.SensorChildObjectType) {
			return rgbToHsl(properties.theme.colors.telldusBlue).saturation;
		} else if (dashboardItem.childObjectType == DashboardItem.WeatherChildObjectType) {
			return 0.73;
		}
		return 0.5;
	}
	function calculateTileLightness(dashboardItem) {
		if (dashboardItem.childObjectType == DashboardItem.DeviceChildObjectType) {
			return rgbToHsl(properties.theme.colors.telldusOrange).lightness;
		} else if (dashboardItem.childObjectType == DashboardItem.SensorChildObjectType) {
			return rgbToHsl(properties.theme.colors.telldusBlue).lightness;
		} else if (dashboardItem.childObjectType == DashboardItem.WeatherChildObjectType) {
			return 0.51;
		}
		return 0.5;
	}
	function rgbToHsl(color){
		var r = color.r
		var g = color.g
		var b = color.b
		var max = Math.max(r, g, b), min = Math.min(r, g, b);
		var h, s, l = (max + min) / 2;

		if(max == min){
			h = s = 0; // achromatic
		}else{
			var d = max - min;
			s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
			switch(max){
				case r: h = (g - b) / d + (g < b ? 6 : 0); break;
				case g: h = (b - r) / d + 2; break;
				case b: h = (r - g) / d + 4; break;
			}
			h /= 6;
		}
		return {hue: h, saturation: s, lightness: l};
	}

}

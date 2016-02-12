import QtGraphicalEffects 1.0
import QtQuick 2.0
import QtQuick.Window 2.2
import Telldus 1.0
import Tui 0.1

Item {
	id: dashboardPage
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
		Component {
			id: dashboardListHeader
			Item {
				height: Units.dp(60)
				width: parent.width
				y: -list.contentY - height

				property bool refresh: state == "pulled" ? true : false

				Item {
					id: arrow
					anchors.fill: parent
					Image {
						id: arrowImage
						visible: !refreshTimer.running
						anchors.centerIn: parent
						height: parent.height * 0.5
						width: height
						source: "image://icons/refreshArrow/#999999"
						asynchronous: true
						smooth: true
						fillMode: Image.PreserveAspectFit
						sourceSize.width: width * 2
						sourceSize.height: height * 2
					}
					Image {
						id: arrowImageRunning
						visible: closeTimer.running
						anchors.centerIn: parent
						height: parent.height * 0.5
						width: height
						source: "image://icons/refresh/#999999"
						asynchronous: true
						smooth: true
						fillMode: Image.PreserveAspectFit
						sourceSize.width: width * 2
						sourceSize.height: height * 2
						transformOrigin: Item.Center
						RotationAnimation on rotation {
							loops: Animation.Infinite
							from: 0
							to: 360
							duration: 1000
							running: closeTimer.running
						}
					}
					transformOrigin: Item.Center
					Behavior on rotation { NumberAnimation { duration: 200 } }
				}
				Text {
					anchors.centerIn: parent
					visible: refreshTimer.running && !closeTimer.running
					color: properties.theme.colors.telldusBlue
					font.pixelSize: Units.dp(12)
					text: "You can refresh once every 10 seconds."
					elide: Text.ElideRight
				}
				states: [
					State {
						name: "base"; when: list.contentY >= -Units.dp(140)
						PropertyChanges { target: arrow; rotation: 180 }
					},
					State {
						name: "pulled"; when: list.contentY < -Units.dp(140)
						PropertyChanges { target: arrow; rotation: 0 }
					}
				]
			}
		}
		Rectangle {
			id: listEmptyView
			anchors.fill: parent
			visible : list.count == 0
			color: "#F5F5F5"
			onVisibleChanged: {
				if (list.count == 0) {
					refreshTimer.stop()
					closeTimer.stop()
				}
			}

			Text {
				anchors.left: parent.left
				anchors.right: parent.right
				anchors.verticalCenter: parent.verticalCenter
				anchors.leftMargin: Units.dp(20)
				anchors.rightMargin:Units.dp(20)
				color: properties.theme.colors.telldusBlue
				font.pixelSize: Units.dp(16)
				wrapMode: Text.Wrap
				horizontalAlignment: Text.AlignHCenter
				text: "You have not set any devices or sensors to show in the dashboard, to do this go to their page and click on the star in the top right."
			}
		}
		GridView {
			id: list
			property int tileSize: 0
			property int tileLabelHeight: 0
			onWidthChanged: calculateTileSize()
			onHeightChanged: calculateTileSize()

			visible : list.count > 0
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.topMargin: closeTimer.running ? 0 : -headerItem.height + tilePadding
			anchors.leftMargin: tilePadding
			anchors.bottomMargin: tilePadding
			anchors.rightMargin: tilePadding
			width: parent.width - list.anchors.leftMargin
			height: parent.height - list.anchors.topMargin
			model: dashboardModel
			delegate: dashboardItemDelegate
			cellWidth: this.tileSize
			cellHeight: this.tileSize
			maximumFlickVelocity: Units.dp(1500)
			header: dashboardListHeader
			pressDelay: 100
			onDragEnded: {
				if (headerItem.refresh && !refreshTimer.running) {
					console.log("Refreshing DeviceModel")
					deviceModelController.authorizationChanged()
					console.log("Refreshing SensorModel")
					sensorModel.authorizationChanged()
					refreshTimer.start()
					closeTimer.start()
				}
			}
			Timer {
				id: closeTimer
				interval: 1000
				running: false
				repeat: false
			}
			Timer {
				id: refreshTimer
				interval: 10000
				running: false
				repeat: false
			}
		}
	}

	function calculateTileSize() {
		var listWidth = list.width
		var baseTileSize = listWidth > (isPortrait ? Units.dp(600) : Units.dp(800)) ? 150 : 100;
		if (listWidth > 0) {
			var numberOfTiles = Math.floor(listWidth / Units.dp(baseTileSize));
			var tileSize = listWidth / numberOfTiles;
			if (numberOfTiles == 0) {
				tileSize = Units.dp(baseTileSize)
			}
			list.tileSize = Math.floor(tileSize);
			list.tileLabelHeight = Math.floor(tileSize * 0.25);
		}
	}

	function onBackClicked() {
		if (mainInterface.menuViewVisible) {
			mainInterface.closeMenu();
		} else {
			core.quit();
		}
	}

	function updateHeader() {
		header.title = "";
	}


}

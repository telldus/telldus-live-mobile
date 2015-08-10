import QtQuick 2.0
import QtQuick.Window 2.2
import Telldus 1.0

Rectangle {
	id: dashboardPage
	color: "#ffffff"

	Component {
		id: deviceDelegate
		Item {
			id: wrapper
			property Device dev: device
			width: list.cellWidth - (10 * SCALEFACTOR)
			height: list.cellHeight - (10 * SCALEFACTOR)
			clip: true
			z: model.index
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
				id: contentBackground
				color: "#dbebf6"
				width: parent.width
				height: parent.height
				anchors.verticalCenter: parent.verticalCenter
				anchors.horizontalCenter: parent.horizontalCenter
				clip: true
//				radius: 5 * SCALEFACTOR
				Rectangle {
					id: contentHeader
					color: "#20334d"
					height: deviceName.height + (10 * SCALEFACTOR)
					anchors.left: parent.left
					anchors.top: parent.top
					anchors.right: parent.right
//					radius: 5 * SCALEFACTOR
/*					Rectangle {
						height: 10 * SCALEFACTOR
						anchors.left: parent.left
						anchors.right: parent.right
						anchors.bottom: parent.bottom
						color: contentHeader.color
					}*/
					Text {
						id: deviceName
						anchors.horizontalCenter: parent.horizontalCenter
						anchors.verticalCenter: parent.verticalCenter
						color: "#ffffff"
						font.pixelSize: 14 * SCALEFACTOR
						text: device.name
						width: parent.width - (10 * SCALEFACTOR)
						elide: Text.ElideMiddle
						horizontalAlignment: Text.AlignHCenter
						verticalAlignment: Text.AlignVCenter
					}
				}
				Item {
					anchors.left: parent.left
					anchors.top: contentHeader.bottom
					anchors.right: parent.right
					anchors.bottom: parent.bottom
					ButtonSet {
						id: buttons
						device: wrapper.dev
						anchors.horizontalCenter: parent.horizontalCenter
						anchors.verticalCenter: parent.verticalCenter
					}

				}
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
			anchors.topMargin: screen.isPortrait ? header.height + (10 * SCALEFACTOR) : 10 * SCALEFACTOR
			anchors.leftMargin: screen.isPortrait ? 10 * SCALEFACTOR : header.width + (10 * SCALEFACTOR)
			width: parent.width - list.anchors.leftMargin
			height: parent.height - list.anchors.topMargin
			model: dashboardModel
			delegate: deviceDelegate
			cellWidth: calculateTileSize(listPage.width - list.anchors.leftMargin - (10 * SCALEFACTOR)) + (10 * SCALEFACTOR)
			cellHeight: list.cellWidth
			maximumFlickVelocity: 1500 * SCALEFACTOR
		}
		Header {
			id: header
		}
	}
	function calculateTileSize(listWidth) {
		console.log("List width: " + listWidth);
		var extendedListSize = listWidth + (10 * SCALEFACTOR);
		var numberOfTiles = Math.floor(extendedListSize / (116 * SCALEFACTOR));
		if (numberOfTiles == 0) {
			return (100 * SCALEFACTOR);
		}
		console.log("Number of tiles: " + numberOfTiles);
		var tileSize = Math.floor((listWidth - ((10 * SCALEFACTOR) * (numberOfTiles - 1))) / numberOfTiles);
		console.log("Tile Size:" + tileSize);
		return tileSize;
	}

}

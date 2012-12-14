import QtQuick 1.0

Image {
	id: footer
	anchors.bottom: parent.bottom
	anchors.left: parent.left
	anchors.right: parent.right
	source: "footerBg.png"
	fillMode: Image.TileHorizontally
	height: 140
	
	Row {
		anchors.bottom: parent.bottom
		anchors.left: parent.left
		anchors.right: parent.right
		height: 123
		BorderImage {
			source: "footerButtonActive.png"
			width: parent.width/3
			height: parent.height
			border {left: 20; top: 20; right: 20; bottom: 20 }
			Image {
				anchors.centerIn: parent
				source: "footerIconDevicesActive.png"
			}
		}
		Image {
			source: "buttonDivider.png"
			height: parent.height
			fillMode: Image.TileVertically
		}
		Item {
			width: parent.width/3
			height: parent.height
			Image {
				anchors.centerIn: parent
				source: "footerIconSensors.png"
			}
		}
		Image {
			source: "buttonDivider.png"
			height: parent.height
			fillMode: Image.TileVertically
		}
		Item {
			width: parent.width/3
			height: parent.height
			Image {
				anchors.centerIn: parent
				source: "footerIconSettings.png"
			}
		}
	}
}

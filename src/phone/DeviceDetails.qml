import QtQuick 1.1
import Telldus 1.0

Item {
	id: showDevice
	property Device selected
	signal backClicked()
	anchors.top: parent.top
	anchors.left: listPage.right
	anchors.bottom: parent.bottom
	width: parent.width

	Header {
		id: deviceH
		title: showDevice.selected ? showDevice.selected.name : ''
		backVisible: true
		onBackClicked: showDevice.backClicked()
	}
	BorderImage {
		source: "rowBg.png"
		anchors.top: deviceH.bottom
		anchors.right: parent.right
		anchors.left: parent.left
		anchors.bottom: parent.bottom
		anchors.margins: 20
		border {left: 21; top: 21; right: 21; bottom: 28 }
		Item {
			anchors.bottom: parent.bottom
			anchors.bottomMargin: 20
			anchors.left: parent.left
			anchors.leftMargin: 20
			height: childrenRect.height
			width: childrenRect.width
			Row {
				spacing: 20
				Image {
					id: iconFavorite
					source: showDevice.selected && showDevice.selected.isFavorite ? "iconFavouriteActive.png" : "iconFavourite.png"
				}
				Text {
					text: "Favorite"
					color: "#00659F"
					font.pointSize: 11
					font.weight: Font.Bold
					height: iconFavorite.height
					verticalAlignment: Text.AlignVCenter
				}
			}
			MouseArea {
				anchors.fill: parent
				onClicked: showDevice.selected.isFavorite = !showDevice.selected.isFavorite
			}
		}
	}
}

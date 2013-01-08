import QtQuick 1.1
import Telldus 1.0

Item {
	id: showDevice
	property Device selected
	signal backClicked()

	Header {
		id: deviceH
		title: showDevice.selected.name
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
		Column {
			anchors.fill: parent
			anchors.margins: 20
			spacing: 20
			Text {
				text: "Location: " + showDevice.selected.clientName
				color: "#999999"
				width: parent.width
				font.pixelSize: 30
				font.bold: Font.Bold
				elide: Text.ElideRight
			}

			Repeater {
				model: ListModel {
					ListElement { set: 0; req: 1 }
					ListElement { set: 1; req: 384 }
					ListElement { set: 2; req: 4 }
				}
				delegate: ButtonSet {
					set: model.set
					device: selected
					methods: selected.methods & ~16  // Clear the dim method
					visible: selected.methods & model.req
					width: parent.width
				}
			}

			Item {
				width: favRow.width
				height: favRow.height
				Row {
					id: favRow
					spacing: 20
					Image {
						id: iconFavorite
						source: showDevice.selected.isFavorite ? "iconFavouriteActive.png" : "iconFavourite.png"
					}
					Item {
						height: iconFavorite.height
						width: childrenRect.width
						Column {
							anchors.verticalCenter: parent.verticalCenter
							Text {
								text: showDevice.selected.isFavorite ? "Device is in Your Favorites" : "Add device to Your Favorites"
								color: showDevice.selected.isFavorite ? "#06456a" : "#999999"
								font.pointSize: 8
								font.weight: Font.Bold
							}
							Text {
								text: "Tap to remove"
								color: "#06456a"
								font.pointSize: 4
								font.weight: Font.Bold
								visible: showDevice.selected.isFavorite
							}
						}
					}
				}
				MouseArea {
					anchors.fill: parent
					onClicked: showDevice.selected.isFavorite = !showDevice.selected.isFavorite
				}
			}
		}
	}
}

import QtQuick 1.1

Item {
	id: devicePage

	Component {
		id: deviceDelegate
		Item {
			width: parent.width
			height: 150
			BorderImage {
				source: "rowBg.png"
				anchors.fill: parent
				anchors.leftMargin: 20
				anchors.rightMargin: 20
				border {left: 21; top: 21; right: 21; bottom: 28 }

				Rectangle {
					id: buttons
					anchors.verticalCenter: parent.verticalCenter
					anchors.left: parent.left
					anchors.leftMargin: 20
					color: "lightblue"
					width: 150
					height: 75
					radius: 5
				}

				Column {
					anchors.verticalCenter: parent.verticalCenter
					anchors.left: buttons.right
					anchors.leftMargin: 20
					anchors.right: arrow.left
					Text {
						color: "#00659F"
						width: parent.width
						font.pixelSize: 45
						font.weight: Font.Bold
						text: device.name
						elide: Text.ElideRight
					}
					Text {
						color: "#999999"
						font.pixelSize: 25
						text: "Home"
					}
				}

				Image {
					id: arrow
					source: "rowArrow.png"
					anchors.right: parent.right
					anchors.rightMargin: 20
					anchors.verticalCenter: parent.verticalCenter
				}
			}
		}
	}

	ListView {
		id: list
		header: Item {
			height: header.height + headerMenu.height + 20
			width: parent.width
		}
		footer: Item {
			height: 20
			width: parent.width
		}

		anchors.fill: parent
		model: deviceModel
		delegate: deviceDelegate
		spacing: 10
	}

	Image {
		id: header
		anchors.top: parent.top
		anchors.topMargin: {
			if (list.contentY <= 0) {
				return 0;
			}
			if (list.contentY >= header.height) {
				return -header.height;
			}
			return -list.contentY;
		}

		anchors.left: parent.left
		anchors.right: parent.right
		source: "headerBg.png"
		fillMode: Image.TileHorizontally
		height: 103
		Image {
			anchors.verticalCenter: parent.verticalCenter
			source: "headerLogo.png"
		}
	}
	HeaderMenu {
		id: headerMenu
		Component.onCompleted: activeItem = fav
		items: [
			HeaderMenuItem {
				id: fav
				title: "Favorites"
				onActivated: {
					headerMenu.activeItem = fav
					list.positionViewAtBeginning()
					favoriteModel.doFilter = true
				}
			},
			HeaderMenuItem {
				id: allDev
				title: "All devices"
				onActivated: {
					headerMenu.activeItem = allDev
					list.positionViewAtBeginning()
					favoriteModel.doFilter = false
				}
			}
		]
	}
}

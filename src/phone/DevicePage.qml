import QtQuick 1.1

Item {
	id: devicePage

	Component {
		id: deviceDelegate
		Item {
			id: wrapper
			width: list.width
			height: 150
			clip: false
			ListView.onRemove: SequentialAnimation {
				PropertyAction { target: wrapper; property: "ListView.delayRemove"; value: true }
				PropertyAction { target: wrapper; property: "z"; value: -1 }
				NumberAnimation { target: wrapper; properties: "height,opacity"; to: 0; duration: 250; easing.type: Easing.InOutQuad }
				PropertyAction { target: wrapper; property: "ListView.delayRemove"; value: false }
			}
			ListView.onAdd: SequentialAnimation {
				PropertyAction { target: wrapper; property: "z"; value: -1 }
				ParallelAnimation {
					NumberAnimation { target: wrapper; properties: "height"; from: 0; to: 150; duration: 250; easing.type: Easing.InOutQuad }
					NumberAnimation { target: wrapper; properties: "opacity"; from: 0; to: 1; duration: 250; easing.type: Easing.InOutQuad }
				}
				PropertyAction { target: wrapper; property: "z"; value: 0 }
			}
			BorderImage {
				source: "rowBg.png"
				anchors.top: parent.top
				anchors.right: parent.right
				anchors.left: parent.left
				anchors.leftMargin: 20
				anchors.rightMargin: 20
				height: 140
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
			height: 10
			width: parent.width
		}

		anchors.fill: parent
		model: favoriteModel
		delegate: deviceDelegate
		spacing: 0
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

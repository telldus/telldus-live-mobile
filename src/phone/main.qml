import QtQuick 1.0

Rectangle {
	color: "#dceaf6"
	//width: 640
	//height: 1136
	width: 768
	height: 1280

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
						width: parent.width
						font.pixelSize: 45
						font.weight: Font.Bold
						text: device.name
						elide: Text.ElideRight
					}
					Text {
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

		anchors.top: parent.top
		anchors.bottom: footer.top
		anchors.left: parent.left
		anchors.right: parent.right

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
	Item {
		id: headerMenu
		height: 53
		anchors.top: header.bottom
		anchors.left: parent.left
		anchors.right: parent.right
		Image {
			height: 63
			anchors.left: parent.left
			anchors.right: parent.right
			source: "headerMenuBg.png"
			fillMode: Image.TileHorizontally
		}
		Image {
			width: parent.width/2
			height: parent.height
			source: "headerButtonActive.png"
			Text {
				anchors.centerIn: parent
				text: "All devices"
				font.pixelSize: 30
				font.weight: Font.Bold
				color: "white"
			}
		}
		Item {
			width: parent.width/2
			height: parent.height
			anchors.right: parent.right
			Text {
				anchors.centerIn: parent
				text: "Favourites"
				font.pixelSize: 30
				font.weight: Font.Bold
				color: "white"
			}
		}
	}

	Footer {
		id: footer
		anchors.bottom: parent.bottom
		anchors.left: parent.left
		anchors.right: parent.right
	}
}


import QtQuick 1.1
import Telldus 1.0

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
			MouseArea {
				id: mouseArea
				anchors.fill: parent
				onClicked: {
					devicePage.state = 'showDevice'
					showDevice.selected = device
				}
			}
			BorderImage {
				source: mouseArea.pressed ? "rowBgActive.png" : "rowBg.png"
				anchors.top: parent.top
				anchors.right: parent.right
				anchors.left: parent.left
				anchors.leftMargin: 20
				anchors.rightMargin: 20
				height: 140
				border {left: 21; top: 21; right: 21; bottom: 28 }

				BorderImage {
					id: buttons
					source: "buttonBg.png"
					border {left: 15; top: 49; right: 15; bottom: 49 }
					anchors.verticalCenter: parent.verticalCenter
					anchors.left: parent.left
					anchors.leftMargin: 20
					width: 210
					height: 100
					MouseArea {
						anchors.fill: parent
					}
				}

				Column {
					anchors.verticalCenter: parent.verticalCenter
					anchors.left: buttons.right
					anchors.leftMargin: 20
					anchors.right: arrow.left
					Text {
						color: "#00659F"
						width: parent.width
						font.pixelSize: 32
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

	Item {
		id: listPage
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		anchors.right: parent.right
		width: parent.width

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

		Header {
			id: header
			anchors.topMargin: {
				if (list.contentY <= 0) {
					return 0;
				}
				if (list.contentY >= header.height) {
					return -header.height;
				}
				return -list.contentY;
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
						if (headerMenu.activeItem !== fav) {
							headerMenu.activeItem = fav
							list.positionViewAtBeginning()
							favoriteModel.doFilter = true
						}
					}
				},
				HeaderMenuItem {
					id: allDev
					title: "All devices"
					onActivated: {
						if (headerMenu.activeItem !== allDev) {
							headerMenu.activeItem = allDev
							list.positionViewAtBeginning()
							favoriteModel.doFilter = false
						}
					}
				}
			]
		}
	}

	Item {
		id: showDevice
		property Device selected
		anchors.top: parent.top
		anchors.left: listPage.right
		anchors.bottom: parent.bottom
		width: parent.width

		Header {}
		Text {
			anchors.centerIn: parent
			color: "#00659F"
			font.pixelSize: 45
			font.weight: Font.Bold
			text: showDevice.selected.name
			elide: Text.ElideRight
		}
	}

	states: [
		State {
			name: 'showDevice'
			AnchorChanges { target: listPage; anchors.right: devicePage.left }
		}
	]
	transitions: [
		Transition {
			to: 'showDevice'
			reversible: true
			AnchorAnimation { duration: 500; easing.type: Easing.InOutQuad }
		}
	]
}

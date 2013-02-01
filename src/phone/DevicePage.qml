import QtQuick 1.1
import Telldus 1.0

Item {
	id: devicePage

	Component {
		id: deviceDelegate
		Item {
			id: wrapper
			property Device dev: device
			width: list.width
			height: 150*SCALEFACTOR
			clip: false
			z: model.index
			ListView.onRemove: SequentialAnimation {
				PropertyAction { target: wrapper; property: "ListView.delayRemove"; value: true }
				PropertyAction { target: wrapper; property: "z"; value: -1 }
				NumberAnimation { target: wrapper; properties: "height,opacity"; to: 0; duration: 250; easing.type: Easing.InOutQuad }
				PropertyAction { target: wrapper; property: "ListView.delayRemove"; value: false }
			}
			ListView.onAdd: SequentialAnimation {
				PropertyAction { target: wrapper; property: "z"; value: -1 }
				ParallelAnimation {
					NumberAnimation { target: wrapper; properties: "height"; from: 0; to: 150*SCALEFACTOR; duration: 250; easing.type: Easing.InOutQuad }
					NumberAnimation { target: wrapper; properties: "opacity"; from: 0; to: 1; duration: 250; easing.type: Easing.InOutQuad }
				}
				PropertyAction { target: wrapper; property: "z"; value: 0 }
			}
			BorderImage {
				source: mouseArea.pressed ? "rowBgActive.png" : "rowBg.png"
				anchors.top: parent.top
				anchors.right: parent.right
				anchors.left: parent.left
				anchors.leftMargin: 20*SCALEFACTOR
				anchors.rightMargin: 20*SCALEFACTOR
				height: 140*SCALEFACTOR
				border {left: 21; top: 21; right: 21; bottom: 28 }

				Item {
					anchors.fill: parent
					anchors.topMargin: 2
					anchors.bottomMargin: 10

					ButtonSet {
						id: buttons
						device: wrapper.dev
						anchors.verticalCenter: parent.verticalCenter
						anchors.left: parent.left
						anchors.leftMargin: 20*SCALEFACTOR
					}

					MouseArea {
						id: mouseArea
						anchors.top: parent.top
						anchors.bottom: parent.bottom
						anchors.left: nameCol.left
						anchors.right: parent.right
						onClicked: {
							devicePage.state = 'showDevice'
							showDevice.selected = device
						}
					}

					Column {
						id: nameCol
						anchors.verticalCenter: parent.verticalCenter
						anchors.left: buttons.right
						anchors.leftMargin: 20*SCALEFACTOR
						anchors.right: arrow.left
						anchors.rightMargin: 20*SCALEFACTOR
						Text {
							color: "#00659F"
							width: parent.width
							font.pixelSize: 32*SCALEFACTOR
							font.weight: Font.Bold
							text: device.name
							elide: Text.ElideRight
						}
						Text {
							color: "#999999"
							width: parent.width
							font.pixelSize: 25*SCALEFACTOR
							text: device.clientName
							elide: Text.ElideRight
						}
					}

					Image {
						id: arrow
						source: "rowArrow.png"
						width: sourceSize.width*SCALEFACTOR
						fillMode: Image.PreserveAspectFit
						anchors.right: parent.right
						anchors.rightMargin: 20*SCALEFACTOR
						anchors.verticalCenter: parent.verticalCenter
					}
				}
			}
		}
	}

	SwipeArea {
		id: listPage
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		anchors.right: parent.right
		width: parent.width
		onSwipeLeft: mainInterface.swipeLeft()

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
			activeItem: favoriteModel.doFilter ? fav : allDev
			onActiveItemChanged: {
				list.positionViewAtBeginning()
			}

			items: [
				HeaderMenuItem {
					id: fav
					title: "Favorites"
					onActivated: favoriteModel.doFilter = true
				},
				HeaderMenuItem {
					id: allDev
					title: "All devices"
					onActivated: favoriteModel.doFilter = false
				}
			]
		}
	}

	Component {
		id: componentShowDevice
		DeviceDetails {
			onBackClicked: devicePage.state = ''
			selected: showDevice.selected
		}
	}
	Loader {
		id: showDevice
		property Device selected
		anchors.top: parent.top
		anchors.left: listPage.right
		anchors.bottom: parent.bottom
		width: parent.width
		sourceComponent: selected ? componentShowDevice : undefined
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

import QtQuick 2.0
import Telldus 1.0

Item {
	id: devicePage

	Component {
		id: deviceDelegate
		Item {
			id: wrapper
			property Device dev: device
			width: list.width
			height: 50 * SCALEFACTOR
			clip: false
			z: model.index
			ListView.onRemove: SequentialAnimation {
				PropertyAction { target: wrapper; property: "ListView.delayRemove"; value: true }
				PropertyAction { target: wrapper; property: "z"; value: -1 }
				//NumberAnimation { target: wrapper; properties: "height,opacity"; to: 0; duration: 250; easing.type: Easing.InOutQuad }
				PropertyAction { target: wrapper; property: "ListView.delayRemove"; value: false }
			}
			ListView.onAdd: SequentialAnimation {
				PropertyAction { target: wrapper; property: "z"; value: -1 }
				ParallelAnimation {
				//	NumberAnimation { target: wrapper; properties: "height"; from: 0; to: 150*SCALEFACTOR; duration: 250; easing.type: Easing.InOutQuad }
				//	NumberAnimation { target: wrapper; properties: "opacity"; from: 0; to: 1; duration: 250; easing.type: Easing.InOutQuad }
				}
				PropertyAction { target: wrapper; property: "z"; value: 0 }
			}
			BorderImage {
				source: mouseArea.pressed ? "../images/rowBgActive.png" : "../images/rowBg.png"
				anchors.top: parent.top
				anchors.left: parent.left
				anchors.leftMargin: 10 * SCALEFACTOR
				anchors.rightMargin: 10 * SCALEFACTOR
				height: wrapper.height / SCALEFACTOR * 2
				width: (wrapper.width / SCALEFACTOR * 2) - 40
				border {left: 21; top: 21; right: 21; bottom: 28 }
				scale: SCALEFACTOR / 2
				transformOrigin: Item.TopLeft
			}

			Item {
				anchors.fill: parent
				anchors.topMargin: 5 * SCALEFACTOR
				anchors.bottomMargin: 10 * SCALEFACTOR
				anchors.leftMargin: 10 * SCALEFACTOR
				anchors.rightMargin: 10 * SCALEFACTOR

				ButtonSet {
					id: buttons
					device: wrapper.dev
					anchors.verticalCenter: parent.verticalCenter
					anchors.left: parent.left
					anchors.leftMargin: 5 * SCALEFACTOR
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
					anchors.leftMargin: 10 * SCALEFACTOR
					anchors.right: arrow.left
					anchors.rightMargin: 10 * SCALEFACTOR
					Text {
						color: "#00659F"
						width: parent.width
						font.pixelSize: 16 * SCALEFACTOR
						font.weight: Font.Bold
						text: device.name
						elide: Text.ElideRight
					}
					Text {
						color: "#999999"
						width: parent.width
						font.pixelSize: 12 * SCALEFACTOR
						text: device.clientName
						elide: Text.ElideRight
					}
				}

				Image {
					id: arrow
					source: "../images/rowArrow.png"
					width: sourceSize.width * (SCALEFACTOR / 2)
					fillMode: Image.PreserveAspectFit
					anchors.right: parent.right
					anchors.rightMargin: 10 * SCALEFACTOR
					anchors.verticalCenter: parent.verticalCenter
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
		filterTouchEvent: true
		filterMouseEvent: false
		onSwipeLeft: mainInterface.swipeLeft()

		ListView {
			id: list
			header: Item {
				height: header.height + headerMenu.height + (15 * SCALEFACTOR)
				width: list.width
			}
			footer: Item {
				height: 10
				width: list.width
			}

			anchors.fill: parent
			model: favoriteModel
			delegate: deviceDelegate
			spacing: 5 * SCALEFACTOR
			maximumFlickVelocity: 1500 * SCALEFACTOR
		}

		Header {
			id: header
			anchors.topMargin: Math.min(0, Math.max(-header.height, -list.contentY-header.height-headerMenu.height- (10 * SCALEFACTOR)))
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
					onActivated: setFavoriteFilter(true)
				},
				HeaderMenuItem {
					id: allDev
					title: "All devices"
					onActivated: setFavoriteFilter(false)
				}
			]
		}
	}

	function setFavoriteFilter(doFilter) {
		favoriteModel.doFilter = doFilter
		dev.logScreenView("/device/" + (doFilter ? "favorites": "all"))
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

import QtQuick 1.1
import Telldus 1.0

Item {
	id: showDevice
	property Device selected
	signal backClicked()

	SwipeArea {
		anchors.fill: parent
		onSwipeRight: backClicked()
	}

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
		anchors.margins: 20*SCALEFACTOR
		border {left: 21; top: 21; right: 21; bottom: 28 }
		Column {
			anchors.fill: parent
			anchors.margins: 20
			spacing: 30*SCALEFACTOR
			Text {
				text: "Location: " + showDevice.selected.clientName
				color: "#999999"
				width: parent.width
				font.pixelSize: 30*SCALEFACTOR
				font.bold: Font.Bold
				elide: Text.ElideRight
			}

			Item {
				width: (parent.width - dimHandle.width*SCALEFACTOR)/SCALEFACTOR
				height: 100*SCALEFACTOR
				scale: SCALEFACTOR
				visible: selected.methods & 16
				anchors.horizontalCenter: parent.horizontalCenter
				BorderImage {
					id: dimArea
					anchors.verticalCenter: parent.verticalCenter
					source: "dimSliderBg.png"
					height: 12
					width: parent.width
					border { left: 6; top: 6; right: 6; bottom: 5 }
					Image {
						id: dimHandle
						source: "dimSliderButton.png"
						anchors.verticalCenter: parent.verticalCenter
						x: (selected.stateValue / 255) * dimArea.width - (dimHandle.width/2)
						Connections {
							target: selected
							onStateValueChanged: {
								dimHandle.x = (stateValue / 255) * dimArea.width - (dimHandle.width/2)
							}
						}
						MouseArea {
							anchors.fill: parent
							anchors.margins: -parent.height  // Make sure the target area is bigger
							drag.target: dimHandle
							drag.axis: Drag.XAxis
							drag.minimumX: -dimHandle.width/2
							drag.maximumX: dimArea.width - (dimHandle.width/2)
							onReleased: {
								var value = Math.round((dimHandle.x + dimHandle.width/2) / dimArea.width * 255);
								selected.dim(value)
							}
						}
					}
				}
			}

			Repeater {
				model: ListModel {
					ListElement { set: 0; req: 1 }
					ListElement { set: 1; req: 384 }
					ListElement { set: 2; req: 4 }
					ListElement { set: 3; req: 32 }
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
				width: parent.width
				height: childrenRect.height
				Image {
					id: iconFavorite
					source: showDevice.selected.isFavorite ? "iconFavouriteActive.png" : "iconFavourite.png"
					height: sourceSize.height*SCALEFACTOR;
					width: sourceSize.width*SCALEFACTOR;
					smooth: true
				}
				Item {
					height: iconFavorite.height
					anchors.left: iconFavorite.right
					anchors.leftMargin: 20*SCALEFACTOR
					anchors.right: parent.right
					Item {
						anchors.verticalCenter: parent.verticalCenter
						anchors.left: parent.left
						anchors.right: parent.right
						height: childrenRect.height
						Behavior on height { NumberAnimation { duration: 200 } }
						Text {
							id: favText
							anchors.left: parent.left
							anchors.right: parent.right
							wrapMode: Text.WordWrap
							text: showDevice.selected.isFavorite ? "Device is in Your Favorites" : "Add device to Your Favorites"
							color: showDevice.selected.isFavorite ? "#00659F" : "#999999"
							font.pixelSize: 30 * SCALEFACTOR
							font.weight: Font.Bold
						}
						Text {
							anchors.top: favText.bottom
							text: "Tap to remove"
							color: "#00659F"
							font.pixelSize: 16 * SCALEFACTOR
							font.weight: Font.Bold
							height: showDevice.selected.isFavorite ? undefined : 0
							opacity: showDevice.selected.isFavorite ? 1 : 0
							Behavior on opacity { NumberAnimation { duration: 200 } }
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

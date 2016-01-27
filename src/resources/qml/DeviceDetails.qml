import QtQuick 2.4
import QtGraphicalEffects 1.0
import Telldus 1.0
import Tui 0.1

Rectangle {
	id: showDevice
	property Device selected
	signal backClicked()

	color: "#ffffff"
	focus: true;

	Keys.onPressed: {
		if (properties.ui.supportsKeys) {
			if (event.key == Qt.Key_Left) {
				showDevice.backClicked()
				event.accepted = true;
			}
			if (event.key == Qt.Key_Enter) {
				showDevice.selected.isFavorite = !showDevice.selected.isFavorite;
				event.accepted = true;
			}
		}
	}
	Item {
		anchors.fill: parent
		anchors.topMargin: Units.dp(10)

		Column {
			anchors.fill: parent
			anchors.margins: Units.dp(10)
			spacing: Units.dp(20)
			Text {
				text: "Location: " + showDevice.selected.clientName
				color: properties.theme.colors.telldusBlue
				width: parent.width
				font.pixelSize: Units.dp(16)
				elide: Text.ElideRight
			}

			Item {
				id: dimmer
				width: parent.width
				height: Units.dp(56)
				visible: selected.methods & 16
				anchors.horizontalCenter: parent.horizontalCenter

				MouseArea {
					anchors.fill: parent
					onClicked: {
						selected.dim(Math.round(mouse.x / width * 255));
					}
				}

				Card {
					id: dimArea
					anchors.verticalCenter: parent.verticalCenter
					anchors.left: parent.left
					anchors.right: parent.right
					anchors.margins: Units.dp(4)
					height: Units.dp(8)
					tintColor: "#616161"

					Rectangle {
						color: "#BDBDBD"
						anchors.fill: parent
						anchors.margins: Units.dp(1)
						radius: dimArea.radius
					}

					Rectangle {
						color: "#FFCA28"
						anchors.fill: parent
						anchors.margins: Units.dp(1)
						radius: dimArea.radius
						opacity: dimHandle.x / dimWidth.width
					}
				}
				Item {
					id: dimWidth
					anchors.verticalCenter: parent.verticalCenter
					anchors.left: parent.left
					anchors.right: parent.right
					anchors.leftMargin: dimHandle.width / 2
					anchors.rightMargin: dimHandle.width / 2
					Rectangle {
						id: dimHandle
						width: Units.dp(32)
						height: width
						radius: height / 2
						anchors.verticalCenter: parent.verticalCenter
						x: (selected.stateValue / 255) * dimWidth.width - (dimHandle.width/2)
						color: properties.theme.colors.telldusBlue
						Image {
							id: dimHandleImage
							anchors.fill: parent
							source: "../svgs/deviceIconDim.svg"
							asynchronous: true
							smooth: true
							sourceSize.width: width * 2
							sourceSize.height: height * 2
							anchors.verticalCenter: parent.verticalCenter
							Connections {
								target: selected
								onStateValueChanged: {
									dimHandle.x = (stateValue / 255) * dimWidth.width - (dimHandle.width/2)
								}
							}
						}
					}
					MouseArea {
						anchors.fill: dimHandle
						anchors.margins: -parent.height  // Make sure the target area is bigger
						drag.target: dimHandle
						drag.axis: Drag.XAxis
						drag.minimumX: -dimHandle.width/2
						drag.maximumX: dimWidth.width - (dimHandle.width/2)
						onReleased: {
							var value = Math.round((dimHandle.x + dimHandle.width/2) / dimWidth.width * 255);
							selected.dim(value)
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
				height: Units.dp(32)
				Image {
					id: iconFavorite
					height: parent.height * 0.6
					width: height
					source: "image://icons/favourite/" + properties.theme.colors.telldusOrange
					smooth: true
					fillMode: Image.PreserveAspectFit
					sourceSize.width: width * 2
					sourceSize.height: height * 2
					opacity: showDevice.selected.isFavorite ? 1 : 0.2
				}
				Item {
					height: iconFavorite.height
					anchors.left: iconFavorite.right
					anchors.leftMargin: Units.dp(10)
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
							text: showDevice.selected.isFavorite ? "Device is shown on the dashboard" : "Tap to show device on dashboard"
							color: properties.theme.colors.telldusBlue
							font.pixelSize: Units.dp(14)
						}
						Text {
							anchors.top: favText.bottom
							text: "Tap to remove"
							color: properties.theme.colors.telldusBlue
							font.pixelSize: Units.dp(10)
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

	function updateHeader() {
		header.title = showDevice.selected.name;
		header.editButtonVisible = false;
		header.backVisible = true
		header.backClickedMethod = function() {
			showDevice.backClicked()
		}
	}
}

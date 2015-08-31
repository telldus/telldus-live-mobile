import QtGraphicalEffects 1.0
import QtQuick 2.0
import Telldus 1.0

Item {
	id: devicePage
	property bool showEditButtons: false

	Component {
		id: deviceDelegate
		Rectangle {
			color: "#eeeeee"
			height: wrapper.height
			width: parent.width

			Rectangle {
				id: wrapper
				property Device dev: device
				state: showEditButtons ? 'showEditButtons' : ''
				width: devicePage.width
				height: Math.max(buttons.height, nameCol.height, arrow.height) + (20 * SCALEFACTOR)
				clip: false
				//color: index % 2 == 0 ? "#ffffff" : "#eaeaea"
				color: "#ffffff"
				z: model.index
				anchors.left: parent.left
				anchors.leftMargin: 0
				anchors.top: parent.top
				ListView.onRemove: SequentialAnimation {
					PropertyAction { target: wrapper; property: "ListView.delayRemove"; value: true }
					PropertyAction { target: wrapper; property: "z"; value: -1 }
	//				NumberAnimation { target: wrapper; properties: "height,opacity"; to: 0; duration: 250; easing.type: Easing.InOutQuad }
					PropertyAction { target: wrapper; property: "ListView.delayRemove"; value: false }
				}
				ListView.onAdd: SequentialAnimation {
					PropertyAction { target: wrapper; property: "z"; value: -1 }
					ParallelAnimation {
	//					NumberAnimation { target: wrapper; properties: "height"; from: 0; to: 150; duration: 250; easing.type: Easing.InOutQuad }
	//					NumberAnimation { target: wrapper; properties: "opacity"; from: 0; to: 1; duration: 250; easing.type: Easing.InOutQuad }
					}
					PropertyAction { target: wrapper; property: "z"; value: 0 }
				}
				ButtonSet {
					id: buttons
					device: wrapper.dev
					anchors.verticalCenter: parent.verticalCenter
					anchors.left: parent.left
					anchors.leftMargin: 10 * SCALEFACTOR
				}
				Column {
					id: nameCol
					anchors.verticalCenter: parent.verticalCenter
					anchors.left: buttons.right
					anchors.leftMargin: 10 * SCALEFACTOR
					anchors.right: arrow.left
					Text {
						color: properties.theme.colors.telldusBlue
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
				MouseArea {
					id: mouseArea
					anchors.left: buttons.right
					anchors.top: parent.top
					anchors.right: parent.right
					anchors.bottom: parent.bottom
					onClicked: {
						devicePage.state = 'showDevice'
						showDevice.selected = device
					}
				}
				Item {
					id: arrow
					anchors.right: wrapper.right
					anchors.verticalCenter: parent.verticalCenter
					height: buttons.height / 2
					width: buttons.height
					Image {
						id: arrowImage
						anchors.fill: parent
						source: "../svgs/iconArrowRight.svg"
						smooth: true
						fillMode: Image.PreserveAspectFit
						sourceSize.width: width * 2
						sourceSize.height: height * 2
					}
				}
				MouseArea {
					anchors.fill: parent
					enabled: showEditButtons
					onClicked: {
						devicePage.showEditButtons = false
					}
				}
				states: [
					State {
						name: 'showEditButtons'
						PropertyChanges { target: wrapper; anchors.leftMargin: (50 * SCALEFACTOR) * (underMenu.children.length - 1) }
					}
				]
				transitions: [
					Transition {
						to: 'showEditButtons'
						reversible: true
						PropertyAnimation { property: "anchors.leftMargin";  duration: 300; easing.type: Easing.InOutQuad }
					}
				]
			}
			Rectangle {
				id: underMenu
				anchors.right: wrapper.left
				anchors.top: parent.top
				anchors.left: parent.left
				anchors.bottom: parent.bottom
				color: "#f8f8f8"
				clip: true
				Item {
					id: favouriteButton
					height: parent.height
					width: 50 * SCALEFACTOR
					anchors.left: parent.left
					anchors.top: parent.top
					Image {
						id: favouriteButtonImage
						anchors.centerIn: parent
						height: 30 * SCALEFACTOR
						width: height
						source: "image://icons/favourite/" + properties.theme.colors.telldusOrange
						smooth: true
						fillMode: Image.PreserveAspectFit
						sourceSize.width: width * 2
						sourceSize.height: height * 2
						opacity: device.isFavorite ? 1 : 0.2
					}
					MouseArea {
						anchors.fill: parent
						onClicked: device.isFavorite = !device.isFavorite
					}
				}
/* Prototype for 2nd button				Item {
					id: editButton2
					height: parent.height
					width: editButton2.height
					anchors.left: editButton1.right
					anchors.top: parent.top
					Image {
						anchors.centerIn: parent
						source: device.isFavorite ? "../images/iconFavouriteActive.png" : "../images/iconFavourite.png"
						height: 30 * SCALEFACTOR
						width: 30 * SCALEFACTOR
						smooth: true
					}
					MouseArea {
						anchors.fill: parent
						onClicked: device.isFavorite = !device.isFavorite
					}
				}*/
				LinearGradient {
					anchors.top: parent.top
					anchors.right: parent.right
					anchors.bottom: parent.bottom
					width: 3 * SCALEFACTOR
					start: Qt.point(0, 0)
					end: Qt.point(3 * SCALEFACTOR, 0)
					gradient: Gradient {
						GradientStop { position: 0.0; color: "#00999999" }
						GradientStop { position: 1.0; color: "#80999999" }
					}
				}
			}
		}
	}
	Rectangle {
		id: listPage
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		anchors.right: parent.right
		width: parent.width
		color: "#80999999"
		ListView {
			id: list
			anchors.fill: parent
			anchors.topMargin: screen.isPortrait ? header.height : 0
			anchors.leftMargin: screen.isPortrait ? 0 : header.width
			model: deviceModel
			delegate: deviceDelegate
			maximumFlickVelocity: 1500 * SCALEFACTOR
			spacing: 1 * SCALEFACTOR
		}
		Header {
			id: header
			title: "Devices"
			editButtonVisible: true
			onEditClicked: showEditButtons = !showEditButtons;
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

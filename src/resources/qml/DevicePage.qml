import QtGraphicalEffects 1.0
import QtQuick 2.0
import Telldus 1.0
import Tui 0.1

Item {
	id: devicePage
	property bool showEditButtons: false

	Component {
		id: deviceDelegate
		Rectangle {
			color: "#EEEEEE"
			height: wrapper.height
			width: list.width

			Rectangle {
				id: wrapper
				property Device dev: device
				state: showEditButtons ? 'showEditButtons' : ''
				width: list.width
				height: Units.dp(72)
				clip: false
				color: "#ffffff"
				z: model.index
				anchors.left: parent.left
				anchors.leftMargin: 0
				anchors.top: parent.top
				Rectangle {
					id: divider
					anchors.left: parent.left
					anchors.right: parent.right
					anchors.bottom: parent.bottom
					height: Units.dp(1)
					color: "#F5F5F5"
				}
				ButtonSet {
					id: buttons
					device: wrapper.dev
					anchors.verticalCenter: parent.verticalCenter
					anchors.left: parent.left
					anchors.leftMargin: Units.dp(16)
					height: Units.dp(40)
					width: Units.dp(100)
				}
				Column {
					id: nameCol
					anchors.verticalCenter: parent.verticalCenter
					anchors.left: buttons.right
					anchors.leftMargin: Units.dp(16)
					anchors.right: arrow.left
					anchors.rightMargin: Units.dp(16)
					Text {
						color: properties.theme.colors.telldusBlue
						width: parent.width
						font.pixelSize: Units.dp(16)
						text: device.name
						elide: Text.ElideRight
					}
					Text {
						color: "#999999"
						width: parent.width
						font.pixelSize: Units.dp(14)
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
					anchors.rightMargin: Units.dp(16)
					anchors.verticalCenter: parent.verticalCenter
					height: Units.dp(24)
					width: Units.dp(24 * 0.57)
					Image {
						id: arrowImage
						anchors.fill: parent
						source: "../svgs/iconArrowRight.svg"
						asynchronous: true
						smooth: true
						fillMode: Image.PreserveAspectCrop
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
						PropertyChanges { target: wrapper; anchors.leftMargin: Units.dp(72) * (underMenu.children.length - 1) }
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
				color: "#F5F5F5"
				clip: true
				Item {
					id: favouriteButton
					height: parent.height
					width: Units.dp(72)
					anchors.left: parent.left
					anchors.top: parent.top
					Image {
						id: favouriteButtonImage
						anchors.centerIn: parent
						height: Units.dp(36)
						width: height
						source: "image://icons/favourite/" + properties.theme.colors.telldusOrange
						asynchronous: true
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
				LinearGradient {
					anchors.top: parent.top
					anchors.right: parent.right
					anchors.bottom: parent.bottom
					width: Units.dp(3)
					start: Qt.point(0, 0)
					end: Qt.point(Units.dp(3), 0)
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
		color: "#F5F5F5"
		ListView {
			id: list
			anchors.left: screen.showHeaderAtTop ? parent.left : header.right
			anchors.top: screen.showHeaderAtTop ? header.bottom : parent.top
			anchors.right: parent.right
			anchors.bottom: parent.bottom
			model: deviceModel
			delegate: deviceDelegate
			maximumFlickVelocity: Units.dp(1500)
			spacing: Units.dp(0)
		}
		Header {
			id: header
			title: "Devices"
			editButtonVisible: true
			onEditClicked: showEditButtons = !showEditButtons;
			onBackClicked: {
				if (devicePage.state == 'showDevice') {
					devicePage.state = ''
				} else {
					if (showEditButtons) {
						showEditButtons = false;
					} else {
						mainInterface.setActivePage(0);
					}
				}
			}
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

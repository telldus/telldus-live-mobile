import QtQuick 2.4
import QtQuick.Window 2.2
import Tui 0.1

Item {
	height: UI_PLATFORM == "android" ? (clientModel.count * Units.dp(48)) - Units.dp(8) : clientModel.count * Units.dp(40)
	Component {
		id: clientListItem
		Rectangle {
			width: parent.width
			height: Units.dp(40)
			color: index ==  clientList.selectedIndex && properties.ui.supportsKeys ? properties.theme.colors.telldusOrange : "transparent"
			Item {
				id: clientStatusIcon
				anchors.left: parent.left
				anchors.leftMargin: Units.dp(16)
				anchors.verticalCenter: parent.verticalCenter
				height: Units.dp(32)
				width: height
				Image {
					id: clientStatusIconImage
					anchors.fill: parent
					anchors.margins: Units.dp(8)
					source: "image://icons/devices/" + (client.online ? (client.websocketConnected ? (UI_PLATFORM == "android" ? "#2E7D32" : "#00C853") : (UI_PLATFORM == "android" ? "#F57F17" : "#FFD600")) : (UI_PLATFORM == "android" ? "#B71C1C" : "#D50000"))
					asynchronous: true
					smooth: true
					fillMode: Image.PreserveAspectFit
					sourceSize.width: width * 2
					sourceSize.height: height * 2
				}
			}
			Text {
				id: clientName
				color: UI_PLATFORM == "android" ? "#616161" : "#ffffff";
				font.pixelSize: Units.dp(14)
				text: client.name
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: parent.left
				anchors.leftMargin: Units.dp(56)
			}
/*			MouseArea {
				id: mouseArea
				anchors.fill: parent
				onClicked: {
					overlayPage.title = client.name
					overlayPage.icon = 'devices'
					overlayPage.source = Qt.resolvedUrl("ClientDetails.qml");
					overlayPage.childObject = client
				}
			}*/
		}
	}
/*	Component {
		id: clientListHeader
		Item {
			height: Units.dp(20)
			width: parent.width
			y: -clientList.contentY - height

			property bool refresh: state == "pulled" ? true : false

			Item {
				id: arrow
				anchors.fill: parent
				Image {
					id: arrowImage
					visible: !clientListRefreshTimer.running
					anchors.centerIn: parent
					height: parent.height * 0.8
					width: height
					source: "image://icons/refreshArrow/#999999"
					asynchronous: true
					smooth: true
					fillMode: Image.PreserveAspectFit
					sourceSize.width: width * 2
					sourceSize.height: height * 2
				}
				Image {
					id: arrowImageRunning
					visible: clientListCloseTimer.running
					anchors.centerIn: parent
					height: parent.height * 0.8
					width: height
					source: "image://icons/refresh/#999999"
					asynchronous: true
					smooth: true
					fillMode: Image.PreserveAspectFit
					sourceSize.width: width * 2
					sourceSize.height: height * 2
					transformOrigin: Item.Center
					RotationAnimation on rotation {
						loops: Animation.Infinite
						from: 0
						to: 360
						duration: 1000
						running: clientListCloseTimer.running
					}
				}
				transformOrigin: Item.Center
				Behavior on rotation { NumberAnimation { duration: 200 } }
			}
			Text {
				anchors.centerIn: parent
				visible: clientListRefreshTimer.running && !clientListCloseTimer.running
				color: "#ffffff"
				font.pixelSize: Units.dp(10)
				text: "You can refresh once every 10 seconds."
				elide: Text.ElideRight
			}
			states: [
				State {
					name: "base"; when: clientList.contentY >= -Units.dp(40)
					PropertyChanges { target: arrow; rotation: 180 }
				},
				State {
					name: "pulled"; when: clientList.contentY < -Units.dp(40)
					PropertyChanges { target: arrow; rotation: 0 }
				}
			]
		}
	}*/
	Item {
		id: clientListContainer
		anchors.fill: parent
		ListView {
			id: clientList
			anchors.fill: parent
			//anchors.topMargin: clientListCloseTimer.running ? 0 : -clientList.headerItem.height
			model: clientModel
			delegate: clientListItem
			maximumFlickVelocity: Units.dp(1500)
			spacing: UI_PLATFORM == "android" ? Units.dp(8) : Units.dp(0)
//			header: clientListHeader
			pressDelay: 100
			onDragEnded: {
				if (headerItem.refresh && !clientListRefreshTimer.running) {
					clientModel.authorizationChanged()
					clientListRefreshTimer.start()
					clientListCloseTimer.start()
				}
			}
		}
	}
	Timer {
		id: clientListCloseTimer
		interval: 1000
		running: false
		repeat: false
	}
	Timer {
		id: clientListRefreshTimer
		interval: 10000
		running: false
		repeat: false
	}
}

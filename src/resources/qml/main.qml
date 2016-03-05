import QtQuick 2.4
import QtQuick.Window 2.2
import Tui 0.1

Rectangle {
	id: screen

	property bool isPortrait: width <= height
	property bool showHeaderAtTop: width == 0 || height == 0 || (width <= height) || (Units.dp(56) < height * 0.1)

	Component.onCompleted: {
		console.log("[UI] Platform: " + UI_PLATFORM);
		console.log("[UI] Supports touch: " + properties.ui.supportsTouch);
		console.log("[UI] Supports keys: " + properties.ui.supportsKeys);
	}

	Loader {
		id: mainInterfaceLoader
		opacity: telldusLive.isAuthorized ? 1 : 0
		anchors.fill: parent
		source: opacity > 0 ? "MainInterface.qml" : ''
	}

	Loader {
		id: loader_loginScreen
		anchors.fill: parent
		opacity: telldusLive.isAuthorized ? 0 : 1
		source: opacity > 0  ? "LoginScreen.qml" : ''
		onSourceChanged: {
			if (opacity > 0) {
				overlayPage.state = 'closeInstantly'
			}
		}
	}

	Rectangle {
		id: overlayBackground
		anchors.fill: parent
		color: "#000000"
		opacity: 0
		MouseArea {
			id: overlayBackgroundMouseArea
			anchors.fill: parent
			enabled: overlayBackground.opacity > 0
			propagateComposedEvents: false
		}
	}

	Item {
		id: overlayPage
		height: screen.height
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: parent.top
		opacity: 0

		property var source: ''
		property alias title: overlayHeaderText.text
		property var icon: ''
		property var childObject: ''
		onSourceChanged: {
			overlayLoader.active = true;
			overlayLoader.source = source;
		}

		Card {
			id: overlayCard
			anchors.fill: parent
			anchors.leftMargin: Units.dp(24)
			anchors.rightMargin: Units.dp(24)
			anchors.bottomMargin: Units.dp(24)
			anchors.topMargin: (UI_PLATFORM == 'ios' ? Screen.height - Screen.desktopAvailableHeight : 0) + Units.dp(24)
			SwipeArea {
				anchors.fill: parent
				preventStealing: false
				onSwipe: {
					switch (direction) {
					case "up":
						overlayPage.state = '';
						break
					}
				}
			}
			Rectangle {
				id: overlayHeader
				anchors.left: parent.left
				anchors.right: parent.right
				height: Units.dp(56)
				color: properties.theme.colors.telldusBlue
				Item {
					id: overlayHeaderIcon
					anchors.left: parent.left
					anchors.leftMargin: Units.dp(8)
					anchors.verticalCenter: parent.verticalCenter
					height: Units.dp(32)
					width: Units.dp(32)
					Image {
						id: overlayHeaderIconImage
						anchors.fill: parent
						anchors.margins: Units.dp(4)
						source: "image://icons/" + overlayPage.icon + "/#ffffff";
						asynchronous: true
						smooth: true
						fillMode: Image.PreserveAspectFit
						sourceSize.width: width * 2
						sourceSize.height: height * 2
					}
				}
				Text {
					id: overlayHeaderText
					color: "#ffffff"
					font.pixelSize: Units.dp(20)
					text: ''
					anchors.verticalCenter: parent.verticalCenter
					anchors.left: parent.left
					anchors.leftMargin: Units.dp(48)
				}
				Item {
					id: overlayRightButton
					height: overlayHeader.height
					width: height
					anchors.bottom: parent.bottom
					anchors.right: parent.right
					clip: true
					Item {
						id: overlayCloseButton
						anchors.centerIn: parent
						height: parent.height * 0.3
						width: height
						Image {
							id: overlayCloseButtonImage
							anchors.centerIn: parent
							height: parent.height
							width: height
							source: "image://icons/close/#ffffff"
							asynchronous: true
							smooth: true
							fillMode: Image.PreserveAspectFit
							sourceSize.width: width * 2
							sourceSize.height: height * 2
						}
					}
					MouseArea {
						id: overlayCloseButtonMouseArea
						anchors.fill: parent
						onClicked: {
							overlayPage.state = 'closeInstantly'
						}
					}
				}
			}
			Loader {
				id: overlayLoader
				anchors.left: parent.left
				anchors.top: overlayHeader.bottom
				anchors.right: parent.right
				anchors.bottom: parent.bottom
				onLoaded: {
					overlayPage.state = 'visible';
				}
				onActiveChanged: {
					source = ''
				}
			}
		}
		states: [
			State {
				name: ''
				PropertyChanges {
					target: overlayLoader
					active: false
				}
			},
			State {
				name: 'visible'
				AnchorChanges {
					target: overlayPage
					anchors.bottom: overlayPage.parent.bottom
				}
				PropertyChanges {
					target: overlayPage
					opacity: 1
				}
				PropertyChanges {
					target: overlayBackground
					opacity: 0.6
				}
			},
			State {
				name: 'closeInstantly'
				AnchorChanges {
					target: overlayPage
					anchors.bottom: overlayPage.parent.top
				}
				PropertyChanges {
					target: overlayPage
					opacity: 0
				}
				PropertyChanges {
					target: overlayLoader
					active: false
				}
				PropertyChanges {
					target: overlayBackground
					opacity: 0
				}
			}
		]

		transitions: [
			Transition {
				to: 'visible'
				AnchorAnimation {
					duration: 250
				}
				PropertyAnimation {
					target: overlayBackground
					properties: 'opacity'
					duration: 250
				}
			},
			Transition {
				from: 'visible'
				to: 'closeInstantly'
				SequentialAnimation {
					PropertyAnimation {
						target: overlayBackground
						properties: 'opacity'
						duration: 0
					}
					SequentialAnimation {
						PropertyAnimation {
							properties: 'opacity'
							duration: 150
						}
						AnchorAnimation {
						}
					}
					PropertyAction {
						target: overlayLoader
						properties: 'active'
					}
				}
			},
			Transition {
				from: 'visible'
				to: ''
				PropertyAnimation {
					target: overlayBackground
					properties: 'opacity'
					duration: 250
				}
				SequentialAnimation {
					AnchorAnimation {
						duration: 250
					}
					PropertyAnimation {
						properties: 'opacity'
					}
					PropertyAction {
						target: overlayLoader
						properties: 'active'
					}
				}
			}
		]
	}

	OverlayDimmer {
		id: overlayDimmer
	}

}

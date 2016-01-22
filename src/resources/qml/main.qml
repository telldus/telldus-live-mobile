import QtQuick 2.4
import QtQuick.Window 2.2
import QtQuick.LocalStorage 2.0
import Tui 0.1

Rectangle {
	id: screen

	property bool isPortrait: width <= height
	property bool showHeaderAtTop: (width <= height) || (Units.dp(56) < height * 0.1)

	Component.onCompleted: {
		console.log("[UI] Platform: " + UI_PLATFORM);
		console.log("[UI] Supports touch: " + properties.ui.supportsTouch);
		console.log("[UI] Supports keys: " + properties.ui.supportsKeys);
	}

	ListModel {
		id: pageModel

		property var selectedIndex: 0

		ListElement {
			title: "Dashboard"
			page: "DashboardPage.qml"
			inDrawer: false
			inTabBar: true
		}
		ListElement {
			title: "Devices"
			page: "DevicePage.qml"
			inDrawer: false
			inTabBar: true
		}
		ListElement {
			title: "Sensors"
			page: "SensorPage.qml"
			inDrawer: false
			inTabBar: true
		}
		ListElement {
			title: "Scheduler"
			page: "SchedulerPage.qml"
			inDrawer: false
			inTabBar: true
		}
		ListElement {
			title: "Settings"
			page: "SettingsPage.qml"
			inDrawer: true
			inTabBar: false
		}
		ListElement {
			title: "Debug"
			page: "DebugPage.qml"
			inDrawer: false
			inTabBar: false
		}
	}

	Rectangle {
		id: mainInterface
		property bool menuViewVisible: false
		opacity: telldusLive.isAuthorized ? 1 : 0
		color: "#404040";
		anchors.fill: parent

		Rectangle {
			id: menuViewUnderlay
			visible: mainInterface.menuViewVisible
			anchors.fill: parent
			color: "#000000"
			opacity: (menuViewTranslate.x / menuView.width) * 0.5
			z: UI_PLATFORM == 'android' ? mainView.z + 1 : mainView.z - 2

			MouseArea {
				anchors.fill: parent
				onClicked: {
					mainInterface.closeMenu();
				}
			}
		}

		View {
			id: menuView
			anchors.top: parent.top
			anchors.topMargin: UI_PLATFORM == 'ios' ? Screen.height - Screen.desktopAvailableHeight : 0
			anchors.bottom: parent.bottom
			anchors.left: UI_PLATFORM == "android" ? undefined : parent.left
			width: Math.min((screen.showHeaderAtTop ? mainInterface.width : mainInterface.height) * 0.8, Units.dp(288))
			tintColor:  UI_PLATFORM == "android" ? "#ffffff" : "#212121";
			x: -width - Units.dp(50)
			z: UI_PLATFORM == 'android' ? mainView.z + 2 : mainView.z - 1
			transform: UI_PLATFORM == "android" ? menuViewTranslate : undefined
			elevation: UI_PLATFORM == "android" ? 4 : 0

			Translate {
				id: menuViewTranslate
				x: 0
				Behavior on x { NumberAnimation { duration: 300; easing.type: Easing.OutQuad } }
			}

			Component {
				id: mainMenuItem
				Rectangle {
					visible: inDrawer
					width: parent.width
					height: inDrawer ? Units.dp(56) : 0
					color: index ==  pageModel.selectedIndex && properties.ui.supportsKeys ? properties.theme.colors.telldusOrange : "transparent"
					Item {
						id: dashboardIcon
						anchors.left: parent.left
						anchors.leftMargin: Units.dp(16)
						anchors.verticalCenter: parent.verticalCenter
						height: Units.dp(32)
						width: Units.dp(32)
						Image {
							id: dashboardIconImage
							anchors.fill: parent
							anchors.margins: Units.dp(4)
							source: "image://icons/" + title.toLowerCase() + "/" + (UI_PLATFORM == "android" ? properties.theme.colors.telldusBlue : "#ffffff");
							asynchronous: true
							smooth: true
							fillMode: Image.PreserveAspectFit
							sourceSize.width: width * 2
							sourceSize.height: height * 2
						}
					}
					Text {
						id: dashboardButton
						color: UI_PLATFORM == "android" ? properties.theme.colors.telldusBlue : "#ffffff"
						font.pixelSize: Units.dp(20)
						text: title
						anchors.verticalCenter: parent.verticalCenter
						anchors.left: parent.left
						anchors.leftMargin: Units.dp(56)
					}
					MouseArea {
						anchors.fill: parent
						onClicked: {
							pageModel.selectedIndex = index;
							mainInterface.closeMenu();
						}
					}
				}
			}
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
				}
			}
			Item {
				id: clientListTitle
				anchors.top:  UI_PLATFORM == "android" ? menuUserDetailsAndroid.bottom : menuUserDetails.bottom
				anchors.topMargin: UI_PLATFORM == "android" ? Units.dp(16) : undefined
				anchors.left: parent.left
				anchors.right: parent.right
				height: Units.dp(56)
				Item {
					id: clientListTitleIcon
					anchors.left: parent.left
					anchors.leftMargin: Units.dp(16)
					anchors.verticalCenter: parent.verticalCenter
					height: Units.dp(32)
					width: Units.dp(32)
					Image {
						id: clientListTitleImage
						anchors.fill: parent
						anchors.margins: Units.dp(4)
						source: "image://icons/house/" + (UI_PLATFORM == "android" ? properties.theme.colors.telldusBlue : "#ffffff")
						asynchronous: true
						smooth: true
						fillMode: Image.PreserveAspectFit
						sourceSize.width: width * 2
						sourceSize.height: height * 2
					}
				}
				Text {
					id: clientListTitleText
					color: UI_PLATFORM == "android" ? properties.theme.colors.telldusBlue : "#ffffff"
					font.pixelSize: Units.dp(20)
					text: "Connected locations"
					anchors.verticalCenter: parent.verticalCenter
					anchors.left: parent.left
					anchors.leftMargin: Units.dp(56)
				}
			}
			Component {
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
			}
			Item {
				id: clientListContainer
				anchors.top: clientListTitle.bottom
				anchors.left: parent.left
				anchors.right: parent.right
				height: UI_PLATFORM == "android" ? (clientModel.count * Units.dp(48)) - Units.dp(8) : clientModel.count * Units.dp(40)
				clip: true
				ListView {
					id: clientList
					anchors.fill: parent
					anchors.topMargin: clientListCloseTimer.running ? 0 : -clientList.headerItem.height
					model: clientModel
					delegate: clientListItem
					maximumFlickVelocity: Units.dp(1500)
					spacing: UI_PLATFORM == "android" ? Units.dp(8) : Units.dp(0)
					header: clientListHeader
					onDragEnded: {
						if (headerItem.refresh && !clientListRefreshTimer.running) {
							console.log("Refreshing ClientModel")
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
			ListView {
				id: mainMenu
				anchors.top: clientListContainer.bottom
				anchors.left: parent.left
				anchors.right: parent.right
				anchors.bottom: parent.bottom
				model: pageModel
				delegate: mainMenuItem
				maximumFlickVelocity: Units.dp(1500)
				spacing: Units.dp(0)

				Keys.onPressed: {
					if (properties.ui.supportsKeys) {
						if (event.key == Qt.Key_Up) {
							console.log("Key up");
							if (pageModel.selectedIndex > 0) {
								pageModel.selectedIndex --;
							}
							event.accepted = true;
						}
						if (event.key == Qt.Key_Down) {
							console.log("Key down");
							if (pageModel.selectedIndex + 1 < pageModel.count) {
								pageModel.selectedIndex ++;
							}
							event.accepted = true;
						}
						if (event.key == Qt.Key_Enter || event.key == Qt.Key_Right) {
							mainInterface.closeMenu();
							event.accepted = true;
						}
						if (event.key == Qt.Key_Left) {
							// beep
							event.accepted = true;
						}
					}
				}
			}
			Item {
				id: menuUserDetails
				visible: !(UI_PLATFORM == "android")
				anchors.left: parent.left
				anchors.top: parent.top
				anchors.right: parent.right
				height: Units.dp(72)
				Rectangle {
					id: menuUserDetailsDivider
					anchors.left: parent.left
					anchors.leftMargin: Units.dp(72)
					anchors.right: parent.right
					anchors.bottom: parent.bottom
					anchors.bottomMargin: Units.dp(20)
					height: Units.dp(1)
					color: "#BDBDBD"
				}
				Rectangle {
					id: menuUserDetailsInitialsBox
					anchors.left: parent.left
					anchors.leftMargin: Units.dp(12)
					anchors.verticalCenter: parent.verticalCenter
					color: properties.theme.colors.telldusOrange
					width: Units.dp(40)
					height: width
					radius: Units.dp(4)
					Text {
						id: menuUserDetailsInitials
						anchors.centerIn: parent
						text: user.firstname.charAt(0) + user.lastname.charAt(0)
						font.pixelSize: Units.dp(20)
						color: "#ffffff"
					}

				}
				Text {
					anchors.left: parent.left
					anchors.leftMargin: Units.dp(72)
					anchors.verticalCenter: parent.verticalCenter
					text: user.firstname + " " + user.lastname
					width: parent.width
					wrapMode: Text.WordWrap
					font.pixelSize: Units.dp(16)
					color: "#ffffff"
				}
			}
			Rectangle {
				id: menuUserDetailsAndroid
				visible: UI_PLATFORM == "android"
				anchors.left: parent.left
				anchors.top: parent.top
				anchors.right: parent.right
				height: Units.dp(108)
				color: properties.theme.colors.telldusBlue
				Rectangle {
					id: menuUserDetailsAndroidInitialsBox
					anchors.top: parent.top
					anchors.topMargin: Units.dp(20)
					anchors.horizontalCenter: parent.horizontalCenter
					color: properties.theme.colors.telldusOrange
					width: Units.dp(40)
					height: width
					radius: Units.dp(4)
					Text {
						id: menuUserDetailsAndroidInitials
						anchors.centerIn: parent
						text: user.firstname.charAt(0) + user.lastname.charAt(0)
						font.pixelSize: Units.dp(20)
						color: "#ffffff"
					}

				}
				Text {
					anchors.top: menuUserDetailsAndroidInitialsBox.bottom
					anchors.topMargin: Units.dp(12)
					anchors.horizontalCenter: parent.horizontalCenter
					text: user.firstname + " " + user.lastname
					wrapMode: Text.WordWrap
					font.pixelSize: Units.dp(16)
					color: "#ffffff"
				}
			}
		}
		View {
			id: mainView
			anchors.fill: parent
			elevation: UI_PLATFORM == "android" ? 0 : 4
			tintColor: properties.theme.colors.dashboardBackground
			transform: UI_PLATFORM == "android" ? undefined : mainViewTranslate
			z: 100

			Translate {
				id: mainViewTranslate
				x: 0
				Behavior on x { NumberAnimation { duration: 300; easing.type: Easing.OutQuad } }
			}

			Loader {
				id: tabPage
				anchors.left: screen.showHeaderAtTop ? parent.left : (UI_PLATFORM == "android" ? tabBar.right : header.right)
				anchors.right: screen.showHeaderAtTop ? parent.right : (UI_PLATFORM == "android" ? parent.right : tabBar.left)
				anchors.bottom: screen.showHeaderAtTop ? (UI_PLATFORM == "android" ? parent.bottom : tabBar.top) : parent.bottom
				anchors.top: screen.showHeaderAtTop ? (UI_PLATFORM == "android" ? tabBar.bottom : header.bottom) : parent.top
				source: Qt.resolvedUrl(pageModel.get(pageModel.selectedIndex).page)
				focus: true
				Keys.onPressed: {
					if (properties.ui.supportsKeys) {
						if (event.key == Qt.Key_Left) {
							mainInterface.openMenu();
							event.accepted = true;
						}
					}
				}
				onLoaded: {
					header.title = "";
					header.editButtonVisible = false;
					header.backVisible = false;
					header.onEditClicked.connect(function() {});
					header.backClickedMethod = function() {};
					tabPage.item.updateHeader();
				}
				onSourceChanged: {
					dev.logScreenView('/' + pageModel.get(pageModel.selectedIndex).title.toLowerCase());
				}
			}
			TabBar {
				id: tabBar
				anchors.left: UI_PLATFORM == "android" ? (screen.showHeaderAtTop ? parent.left : header.right) : (screen.showHeaderAtTop ? parent.left : undefined)
				anchors.right: UI_PLATFORM == "android" ? (screen.showHeaderAtTop ? parent.right : undefined) : parent.right
				anchors.bottom: UI_PLATFORM == "android" ? (screen.showHeaderAtTop ? undefined : parent.bottom) : parent.bottom
				anchors.top: UI_PLATFORM == "android" ? (screen.showHeaderAtTop ? header.bottom : parent.top) : (screen.showHeaderAtTop ? undefined : parent.top)

			}
			Header {
				id: header
				anchors.left: parent.left
				anchors.right: screen.showHeaderAtTop ? parent.right : undefined
				anchors.top: mainViewOffset.bottom
			}
			Rectangle {
				id: mainViewOffset
				anchors.left: parent.left
				anchors.top: parent.top
				anchors.right: parent.right
				color: properties.theme.colors.telldusBlue
				height: UI_PLATFORM == 'ios' ? Screen.height - Screen.desktopAvailableHeight : 0
				z: 999999999999
			}
			SwipeArea {
				anchors.left: parent.left
				anchors.top: parent.top
				anchors.bottom: parent.bottom
				width: mainInterface.menuViewVisible ? parent.width : Units.dp(16)
				onMove: {
					console.log("onMove")
				}
				onSwipe: {
					switch (direction) {
					case "left":
						mainInterface.swipeLeft()
						break
					case "right":
						mainInterface.swipeRight()
						break
					}
				}
				onCanceled: {
					console.log("onCanceled")
				}
				onClicked: {
					if (mainInterface.menuViewVisible) {
						console.log("onClicked")
						mainInterface.closeMenu()
					}
				}
			}
		}

		/* this functions toggles the menu and starts the animation */
		function openMenu()
		{
			console.log("openMenu");
			if (UI_PLATFORM == "android") {
				menuViewTranslate.x = menuView.width + Units.dp(50);
			} else {
				mainViewTranslate.x = menuView.width;
			}
			mainInterface.menuViewVisible = true;
			mainMenu.focus = true;
		}
		function closeMenu()
		{
			console.log("closeMenu");
			if (UI_PLATFORM == "android") {
				menuViewTranslate.x = 0;
			} else {
				mainViewTranslate.x = 0;
			}
			mainInterface.menuViewVisible = false;
			tabPage.focus = true;
		}

		function setActivePage(pageId) {
			pageModel.selectedIndex = pageId;
		}

		function swipeLeft() {
			console.log("swipeLeft");
			closeMenu();
		}

		function swipeRight() {
			console.log("swipeRight");
			openMenu();
		}
	}

	Loader {
		id: loader_loginScreen

		anchors.fill: parent
		opacity: telldusLive.isAuthorized ? 0 : 1
		source: opacity > 0  ? "LoginScreen.qml" : ''

		Behavior on opacity { NumberAnimation { duration: 100 } }
	}

}
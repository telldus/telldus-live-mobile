import QtGraphicalEffects 1.0
import QtQuick 2.4
import QtQuick.Window 2.2
import Telldus 1.0
import Tui 0.1

Rectangle {
	id: mainInterface
	property bool menuViewVisible: false
	color: "#404040";

	Rectangle {
		id: menuView
		anchors.top: parent.top
		anchors.topMargin: Qt.platform.os == 'ios' ? Screen.height - Screen.desktopAvailableHeight : 0
		anchors.bottom: parent.bottom
		anchors.left: parent.left
		width: Math.min((screen.showHeaderAtTop ? mainInterface.width : mainInterface.height) * 0.8, Units.dp(288))
		color: "#404040";

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
						source: "image://icons/" + title.toLowerCase() + "/#ffffff"
						asynchronous: true
						smooth: true
						fillMode: Image.PreserveAspectFit
						sourceSize.width: width * 2
						sourceSize.height: height * 2
					}
				}
				Text {
					id: dashboardButton
					color: "#ffffff"
					font.pixelSize: Units.dp(20)
					text: title
					anchors.verticalCenter: parent.verticalCenter
					anchors.left: parent.left
					anchors.leftMargin: Units.dp(72)
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
				height: Units.dp(56)
				color: index ==  clientList.selectedIndex && properties.ui.supportsKeys ? properties.theme.colors.telldusOrange : "transparent"
				Item {
					id: clientStatusIcon
					anchors.left: parent.left
					anchors.leftMargin: Units.dp(16)
					anchors.verticalCenter: parent.verticalCenter
					height: Units.dp(32)
					width: Units.dp(32)
					Rectangle {
						id: clientStatusIconCircle
						anchors.fill: parent
						anchors.margins: Units.dp(4)
						radius: width / 2
						color: client.online ? (client.websocketConnected ? "#43A047" : "#FDD835") : "#E53935"
					}
				}
				Text {
					id: clientName
					color: "#ffffff"
					font.pixelSize: Units.dp(20)
					text: client.name
					anchors.verticalCenter: parent.verticalCenter
					anchors.left: parent.left
					anchors.leftMargin: Units.dp(72)
				}
			}
		}
		ListView {
			id: clientList
			anchors.top: menuUserDetails.bottom
			anchors.left: parent.left
			anchors.right: parent.right
			height: clientModel.count * Units.dp(56)
			model: clientModel
			delegate: clientListItem
			maximumFlickVelocity: Units.dp(1500)
			spacing: Units.dp(0)
		}
		ListView {
			id: mainMenu
			anchors.top: clientList.bottom
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
		Rectangle {
			id: menuUserDetails
			anchors.left: parent.left
			anchors.top: parent.top
			anchors.right: parent.right
			height: Units.dp(72)
			color: "#404040";
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
	}

	View {
		id: mainView
		anchors.fill: parent
		elevation: 4
		tintColor: properties.theme.colors.dashboardBackground
		transform: Translate {
			id: mainViewTranslate
			x: 0
			Behavior on x { NumberAnimation { duration: 300; easing.type: Easing.OutQuad } }
		}
		Rectangle {
			id: mainViewOffset
			anchors.left: parent.left
			anchors.top: parent.top
			anchors.right: parent.right
			color: properties.theme.colors.telldusBlue
			height: Qt.platform.os == 'ios' ? Screen.height - Screen.desktopAvailableHeight : 0
			z: 999999999999
		}
		Loader {
			id: tabPage
			anchors.left: parent.left
			anchors.top: mainViewOffset.bottom
			anchors.right: parent.right
			anchors.bottom: tabBarBackground.top
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

			onSourceChanged: {
				dev.logScreenView('/' + pageModel.get(pageModel.selectedIndex).title.toLowerCase());
			}
		}
		Component {
			id: tabBarItem
			Rectangle {
				visible: inTabBar
				width: inTabBar ? tabBar.width / 4 : 0
				height: parent.height
				color: index ==  pageModel.selectedIndex ? properties.theme.colors.telldusOrange : "transparent"
				Item {
					id: dashboardIcon
					anchors.centerIn: parent
					height: Units.dp(32)
					width: Units.dp(32)
					Image {
						id: dashboardIconImage
						anchors.fill: parent
						anchors.margins: Units.dp(4)
						source: "image://icons/" + title.toLowerCase() + "/" + (index ==  pageModel.selectedIndex ? "#ffffff" : properties.theme.colors.telldusOrange)
						asynchronous: true
						smooth: true
						fillMode: Image.PreserveAspectFit
						sourceSize.width: width * 2
						sourceSize.height: height * 2
					}
				}
				MouseArea {
					anchors.fill: parent
					onClicked: {
						pageModel.selectedIndex = index;
					}
				}
			}
		}
		View {
			id: tabBarBackground
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.bottom: parent.bottom
			height: Units.dp(56)
			tintColor: "#f5f5f5"
			elevation: 2
			ListView {
				id: tabBar
				anchors.fill: parent
				model: pageModel
				delegate: tabBarItem
				orientation: Qt.Horizontal
				maximumFlickVelocity: Units.dp(1500)
				spacing: 0
			}
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
					closeMenu()
				}
			}
		}
	}

	/* this functions toggles the menu and starts the animation */
	function openMenu()
	{
		console.log("openMenu");
		mainViewTranslate.x = menuView.width;
		mainInterface.menuViewVisible = true;
		mainMenu.focus = true;
	}
	function closeMenu()
	{
		console.log("closeMenu");
		mainViewTranslate.x = 0;
		mainInterface.menuViewVisible = false;
		tabPage.focus = true;
	}

	function setActivePage(pageId) {
		mainMenu.currentIndex = pageId;
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

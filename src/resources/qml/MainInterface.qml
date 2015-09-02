import QtGraphicalEffects 1.0
import QtQuick 2.0
import QtQuick.Window 2.2
import Telldus 1.0

Rectangle {
	id: mainInterface

	property variant screenNames: ['/dashboard', '/devices', '/sensors', '/scheduler', '/settings', '/debug']
	property bool menuViewVisible: false
	color: "#404040";

	Rectangle {
		id: menuView
		anchors.top: parent.top
		anchors.topMargin: Qt.platform.os == 'ios' ? Screen.height - Screen.desktopAvailableHeight : 0
		anchors.bottom: parent.bottom
		anchors.left: parent.left
//		opacity: mainInterface.menuViewVisible ? 1 : 0
		width: (screen.showHeaderAtTop ? mainInterface.width : mainInterface.height) * 0.8
		color: "#404040";
//		Behavior on opacity { NumberAnimation { duration: 300 } }

		Item {
			id: menuUserDetails
			anchors.left: parent.left
			anchors.top: parent.top
			anchors.topMargin: 10 * SCALEFACTOR
			anchors.right: parent.right
			height: childrenRect.height
			Rectangle {
				id: menuUserDetailsInitialsBox
				anchors.left: parent.left
				anchors.leftMargin: 10 * SCALEFACTOR
				anchors.top: parent.top
				color: properties.theme.colors.telldusOrange
				width: 28 * SCALEFACTOR
				height: width
				Text {
					anchors.centerIn: parent
					text: user.firstname.charAt(0) + user.lastname.charAt(0)
					font.pixelSize: 16 * SCALEFACTOR
					color: "#ffffff"
				}

			}
			Text {
				anchors.left: menuUserDetailsInitialsBox.right
				anchors.leftMargin: 10 * SCALEFACTOR
				anchors.verticalCenter: parent.verticalCenter
				text: user.firstname + " " + user.lastname
				width: parent.width
				wrapMode: Text.WordWrap
				font.pixelSize: 16 * SCALEFACTOR
				color: "#ffffff"
			}
		}

		MainMenu {
			id: mainMenu
			anchors.top: menuUserDetails.bottom
			anchors.topMargin: 50 * SCALEFACTOR
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.bottom: parent.bottom
		}
	}

	Item {
		id: mainView
		anchors.fill: parent
		clip: true

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

		TabPage {
			component: "DashboardPage.qml"
			visible: mainMenu.activePage == 0
		}
		TabPage {
			component: "DevicePage.qml"
			visible: mainMenu.activePage == 1
		}
		TabPage {
			component: "SensorPage.qml"
			visible: mainMenu.activePage == 2
		}
		TabPage {
			component: "SchedulerPage.qml"
			visible: mainMenu.activePage == 3
		}
		TabPage {
			component: "SettingsPage.qml"
			visible: mainMenu.activePage == 4
		}
		TabPage {
			component: "DebugPage.qml"
			visible: mainMenu.activePage == 5
		}

		SwipeArea {
			anchors.left: parent.left
			anchors.top: parent.top
			anchors.bottom: parent.bottom
			width: mainInterface.menuViewVisible ? parent.width : 10 * SCALEFACTOR
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
					swipeBoth()
				}
			}
		}
	}

	/* this functions toggles the menu and starts the animation */
	function onMenu()
	{
		console.log("onMenu")
		mainViewTranslate.x = mainInterface.menuViewVisible ? 0 : menuView.width
		mainInterface.menuViewVisible = !mainInterface.menuViewVisible;
	}

	function closeMenu()
	{
		console.log("closeMenu")
		mainViewTranslate.x = 0
		mainInterface.menuViewVisible = false;
	}

	function setActivePage(pageId) {
		mainMenu.activePage = pageId
		dev.logScreenView(screenNames[pageId])
	}
	function swipeLeft() {
		console.log("swipeLeft")
		swipeBoth()
	}
	function swipeRight() {
		console.log("swipeRight")
		if (mainInterface.menuViewVisible == false) {
			onMenu()
		}
	}
	function swipeBoth() {
		mainViewTranslate.x = 0
		mainInterface.menuViewVisible = false;
	}
}

import QtGraphicalEffects 1.0
import QtQuick 2.0
import QtQuick.Window 2.2
import Telldus 1.0

Rectangle {
	id: mainInterface

	property variant screenNames: ['/dashboard', '/devices', '/sensors', '/scheduler', '/settings', '/debug']
	property bool menuViewVisible: false
	property bool timelineViewVisible: false
	color: "#404040";

	Rectangle {
		id: menuView
		anchors.top: parent.top
		anchors.topMargin: Qt.platform.os == 'ios' ? Screen.height - Screen.desktopAvailableHeight : 0
		anchors.bottom: parent.bottom
		anchors.left: parent.left
		opacity: mainInterface.menuViewVisible ? 1 : 0
		width: (screen.isPortrait ? mainInterface.width : mainInterface.height) * 0.8
		color: "#404040";
		Behavior on opacity { NumberAnimation { duration: 300 } }

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
				width: 24 * SCALEFACTOR
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
			anchors.topMargin: 40 * SCALEFACTOR
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.bottom: parent.bottom
		}
	}

	Item {
		id: timelineView
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		anchors.right: parent.right
		opacity: mainInterface.timelineViewVisible ? 1 : 0
		width: mainInterface.width
		Behavior on opacity { NumberAnimation { duration: 300 } }

		Column {
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.right: parent.right
			Text {
				color: "#ffffff";
				font.pixelSize: 24
				text: "Timeline"
				width: parent.width
				anchors.topMargin: 10
				anchors.horizontalCenter: parent.horizontalCenter
			}
		}
	}

	Item {
		id: mainView
		anchors.fill: parent
		clip: true

		/* this is what moves the normal view aside */
		transform: Translate {
			id: mainViewTranslate
			x: 0
			//y: 0
			Behavior on x { NumberAnimation { duration: 300; easing.type: Easing.OutQuad } }
			//Behavior on y { NumberAnimation { duration: 300; easing.type: Easing.OutQuad } }
		}

		TabPage {
			component: "DashboardPage.qml"
			pageId: 0
			currentPage: mainMenu.activePage
		}

		TabPage {
			component: "DevicePage.qml"
			pageId: 1
			currentPage: mainMenu.activePage
		}
		TabPage {
			component: "SensorPage.qml"
			pageId: 2
			currentPage: mainMenu.activePage
		}
		TabPage {
			component: "SchedulerPage.qml"
			pageId: 3
			currentPage: mainMenu.activePage
		}
		TabPage {
			component: "SettingsPage.qml"
			pageId: 4
			currentPage: mainMenu.activePage
		}
		TabPage {
			component: "DebugPage.qml"
			pageId: 5
			currentPage: mainMenu.activePage
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
		//mainViewTranslate.y = mainInterface.menuViewVisible ? 0 : 20
		mainInterface.menuViewVisible = !mainInterface.menuViewVisible;
	}
	function onTimeline()
	{
		console.log("onTimeline")
		mainViewTranslate.x = mainInterface.timelineViewVisible ? 0 : -menuView.width
		//mainViewTranslate.y = mainInterface.menuViewVisible ? 0 : 20
		mainInterface.timelineViewVisible = !mainInterface.timelineViewVisible;
	}

	function setActivePage(pageId) {
		mainMenu.activePage = pageId
		dev.logScreenView(screenNames[pageId])
	}
	function swipeLeft() {
		console.log("swipeLeft")
		swipeBoth()
		if (mainInterface.timelineViewVisible == false) {
//			onTimeline()
		}
	}
	function swipeRight() {
		console.log("swipeRight")
		if (mainInterface.menuViewVisible == false) {
			onMenu()
		}
	}
	function swipeBoth() {
		mainViewTranslate.x = 0
		//mainViewTranslate.y = 0
		mainInterface.menuViewVisible = false;
		mainInterface.timelineViewVisible = false;
	}
}

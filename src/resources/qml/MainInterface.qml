import QtGraphicalEffects 1.0
import QtQuick 2.0
import QtQuick.Window 2.2
import Telldus 1.0

Rectangle {
	id: mainInterface

	property variant screenNames: ['/dashboard', '/devices', '/sensors', '/schedular', '/settings']
	property bool menuViewVisible: false
	property bool timelineViewVisible: false
	color: screen.isPortrait ? "#20334d" : "#000000";

	Rectangle {
		id: menuView
		anchors.top: parent.top
		anchors.topMargin: Qt.platform.os == 'ios' ? Screen.height - Screen.desktopAvailableHeight : 0
		anchors.bottom: parent.bottom
		anchors.left: parent.left
		opacity: mainInterface.menuViewVisible ? 1 : 0
		width: (screen.isPortrait ? mainInterface.width : mainInterface.height) * 0.8
		color: "#000000";
		Behavior on opacity { NumberAnimation { duration: 300 } }

		Footer {
			id: footer
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.right: parent.right
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
		anchors.topMargin: Qt.platform.os == 'ios' ? Screen.height - Screen.desktopAvailableHeight : 0
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
			currentPage: footer.activePage
		}

		TabPage {
			component: "DevicePage.qml"
			pageId: 1
			currentPage: footer.activePage
		}
		TabPage {
			component: "SensorPage.qml"
			pageId: 2
			currentPage: footer.activePage
		}
		TabPage {
			component: "SchedulerPage.qml"
			pageId: 3
			currentPage: footer.activePage
		}
		TabPage {
			component: "SettingsPage.qml"
			pageId: 4
			currentPage: footer.activePage
		}
		TabPage {
			component: "DebugPage.qml"
			pageId: 5
			currentPage: footer.activePage
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
		footer.activePage = pageId
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

import QtQuick 2.4
import QtQuick.LocalStorage 2.0
import Tui 0.1

Rectangle {
	id: screen

	property bool isPortrait: width <= height
	property bool showHeaderAtTop: (width <= height) || (Units.dp(56) < height * 0.1)

	Component.onCompleted: {
		console.log("UI supportsTouch: " + properties.ui.supportsTouch);
		console.log("UI supportsKeys: " + properties.ui.supportsKeys);
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
			inDrawer: true
			inTabBar: false
		}
	}

	Loader {
		id: loader_mainInterface

		anchors.fill: parent
		opacity: telldusLive.isAuthorized ? 1 : 0
		source: opacity > 0  ? "MainInterface" + (Qt.platform.os == "android" ? "Android" : "iOS") + ".qml" : ''

		Behavior on opacity { NumberAnimation { duration: 100 } }
	}

	Loader {
		id: loader_loginScreen

		anchors.fill: parent
		opacity: telldusLive.isAuthorized ? 0 : 1
		source: opacity > 0  ? "LoginScreen.qml" : ''

		Behavior on opacity { NumberAnimation { duration: 100 } }
	}

}


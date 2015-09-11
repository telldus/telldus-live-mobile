import QtQuick 2.4
import Tui 0.1

// Supported keys on Nexus Player
//  Qt::Key_Left
//  Qt::Key_Right
//  Qt::Key_Up
//  Qt::Key_Down
//  Qt::Key_Enter
//  Qt::Key_Search
//  Qt::Key_MediaPlay
//  Qt::Key_Back

Rectangle {
	id: screen
	property bool showHeaderAtTop: true

	Component.onCompleted: {
		console.log("UI supportsTouch: " + properties.ui.supportsTouch);
		console.log("UI supportsKeys: " + properties.ui.supportsKeys);

		Client.setupCache(clientModel, DB.db)
		Device.setupCache(deviceModelController, DB.db)
		Scheduler.setupCache(schedulerModel, DB.db)
		Sensor.setupCache(sensorModel, DB.db)
	}

	ListModel {
		id: pageModel

		property var selectedIndex: 0

		ListElement {
			title: "Dashboard"
			page: "DashboardPage.qml"
			inDrawer: true
			inTabBar: false
		}
		ListElement {
			title: "Devices"
			page: "DevicePage.qml"
			inDrawer: true
			inTabBar: false
		}
		ListElement {
			title: "Sensors"
			page: "SensorPage.qml"
			inDrawer: true
			inTabBar: false
		}
		ListElement {
			title: "Scheduler"
			page: "SchedulerPage.qml"
			inDrawer: true
			inTabBar: false
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
		id: interfaceLoader
		focus: true
		anchors.fill: parent
		opacity: telldusLive.isAuthorized ? 1 : 0
		source: telldusLive.isAuthorized ? "MainInterfaceiOS.qml" : "LoginScreen.qml"
	}

}

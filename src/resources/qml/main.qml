import QtQuick 2.4
import QtQuick.LocalStorage 2.0
import Tui 0.1
import "../scripts/DB.js" as DB
import "../scripts/Client.js" as Client
import "../scripts/Device.js" as Device
import "../scripts/Scheduler.js" as Scheduler
import "../scripts/Sensor.js" as Sensor

Rectangle {
	id: screen

	property bool isPortrait: width <= height
	property bool showHeaderAtTop: Units.dp(56) < height * 0.1
	Component.onCompleted: {
		Client.setupCache(clientModel, DB.db)
		Device.setupCache(deviceModelController, DB.db)
		Scheduler.setupCache(schedulerModel, DB.db)
		Sensor.setupCache(sensorModel, DB.db)
	}
	Loader {
		id: loader_mainInterface
		opacity: telldusLive.isAuthorized ? 1 : 0
		Behavior on opacity { NumberAnimation { duration: 100 } }
		source: opacity > 0  ? "MainInterface.qml" : ''
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.right: parent.right
		anchors.bottom: parent.bottom
	}
	Loader {
		id: loader_loginScreen
		opacity: telldusLive.isAuthorized ? 0 : 1
		Behavior on opacity { NumberAnimation { duration: 100 } }
		source: opacity > 0  ? "LoginScreen.qml" : ''
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.right: parent.right
		anchors.bottom: parent.bottom
	}
}


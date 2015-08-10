import QtQuick 2.4
import QtQuick.LocalStorage 2.0
import "../scripts/DB.js" as DB
import "../scripts/Device.js" as Device
import "../scripts/Sensor.js" as Sensor

Rectangle {
	id: screen

	property bool changeOfWidth: false
	property bool changeOfHeight: false
	property bool newOrientation: false
	property bool isPortrait: true

	onWidthChanged: {changeOfWidth = true; newOrientation = (changeOfWidth && changeOfHeight)}
	onHeightChanged: {changeOfHeight = true; newOrientation = (changeOfWidth && changeOfHeight)}

	onNewOrientationChanged: {
		if (newOrientation) {
			changeOfWidth = false;
			changeOfHeight = false;

			if (width > height) {
				isPortrait = false
			} else {
				isPortrait = true
			}
		}
	}

	Component.onCompleted: {
		Device.setupCache(deviceModelController, DB.db)
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


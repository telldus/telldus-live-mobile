import QtQuick 1.0
import "Device.js" as Device
import "Sensor.js" as Sensor

Rectangle {
	color: "#dceaf6"

	Component.onCompleted: {
		Device.setupCache(deviceModelController)
		Sensor.setupCache(sensorModel)
	}

	Loader {
		id: loader_mainInterface
		opacity: telldusLive.isAuthorized ? 1 : 0
		Behavior on opacity { NumberAnimation { duration: 100 } }
		source: opacity > 0  ? "MainInterface.qml" : ''
		anchors.fill: parent
	}
	Loader {
		id: loader_loginScreen
		opacity: telldusLive.isAuthorized ? 0 : 1
		Behavior on opacity { NumberAnimation { duration: 100 } }
		source: opacity > 0  ? "LoginScreen.qml" : ''
		anchors.fill: parent
	}
}


import QtQuick 1.0
import "Device.js" as Device
import "Sensor.js" as Sensor

Rectangle {
	color: "#dceaf6"

	Component.onCompleted: {
		Device.setupCache(deviceModelController)
		Sensor.setupCache(sensorModel)
	}

	Component {
		id: component_mainInterface
		MainInterface {
			id: mainInterface
		}
	}
	Loader {
		id: loader_mainInterface
		opacity: telldusLive.isAuthorized ? 1 : 0
		Behavior on opacity { NumberAnimation { duration: 100 } }
		sourceComponent: opacity > 0  ? component_mainInterface : undefined
		anchors.fill: parent
	}
	Component {
		id: component_loginScreen
		LoginScreen {
			id: loginScreen
		}
	}
	Loader {
		id: loader_loginScreen
		opacity: telldusLive.isAuthorized ? 0 : 1
		Behavior on opacity { NumberAnimation { duration: 100 } }
		sourceComponent: opacity > 0  ? component_loginScreen : undefined
		anchors.fill: parent
	}
}


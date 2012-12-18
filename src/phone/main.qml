import QtQuick 1.0

Rectangle {
	color: "#dceaf6"
	//width: 640
	//height: 1136
	width: 768
	height: 1280

	Component {
		id: component_devicePage
		DevicePage {}
	}
	Component {
		id: component_SensorPage
		SensorPage {}
	}
	Component {
		id: component_settingsPage
		SettingsPage {}
	}
	Item {
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: footer.top

		Loader {
			id: loader_devicePage
			anchors.fill: parent
			opacity: footer.activePage == 'device' ? 1 : 0
			Behavior on opacity { NumberAnimation { duration: 100 } }
			sourceComponent: opacity > 0  ? component_devicePage : undefined
		}

		Loader {
			id: loader_SensorPage
			anchors.fill: parent
			opacity: footer.activePage == 'sensor' ? 1 : 0
			Behavior on opacity { NumberAnimation { duration: 100 } }
			sourceComponent: opacity > 0  ? component_SensorPage : undefined
		}

		Loader {
			id: loader_settingsPage
			anchors.fill: parent
			opacity: footer.activePage == 'settings' ? 1 : 0
			Behavior on opacity { NumberAnimation { duration: 100 } }
			sourceComponent: opacity > 0  ? component_settingsPage : undefined
		}

	}

	Footer {
		id: footer
		anchors.bottom: parent.bottom
		anchors.left: parent.left
		anchors.right: parent.right
	}
}


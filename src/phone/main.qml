import QtQuick 1.0

Rectangle {
	color: "#dceaf6"
	//width: 640
	//height: 1136
	width: 768
	height: 1280

	Item {
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: footer.top
		DevicePage {
			id: devicePage
			anchors.fill: parent
			opacity: footer.activePage == 'device' ? 1 : 0
			Behavior on opacity { NumberAnimation { duration: 100 } }
		}
		SensorPage {
			anchors.fill: parent
			opacity: footer.activePage == 'sensor' ? 1 : 0
			Behavior on opacity { NumberAnimation { duration: 100 } }
		}
		SettingsPage {
			id: settingsPage
			anchors.fill: parent
			opacity: footer.activePage == 'settings' ? 1 : 0
			Behavior on opacity { NumberAnimation { duration: 100 } }
		}
	}

	Footer {
		id: footer
		anchors.bottom: parent.bottom
		anchors.left: parent.left
		anchors.right: parent.right
	}
}


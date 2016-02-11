import QtQuick 2.4
import Telldus 1.0
import Tui 0.1

Rectangle {
	id: clientDetails
	property Client childObject: overlayPage.childObject

	color: "#ffffff"
	focus: true;

	Item {
		anchors.fill: parent
		anchors.topMargin: Units.dp(10)

		Column {
			anchors.fill: parent
			anchors.margins: Units.dp(10)
			spacing: Units.dp(20)
			Text {
				text: childObject.type
				color: properties.theme.colors.telldusBlue
				width: parent.width
				font.pixelSize: Units.dp(16)
				elide: Text.ElideRight
			}
			Text {
				text: "Version: " + childObject.version
				color: properties.theme.colors.telldusBlue
				width: parent.width
				font.pixelSize: Units.dp(16)
				elide: Text.ElideRight
			}
			Text {
				text: "Status: " + (childObject.online ? 'Online' : 'Offline')
				color: properties.theme.colors.telldusBlue
				width: parent.width
				font.pixelSize: Units.dp(16)
				elide: Text.ElideRight
			}
			Text {
				text: "IP: " + childObject.ip
				color: properties.theme.colors.telldusBlue
				width: parent.width
				font.pixelSize: Units.dp(16)
				elide: Text.ElideRight
			}
			Text {
				text: "Location: " + Number(childObject.latitude).toLocaleString(Qt.locale("en_GB"), 'f', 4) + ', ' +  Number(childObject.longitude).toLocaleString(Qt.locale("en_GB"), 'f', 4)
				color: properties.theme.colors.telldusBlue
				width: parent.width
				font.pixelSize: Units.dp(16)
				elide: Text.ElideRight
			}
			Text {
				text: "Timezone: " + childObject.timezone
				color: properties.theme.colors.telldusBlue
				width: parent.width
				font.pixelSize: Units.dp(16)
				elide: Text.ElideRight
			}
			Text {
				text: "Sunrise/Sunset: " + Qt.formatTime(childObject.sunriseTime, "HH:mm") + '/' + Qt.formatTime(childObject.sunsetTime, "HH:mm")
				color: properties.theme.colors.telldusBlue
				width: parent.width
				font.pixelSize: Units.dp(16)
				elide: Text.ElideRight
			}
		}
	}
}

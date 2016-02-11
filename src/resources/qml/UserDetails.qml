import QtQuick 2.4
import Telldus 1.0
import Tui 0.1

Rectangle {
	id: userDetails
	property User childObject: overlayPage.childObject

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
				text: user.firstname + " " + user.lastname
				color: properties.theme.colors.telldusBlue
				width: parent.width
				font.pixelSize: Units.dp(16)
				elide: Text.ElideRight
			}
			Text {
				text: "Email: " + childObject.email
				color: properties.theme.colors.telldusBlue
				width: parent.width
				font.pixelSize: Units.dp(16)
				elide: Text.ElideRight
			}
		}
	}
}

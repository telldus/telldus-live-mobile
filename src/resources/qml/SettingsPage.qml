import QtQuick 2.0
import Telldus 1.0
import Tui 0.1

Rectangle {
	id: settingsPage
	color: "#ffffff"

	Column {
		anchors.centerIn: parent
		anchors.margins: Units.dp(10)
		spacing: Units.dp(40)
		Text {
			horizontalAlignment: Text.AlignHCenter
			text: qsTranslate("messages", "You are using version") + " " + properties.version + "\n" + qsTranslate("messages", "of") + " Telldus Live! mobile."
			wrapMode: Text.WordWrap
			font.pixelSize: Units.dp(15)
			color: "#093266"
		}
		Button {
			id: button
			title: qsTranslate("misc", "Submit Push Token")
			anchors.horizontalCenter: parent.horizontalCenter
			onClicked: {
				telldusLive.submitPushToken()
			}
		}
		Button {
			id: logoutButton
			title: qsTranslate("misc", "Logout")
			anchors.horizontalCenter: parent.horizontalCenter
			onClicked: {
				telldusLive.logout()
			}
		}
	}

	function updateHeader() {
		header.title = qsTranslate("pages", "Settings");
	}
}

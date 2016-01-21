import QtQuick 2.0
import Telldus 1.0
import Tui 0.1

Rectangle {
	id: settingsPage
	color: "#ffffff"

	Item {
		anchors.fill: parent
		Item {
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.leftMargin: Units.dp(30)
			anchors.right: parent.right
			anchors.rightMargin: Units.dp(30)
			anchors.bottom: button.top
			Text {
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: parent.left
				anchors.right: parent.right
				horizontalAlignment: Text.AlignHCenter
				text: "You are currently logged in as<br>" + user.firstname + "&nbsp;" + user.lastname
				wrapMode: Text.WordWrap
				textFormat: Text.RichText
				font.pixelSize: Units.dp(15)
				font.bold: true
				color: "#093266"
			}
		}
		Button {
			id: button
			title: "Logout"
			anchors.bottom: parent.bottom
			anchors.bottomMargin: Units.dp(30)
			anchors.horizontalCenter: parent.horizontalCenter
			onClicked: {
				mainInterface.setActivePage(0);
				telldusLive.logout()
			}
		}
	}

	function updateHeader() {
		header.title = "Settings";
		header.backClickedMethod = function() {
			mainInterface.setActivePage(0);
		}
	}
}

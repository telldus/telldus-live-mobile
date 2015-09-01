import QtQuick 2.0
import Telldus 1.0

Item {
	id: settingsPage
	Header {
		id: header
		title: "Settings"
	}
	Item {
		anchors.fill: parent
		anchors.topMargin: screen.showHeaderAtTop ? header.height : 0
		anchors.leftMargin: screen.showHeaderAtTop ? 0 : header.width
		Item {
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.leftMargin: 30
			anchors.right: parent.right
			anchors.rightMargin: 30
			anchors.bottom: button.top
			Text {
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: parent.left
				anchors.right: parent.right
				horizontalAlignment: Text.AlignHCenter
				text: "You are currently logged in as<br>" + user.firstname + "&nbsp;" + user.lastname
				wrapMode: Text.WordWrap
				textFormat: Text.RichText
				font.pixelSize: 15*SCALEFACTOR
				font.bold: true
				color: "#093266"
			}
		}
		Button {
			id: button
			title: "Logout"
			anchors.bottom: parent.bottom
			anchors.bottomMargin: 30*SCALEFACTOR
			anchors.horizontalCenter: parent.horizontalCenter
			onClicked: telldusLive.logout()
		}
	}
}

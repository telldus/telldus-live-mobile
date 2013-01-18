import QtQuick 1.0

Item {
	id: settingsPage
	Header {
		id: deviceH
	}
	BorderImage {
		source: "rowBg.png"
		anchors.top: deviceH.bottom
		anchors.right: parent.right
		anchors.left: parent.left
		anchors.bottom: parent.bottom
		anchors.margins: 20
		border {left: 21; top: 21; right: 21; bottom: 28 }

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
				text: "You are currently logged in to a Telldus&nbsp;Live! account.\nIf you want to change account, please click the button below."
				wrapMode: Text.WordWrap
				textFormat: Text.RichText
				font.pointSize: 10
				font.bold: true
				color: "#8cabc5"
			}
		}
		Button {
			id: button
			title: "Logout"
			anchors.left: parent.left
			anchors.leftMargin: 30
			anchors.right: parent.right
			anchors.rightMargin: 30
			anchors.verticalCenter: parent.verticalCenter
			onClicked: telldusLive.logout()
		}
	}
}

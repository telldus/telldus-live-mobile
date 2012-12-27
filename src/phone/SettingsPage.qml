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
		BorderImage {
			id: button
			source: "buttonBg.png"
			border {left: 15; top: 49; right: 15; bottom: 49 }
			anchors.left: parent.left
			anchors.leftMargin: 30
			anchors.right: parent.right
			anchors.rightMargin: 30
			anchors.verticalCenter: parent.verticalCenter
			height: 100
			BorderImage {
				anchors.left: parent.left
				anchors.top: parent.top
				anchors.bottom: parent.bottom
				anchors.right: parent.horizontalCenter
				border {left: 15; top: 49; right: 0; bottom: 49 }
				source: "buttonBgClickLeft.png"
				opacity: buttonArea.pressed ? 1 : 0
			}
			BorderImage {
				anchors.left: parent.horizontalCenter
				anchors.top: parent.top
				anchors.bottom: parent.bottom
				anchors.right: parent.right
				border {left: 0; top: 49; right: 15; bottom: 49 }
				source: "buttonBgClickRight.png"
				opacity: buttonArea.pressed ? 1 : 0
			}
			Text {
				text: "Logout"
				anchors.centerIn: parent
				color: "#00659F"
				font.pixelSize: 40
				font.weight: Font.Bold
				style: Text.Raised
				styleColor: "white"
			}
			MouseArea {
				id: buttonArea
				anchors.fill: parent
				onClicked: telldusLive.logout()
			}
		}
	}
}

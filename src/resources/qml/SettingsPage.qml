import QtQuick 2.0
import Telldus 1.0

Item {
	id: settingsPage
	SwipeArea {
		anchors.fill: parent
		filterTouchEvent: true
		filterMouseEvent: false
		onSwipeRight: mainInterface.swipeRight()
	}
	Header {
		id: deviceH
	}
	BorderImage {
		source: "../images/rowBg.png"
		anchors.top: deviceH.bottom
		anchors.right: parent.right
		anchors.left: parent.left
		anchors.bottom: parent.bottom
		anchors.margins: 20 * SCALEFACTOR
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
				text: "You are currently logged in as<br>" + user.firstname + "&nbsp;" + user.lastname
				wrapMode: Text.WordWrap
				textFormat: Text.RichText
				font.pixelSize: 16 * SCALEFACTOR
				font.bold: true
				color: "#8cabc5"
			}
		}
		Button {
			id: button
			title: "Logout"
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.bottom: parent.bottom
			anchors.bottomMargin: 30 * SCALEFACTOR
			onClicked: telldusLive.logout()
		}
	}
}

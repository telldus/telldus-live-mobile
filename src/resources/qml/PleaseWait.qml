import QtQuick 2.0
import QtWebView 1.0
import Tui 0.1

Item {
	id: pleaseWait
	anchors.fill: parent

	Text {
		id: pleaseWaitText
		text: "Please wait...\n...we'll try to be quick!"
		anchors.verticalCenter: parent.verticalCenter
		anchors.horizontalCenter: parent.horizontalCenter
		font.pixelSize: Units.dp(18)
		color: "#ffffff"
	}

	BusyIndicator {
		id: busyIndicator
		anchors.top: pleaseWaitText.bottom
		anchors.topMargin: Units.dp(10)
		anchors.horizontalCenter: parent.horizontalCenter
	}
}
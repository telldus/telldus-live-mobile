import QtQuick 2.0
import QtWebView 1.0
import Tui 0.1

Item {
	id: webViewContainer
	anchors.fill: parent
	property string url: ""

	Item {
		id: progressBar
		anchors.left: parent.left
		anchors.bottom: parent.bottom
		anchors.right: parent.right
		anchors.bottomMargin: Units.dp(16)
		height: Units.dp(24)

		Text {
			id: progressPercent
			text: "Communicating with the login server"
			anchors.verticalCenter: parent.verticalCenter
			anchors.horizontalCenter: parent.horizontalCenter
			font.pixelSize: Units.dp(12)
			color: "#ffffff"
			visible: webView.loading
		}
	}

	Card {
		id: webViewCard
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.right: parent.right
		anchors.bottom: progressBar.top
		anchors.margins: Units.dp(16)
		anchors.topMargin: Units.dp(40)
		WebView {
			id: webView
			anchors.fill: parent
			anchors.margins: Units.dp(8)
			url: webViewContainer.url
		}
	}
}
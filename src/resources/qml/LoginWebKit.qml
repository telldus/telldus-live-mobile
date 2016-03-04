import QtQuick 2.4
import QtQuick.Window 2.2
import QtWebView 1.0
import Tui 0.1

Rectangle {
	id: loginView
	color: properties.theme.colors.telldusBlue
	Connections{
		target: telldusLive
		onAuthorizationNeeded: {
			webviewLoader.source = "LoginWebKitWebView.qml"
			webviewLoader.item.url = url
		}
		onAuthorizationAborted: {
			webviewLoader.source = ""
		}
		onAuthorizationGranted: {
			webviewLoader.source = "PleaseWait.qml"
		}
	}
	Rectangle {
		id: mainViewOffset
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.right: parent.right
		color: properties.theme.colors.telldusBlue
		height: UI_PLATFORM == 'ios' ? Screen.height - Screen.desktopAvailableHeight : 0
		z: 999999999999
	}
	Item {
		id: loginIntro
		anchors.left: parent.left
		anchors.top: mainViewOffset.top
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		visible: webviewLoader.source == ""
		Item {
			id: header
			anchors.left: parent.left
			anchors.top: parent.top
			anchors.right: parent.right
			height: parent.height / 3
			Image {
				id: logo
				anchors.centerIn: parent
				width: parent.width
				height: Units.dp(42)
				source: "../svgs/logoTelldusLive.svg"
				asynchronous: true
				smooth: true
				fillMode: Image.PreserveAspectFit
				sourceSize.width: width * 2
				sourceSize.height: height * 2
			}
		}
		Item {
			anchors.top: header.bottom
			anchors.bottom: footer.top
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.leftMargin: Units.dp(56)
			anchors.rightMargin: Units.dp(56)

			Text {
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: parent.left
				anchors.right: parent.right
				horizontalAlignment: Text.AlignHCenter
				text: qsTranslate("messages", "To start using Telldus&nbsp;Live!&nbsp;mobile you need to log in to your Telldus&nbsp;Live! account.")
				wrapMode: Text.WordWrap
				textFormat: Text.RichText
				font.pixelSize: Units.dp(16)
				color: "#ffffff"
			}
		}
		Item {
			id: footer
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.bottom: parent.bottom
			height: parent.height / 3
			Button {
				id: loginButton
				title: "Login"
				anchors.bottom: parent.bottom
				anchors.bottomMargin: Units.dp(56)
				anchors.horizontalCenter: parent.horizontalCenter
				onClicked: {
					telldusLive.authorize()
				}
			}
			BusyIndicator {
				id: busyIndicator
				anchors.top: loginButton.bottom
				anchors.topMargin: Units.dp(10)
				anchors.horizontalCenter: parent.horizontalCenter
				visible: telldusLive.working
			}
		}
	}
	Loader {
		id: webviewLoader
		visible: webviewLoader.source != ""
		anchors.left: parent.left
		anchors.top: mainViewOffset.bottom
		anchors.right: parent.right
		anchors.bottom: parent.bottom
	}
}

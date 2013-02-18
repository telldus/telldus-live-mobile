import QtQuick 1.0
import QtWebKit 1.1

Rectangle {
	id: loginWebKit
	color: "#006199"
	anchors.fill: parent

	Connections{
		target: telldusLive
		onAuthorizationNeeded: {
			webview.url = url
		}
	}
	Component.onCompleted: {
		if (!telldusLive.isAuthorized) {
			// If we are not logged in start the process so we can initiate the WebView
			telldusLive.authorize()
		}
	}

	Item {
		id: content
		anchors.bottom: parent.bottom
		anchors.left: parent.left
		anchors.right: parent.right
		height: HEIGHT

		Image {
			id: logo
			height: sourceSize.height*SCALEFACTOR
			fillMode: Image.PreserveAspectFit
			smooth: true
			source: "startLogo.png"
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 30*SCALEFACTOR
		}

		Item {
			anchors.top: logo.bottom
			anchors.bottom: bottomContainer.top
			anchors.left: parent.left
			anchors.leftMargin: 50*SCALEFACTOR
			anchors.right: parent.right
			anchors.rightMargin: 50*SCALEFACTOR
			Image {
				id: topDivider
				source: "startDivider.png"
				fillMode: Image.TileHorizontally
				anchors.top: parent.top
				anchors.left: parent.left
				anchors.right: parent.right
			}

			Text {
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: parent.left
				anchors.right: parent.right
				horizontalAlignment: Text.AlignHCenter
				text: "To start using Telldus&nbsp;Live!&nbsp;mobile you need to log in to your Telldus&nbsp;Live! account."
				wrapMode: Text.WordWrap
				textFormat: Text.RichText
				font.pixelSize: 30*SCALEFACTOR
				font.bold: true
				color: "#d5ebff"
				style: Text.Raised
				styleColor: "#0b4366"
			}

			Image {
				id: bottomDivider
				source: "startDivider.png"
				fillMode: Image.TileHorizontally
				anchors.left: parent.left
				anchors.right: parent.right
				anchors.bottom: parent.bottom
				anchors.bottomMargin: 10*SCALEFACTOR
			}
		}
		Item {
			id: bottomContainer
			anchors.bottom: parent.bottom
			anchors.left: parent.left
			anchors.leftMargin: 50*SCALEFACTOR
			anchors.right: parent.right
			anchors.rightMargin: 50*SCALEFACTOR
			height: parent.height / 2
			WebView {
				id: webview
				anchors.fill: parent
				anchors.topMargin: 20*SCALEFACTOR
				settings.defaultFontSize: 32*SCALEFACTOR
				settings.developerExtrasEnabled: true
				preferredWidth: width
				preferredHeight: height
				backgroundColor: "transparent"
				z: 1
			}
		}
		BusyIndicator {
			id: throbber
			anchors.bottom: parent.bottom
			anchors.bottomMargin: 30*SCALEFACTOR
			anchors.horizontalCenter: parent.horizontalCenter
			opacity: 0
			Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad } }
			states: State {
				name: 'visible'
				when: webview.progress < 1
				PropertyChanges { target:throbber; opacity: 1 }
			}
		}
	}
}

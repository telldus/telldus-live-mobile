import QtQuick 1.0

Rectangle {
	color: "#006199"

	Connections{
		target: telldusLive
		onAuthorizationNeeded: {
			Qt.openUrlExternally(url)
		}
	}

	Image {
		id: logo
		source: "startLogo.png"
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.top: parent.top
		anchors.topMargin: 70
	}

	Item {
		anchors.top: logo.bottom
		anchors.bottom: loginButton.top
		anchors.left: parent.left
		anchors.leftMargin: 50
		anchors.right: parent.right
		anchors.rightMargin: 50
		Image {
			source: "startDivider.png"
			fillMode: Image.TileHorizontally
			anchors.top: parent.top
			anchors.topMargin: 70
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
			font.pointSize: 10
			font.bold: true
			color: "#d5ebff"
			style: Text.Raised
			styleColor: "#0b4366"
		}

		Image {
			source: "startDivider.png"
			fillMode: Image.TileHorizontally
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.bottom: parent.bottom
			anchors.bottomMargin: 70
		}
	}

	Image {
		id: loginButton
		source: buttonArea.pressed ? "startButtonLoginActive.png" : "startButtonLogin.png"
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 170

		MouseArea {
			id: buttonArea
			anchors.fill: parent
			onClicked: {
				// If we are not logged in start the process so we can initiate the WebView
				telldusLive.authorize()
			}
		}
	}
}

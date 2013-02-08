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
		height: sourceSize.height*SCALEFACTOR
		fillMode: Image.PreserveAspectFit
		smooth: true
		source: "startLogo.png"
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.top: parent.top
		anchors.topMargin: 70*SCALEFACTOR
	}

	Item {
		anchors.top: logo.bottom
		anchors.bottom: loginButton.top
		anchors.left: parent.left
		anchors.leftMargin: 50*SCALEFACTOR
		anchors.right: parent.right
		anchors.rightMargin: 50*SCALEFACTOR
		Image {
			id: topDivider
			source: "startDivider.png"
			fillMode: Image.TileHorizontally
			anchors.top: parent.top
			anchors.topMargin: 70*SCALEFACTOR
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
			anchors.bottomMargin: 70*SCALEFACTOR
		}
	}

	Image {
		id: loginButton
		source: buttonArea.pressed ? "startButtonLoginActive.png" : "startButtonLogin.png"
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 170*SCALEFACTOR
		height: sourceSize.height*SCALEFACTOR
		fillMode: Image.PreserveAspectFit
		smooth: true

		MouseArea {
			id: buttonArea
			anchors.fill: parent
			onClicked: {
				// If we are not logged in start the process so we can initiate the WebView
				telldusLive.authorize()
			}
		}
	}
	BusyIndicator {
		id: busyIndicator
		anchors.top: loginButton.bottom
		anchors.topMargin: 20*SCALEFACTOR
		anchors.horizontalCenter: parent.horizontalCenter
		visible: telldusLive.working
	}

	states: [
		State {
			when: screen.height < 800  // BlackBerry Q10
			PropertyChanges { target: busyIndicator; anchors.topMargin: 10 }
			PropertyChanges { target: logo; anchors.topMargin: 30 }
			PropertyChanges { target: topDivider; anchors.topMargin: 10 }
			PropertyChanges { target: bottomDivider; anchors.bottomMargin: 10 }
			PropertyChanges { target: loginButton; anchors.bottomMargin: 120 }
		}

	]
}

import QtQuick 1.0
import QtWebKit 1.0

BorderImage {
	id: loginWebKit
	source: "rowBg.png"
	anchors.fill: parent
	anchors.margins: 20
	border {left: 21; top: 21; right: 21; bottom: 28 }

	Connections{
		target: telldusLive
		onAuthorizationNeeded: {
			webview.url = url
		}
		onAuthorizedChanged: {
			console.log("Auth changed...");
		}
	}
	Component.onCompleted: {
		if (!telldusLive.isAuthorized) {
			// If we are not logged in start the process so we can initiate the WebView
			telldusLive.authorize()
		}
	}

	Flickable {
		id: webviewContainer
		anchors.fill: parent
		anchors.margins: 20
		contentHeight: childrenRect.height
		contentWidth: childrenRect.width
		boundsBehavior: Flickable.StopAtBounds
		clip: true
		WebView{
			id: webview
			settings.defaultFontSize: 32
			height: preferredHeight
			width: preferredWidth
		}
		z: 1
	}
	Item {
		id: shadow
		anchors.fill: webviewContainer
		z: 2
		opacity: 0
		Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad } }

		Rectangle{
			anchors.fill: parent
			opacity: 0.3
			color: "#000"
		}
		Text{
			anchors.centerIn: parent
			text: "Loading..."
		}
		states: State {
			name: 'visible'
			when: webview.progress < 1
			PropertyChanges { target: shadow; opacity: 1 }
		}
	}
}

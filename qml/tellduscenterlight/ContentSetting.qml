import Qt 4.7
import QtWebKit 1.0

Content {
	id: contentSetting

	Component.onCompleted: {
		if(!telldusLive.isAuthorized){
			telldusLive.authorize()
		}
	}

	Connections{
		target: telldusLive
		onAuthorizationNeeded: {
			webview.url = url
		}
		onAuthorizedChanged: {
			if(!telldusLive.isAuthorized){
				telldusLive.authorize()
			}
		}
	}

	WebView{
		//TODO load as resource when needed
		id: webview
		anchors.fill: parent
		//anchors.centerIn: parent
		scale: 1
		smooth: true
		visible: !telldusLive.isAuthorized  //(but load as needed)
		z: 1
	}
	Item {
		id: shadow
		anchors.fill: webview
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

	Rectangle{
		id: logoutButton
		anchors.centerIn: parent
		width: 60
		height: 30
		Text{
			id: logouttext
			text: 'Logout'
		}
		MouseArea{
			anchors.fill: parent
			onClicked: {
				telldusLive.logout()
			}
		}
		visible: telldusLive.isAuthorized
	}
}

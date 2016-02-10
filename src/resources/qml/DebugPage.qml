import QtQuick 2.0
import QtQuick.Window 2.2
import Telldus 1.0
import Tui 0.1

Rectangle {
	id: dashboardPage
	color: "#ffffff"

	Text {
		Component.onCompleted: {
			debugView.text += "Device platform: " + Qt.platform.os + "\n";
			debugView.text += "Screen width: " + Screen.width + "\n";
			debugView.text += "Screen height: " + Screen.height + "\n";
			debugView.text += "Screen pixel density: " + Screen.pixelDensity + "\n";
			debugView.text += "Screen device pixel ratio: " + Screen.devicePixelRatio + "\n";
			debugView.text += "Screen orientation: " + Screen.orientation + "\n";
			debugView.text += "Screen primary orientation: " + Screen.primaryOrientation + "\n";
			debugView.text += "Screen desktop available width: " + Screen.desktopAvailableWidth + "\n";
			debugView.text += "Screen desktop available height: " + Screen.desktopAvailableHeight + "\n";
		}
		id: debugView
		anchors.fill: parent
		anchors.margins: Units.dp(16)
		text: ""
		font.pointSize: 12
	}

	function onBackClicked() {
		mainInterface.setActivePage(0);
	}

	function updateHeader() {
		header.title = "Debug";
	}
}

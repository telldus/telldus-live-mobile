import QtQuick 2.0
import QtQuick.Window 2.2
import Telldus 1.0

Rectangle {
	id: dashboardPage
	color: "#ffffff"
	Header {
		id: header
		anchors.topMargin: 0
		title: "Debug"
	}
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
		anchors.left: parent.left
		anchors.top: header.bottom
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		anchors.margins: 10 * SCALEFACTOR
		text: ""
		font.pointSize: 12
	}
}

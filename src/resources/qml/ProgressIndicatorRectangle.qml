import QtQuick 2.0
import Tui 0.1

Item {
	id: loadingIndicator
	anchors.fill: parent

	function startAnimation() {
		loadingAnimation.start();
	}

	function stopAnimation() {
		loadingAnimation.restart();
		loadingAnimation.stop();
		effectRect.x = 0;
	}

	Rectangle {
		id: effectRect
		width: height * 6
		height: Units.dp(3)
		color: properties.theme.colors.telldusOrange
		anchors.top: parent.top
		anchors.topMargin: Units.dp(1)
		x: 0
		opacity: x < (loadingIndicator.width / 2) ? x / (loadingIndicator.width / 2) : 1 - ((x - (loadingIndicator.width / 2)) / (loadingIndicator.width / 2))
	}

	SequentialAnimation {
		id: loadingAnimation
		alwaysRunToEnd: true
		loops: Animation.Infinite

		PropertyAction { target: effectRect; property: "visible"; value: true }
		PropertyAction { target: effectRect; property: "x"; value: 0 }
		PropertyAnimation { target: effectRect; property: "x"; to: loadingIndicator.width / 3; duration: 400; }
		PropertyAnimation { target: effectRect; property: "x"; to: (loadingIndicator.width / 3)*2; duration: 1000; }
		PropertyAnimation { target: effectRect; property: "x"; to: loadingIndicator.width; duration: 400; }
		PropertyAction { target: effectRect; property: "visible"; value: false }
		PauseAnimation { duration: 700 }
	}

}
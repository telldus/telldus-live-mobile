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
		width: height * 4
		height: progressBarComponent.height
		color: properties.theme.colors.telldusOrange
		anchors.verticalCenter: parent.verticalCenter
		x: 0
		opacity: Math.min(0.8, (x / loadingIndicator.width) * 2)
	}

	SequentialAnimation {
		id: loadingAnimation
		alwaysRunToEnd: true
		loops: Animation.Infinite

		PropertyAction { target: effectRect; property: "visible"; value: true }
		PropertyAction { target: effectRect; property: "x"; value: 0 }
		PropertyAnimation { target: effectRect; property: "x"; to: loadingIndicator.width/3; duration: 400; }
		PropertyAnimation { target: effectRect; property: "x"; to: (loadingIndicator.width/3)*2; duration: 1000; }
		PropertyAnimation { target: effectRect; property: "x"; to: loadingIndicator.width; duration: 400; }
		PropertyAction { target: effectRect; property: "visible"; value: false }
		PauseAnimation { duration: 700 }
	}

}
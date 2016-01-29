import QtQuick 2.4
import Tui 0.1

Item {
	id: loadingIndicator
	anchors.fill: parent
	function restart() {
		animation01.to = width / 3;
		animation02.to = (width / 3) * 2;
		animation03.to = width;
		loadingAnimation.restart();
	}
	Rectangle {
		id: effectRect
		width: (parent.width * 0.4) * Math.min(1, x / loadingIndicator.width)
		height: Units.dp(4)
		color: properties.theme.colors.telldusOrange
		anchors.verticalCenter: parent.verticalCenter
		x: 0
		opacity: x < (loadingIndicator.width / 2) ? x / (loadingIndicator.width / 2) : 1 - ((x - (loadingIndicator.width / 2)) / (loadingIndicator.width / 2))
	}
	SequentialAnimation {
		id: loadingAnimation
		running: true
		loops: Animation.Infinite
		PropertyAction {
			target: effectRect
			property: "x"
			value: 0
		}
		PropertyAnimation {
			id: animation01
			target: effectRect
			property: "x"
			duration: 400
			to: loadingIndicator.width / 3
		}
		PropertyAnimation {
			id: animation02
			target: effectRect
			property: "x"
			duration: 1000
			to: (loadingIndicator.width / 3) * 2
		}
		PropertyAnimation {
			id: animation03
			target: effectRect
			property: "x"
			duration: 400
			to: loadingIndicator.width
		}
		PauseAnimation {
			duration: 200
		}
	}

}
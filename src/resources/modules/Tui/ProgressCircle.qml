import QtQuick 2.4
import Telldus 1.0
import Tui 0.1

Item {
	id: progressCircleItem
	Rectangle {
		id: mainCircle
		x: 0
		anchors.verticalCenter: parent.verticalCenter
		height: progressCircleItem.height
		width: height
		radius: height
		color: properties.theme.colors.telldusOrange
	}
	SequentialAnimation {
		PauseAnimation { duration: 500 }
		ParallelAnimation {
			XAnimator {
				target: mainCircle
				from: 0
				to: progressCircleItem.width + mainCircle.width
				easing.type: Easing.OutExpo
				duration: 1000
			}
			PropertyAnimation {
				target: mainCircle
				property: "opacity"
				from: 1
				to: 0
				easing.type: Easing.OutExpo
				duration: 1000
			}
		}
		ParallelAnimation {
			XAnimator {
				target: mainCircle
				to: 0
				duration: 0
			}
			PropertyAnimation {
				target: mainCircle
				property: "opacity"
				to: 1
				duration: 200
			}
		}
		PauseAnimation { duration: 500 }
		running: true
		loops: Animation.Infinite
	}
}


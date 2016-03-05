import QtQuick 2.0
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0
import Telldus 1.0
import Tui 0.1

Card {
	id: overlayDimmerCard
	anchors.top: undefined
	anchors.bottom: parent.top
	anchors.left: undefined
	anchors.right: undefined
	anchors.horizontalCenter: parent.horizontalCenter
	anchors.topMargin: Units.dp(8) + (UI_PLATFORM == 'ios' ? Screen.height - Screen.desktopAvailableHeight : 0)
	anchors.leftMargin: undefined
	height: Units.dp(64)
	width: Math.min(Units.dp(468), parent.width - Units.dp(16))
	Behavior on opacity {
		NumberAnimation { duration: 150 }
	}

	property var device: ''
	property int dimValue: 0

	Item {
		id: overlayDimmerCardFull
		anchors.fill: parent
		opacity: 1

		Text {
			id: overlayDimmerHeaderText
			anchors.top: parent.top
			anchors.topMargin: Units.dp(8)
			anchors.horizontalCenter: parent.horizontalCenter
			font.pixelSize: Units.dp(14)
			text: device.name
			color: properties.theme.colors.telldusBlue
		}

		Rectangle {
			id: overlayDimmerRectangle
			anchors.left: parent.left
			anchors.top: overlayDimmerHeaderText.bottom
			anchors.right: parent.right
			anchors.bottom: parent.bottom
			anchors.margins: Units.dp(8)
			color: "#F5F5F5"
			radius: Units.dp(4)
			Text {
				id: overlayDimmerValueText
				anchors.centerIn: parent
				font.pixelSize: Units.dp(12)
				text: overlayDimmerCard.dimValue == 0 ? qsTranslate("", "Off") : (overlayDimmerCard.dimValue == 100 ? qsTranslate("", "On") : overlayDimmerCard.dimValue + '%')
				color: overlayDimmerCard.dimValue == 0 ? "#C62828" : properties.theme.colors.telldusBlue
			}
			Rectangle {
				id: dimmerValueRectangle
				anchors.left: parent.left
				anchors.top: parent.top
				anchors.bottom: parent.bottom
				width: overlayDimmerRectangle.width * (overlayDimmerCard.dimValue / 100)
				color: properties.theme.colors.telldusBlue
				radius: Units.dp(4)
				clip: true
				Item {
					id: dimmerValueRectangleTextContainer
					anchors.top: parent.top
					anchors.bottom: parent.bottom
					anchors.left: parent.left
					width: overlayDimmerRectangle.width
					Text {
						id: dimmerValueRectangleText
						anchors.centerIn: parent
						font.pixelSize: Units.dp(12)
						text: overlayDimmerValueText.text
						color: "#FFFFFF"
					}
				}
			}
		}
	}
	Item {
		id: overlayDimmerCardMini
		anchors.fill: parent
		opacity: 1 - overlayDimmerCardFull.opacity
		Text {
				id: overlayDimmerCardMiniText
				anchors.centerIn: parent
				font.pixelSize: Units.dp(18)
				text: overlayDimmerCard.dimValue == 0 ? qsTranslate("", "Off") : (overlayDimmerCard.dimValue == 100 ? qsTranslate("", "On") : overlayDimmerCard.dimValue + '%')
				color: overlayDimmerCard.dimValue == 0 ? "#C62828" : (overlayDimmerCard.dimValue == 100 ? "#2E7D32" : properties.theme.colors.telldusBlue)
			}

	}

	states: [
		State {
			name: 'showing'
			when: device != '' && screen.showHeaderAtTop
			AnchorChanges {
				target: overlayDimmerCard
				anchors.top: parent.top
				anchors.bottom: undefined
				anchors.left: undefined
				anchors.right: undefined
				anchors.horizontalCenter: parent.horizontalCenter
			}
			PropertyChanges {
				target: overlayDimmerCard
				height: Units.dp(64)
				width: Math.min(Units.dp(468), parent.width - Units.dp(16))
				anchors.topMargin: Units.dp(8) + (UI_PLATFORM == 'ios' ? Screen.height - Screen.desktopAvailableHeight : 0)
				anchors.leftMargin: undefined
			}
			PropertyChanges {
				target: overlayDimmerCardFull
				opacity: 1
			}
		},
		State {
			name: 'headerNotAtTop'
			when: device =='' && !screen.showHeaderAtTop
			AnchorChanges {
				target: overlayDimmerCard
				anchors.top: parent.top
				anchors.bottom: undefined
				anchors.left: undefined
				anchors.right: parent.left
				anchors.horizontalCenter: undefined
			}
			PropertyChanges {
				target: overlayDimmerCard
				height: Units.dp(64)
				width: Units.dp(64)
				anchors.topMargin: Units.dp(8)
				anchors.leftMargin: Units.dp(8)
			}
			PropertyChanges {
				target: overlayDimmerCardFull
				opacity: 0
			}
		},
		State {
			name: 'showing_headerNotAtTop'
			when: device != '' && !screen.showHeaderAtTop
			AnchorChanges {
				target: overlayDimmerCard
				anchors.top: parent.top
				anchors.bottom: undefined
				anchors.left: parent.left
				anchors.right: undefined
				anchors.horizontalCenter: undefined
			}
			PropertyChanges {
				target: overlayDimmerCard
				height: Units.dp(64)
				width: Units.dp(64)
				anchors.topMargin: Units.dp(8)
				anchors.leftMargin: Units.dp(8)
			}
			PropertyChanges {
				target: overlayDimmerCardFull
				opacity: 0
			}
		}
	]
	transitions: [
		Transition {
			from: ''
			to: 'showing'
			reversible: true
			AnchorAnimation {
				duration: 150
			}
		},
		Transition {
			from: 'headerNotAtTop'
			to: 'showing_headerNotAtTop'
			reversible: true
			AnchorAnimation {
				duration: 150
			}
		}
	]

}

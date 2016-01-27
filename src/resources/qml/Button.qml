import QtQuick 2.0
import Tui 0.1

Card {
	id: button
	property alias title: text.text
	signal clicked()
	width: text.width + Units.dp(56)
	height: text.height + Units.dp(16)
	tintColor: "#BDBDBD"

	Rectangle {
		id: buttonFill
		anchors.fill: parent
		anchors.margins: Units.dp(1)
		color: properties.theme.colors.telldusBlue
		radius: button.radius
		Text {
			id: text
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.verticalCenter: parent.verticalCenter
			smooth: true
			color: "#ffffff"
			font.pixelSize: Units.dp(16)
		}
		MouseArea {
			id: buttonArea
			anchors.fill: parent
			onReleased: {
				button.clicked()
				buttonFill.opacity = 1
			}
			onPressed: {
				buttonFill.opacity = 0.6
			}
		}
	}
}

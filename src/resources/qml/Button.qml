import QtQuick 2.0

Item {
	id: button
	property alias title: text.text
	signal clicked()
	width: text.width + (40 * SCALEFACTOR)
	height: text.height + (20 * SCALEFACTOR)

	BorderImage {
		source: "../images/buttonBg.png"
		border {left: 15; top: 49; right: 15; bottom: 49 }
		scale: SCALEFACTOR/2
		transformOrigin: Item.TopLeft
		width: ((text.width + (40 * SCALEFACTOR))*2) / SCALEFACTOR
		height: ((text.height + (20 * SCALEFACTOR))*2) / SCALEFACTOR
		smooth: true
		BorderImage {
			anchors.left: parent.left
			anchors.top: parent.top
			anchors.bottom: parent.bottom
			anchors.right: parent.horizontalCenter
			border {left: 10; top: 10; right: 0; bottom: 10 }
			source: "../images/buttonBgClickLeft.png"
			opacity: buttonArea.pressed ? 1 : 0
		}
		BorderImage {
			anchors.left: parent.horizontalCenter
			anchors.top: parent.top
			anchors.bottom: parent.bottom
			anchors.right: parent.right
			border {left: 0; top: 10; right: 10; bottom: 10 }
			source: "../images/buttonBgClickRight.png"
			opacity: buttonArea.pressed ? 1 : 0
		}
	}
	Text {
		id: text
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.verticalCenter: parent.verticalCenter
		smooth: true
		color: "#00659F"
		font.pixelSize: 20*SCALEFACTOR
		font.weight: Font.Bold
		style: Text.Raised
		styleColor: "white"
	}
	MouseArea {
		id: buttonArea
		anchors.fill: parent
		onClicked: button.clicked()
	}
}

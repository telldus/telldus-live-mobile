import QtQuick 1.1

Item {
	id: button

	BorderImage {
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		anchors.right: parent.horizontalCenter
		border {left: 15; top: 49; right: 0; bottom: 49 }
		source: "buttonBgClickLeft.png"
		opacity: buttonArea.pressed ? 1 : 0
	}
	BorderImage {
		anchors.left: parent.horizontalCenter
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		anchors.right: parent.right
		border {left: 0; top: 49; right: 15; bottom: 49 }
		source: "buttonBgClickRight.png"
		opacity: buttonArea.pressed ? 1 : 0
	}

	Text {
		id: text
		smooth: true
		anchors.centerIn: parent
		color: "#00659F"
		font.pixelSize: 40
		font.weight: Font.Bold
		style: Text.Raised
		styleColor: "white"
		text: "Learn"
	}
	MouseArea {
		id: buttonArea
		anchors.fill: parent
		onClicked: device.learn()
	}

}

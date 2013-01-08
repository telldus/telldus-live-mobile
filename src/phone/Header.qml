import QtQuick 1.1
import Telldus 1.0

Image {
	id: header
	property alias title: titleText.text
	property alias backVisible: backButton.visible
	signal backClicked()
	anchors.left: parent.left
	anchors.right: parent.right
	anchors.top: parent.top

	source: "headerBg.png"
	fillMode: Image.TileHorizontally
	height: 103
	BorderImage {
		id: backButton
		visible: false
		width: backText.width + 25 + 15
		anchors.left: parent.left
		anchors.leftMargin: 30
		anchors.verticalCenter: parent.verticalCenter
		source: backMouseArea.pressed ? "headerButtonBackActive.png" : "headerButtonBack.png"
		border {left: 23; right: 8; top: 24; bottom: 25}
		Text {
			id: backText
			text: "Back"
			anchors.verticalCenter: parent.verticalCenter
			anchors.left: parent.left
			anchors.leftMargin: 25
			font.pixelSize: 25
			font.weight: Font.Bold
			color: "#06456a"
			style: Text.Raised;
			styleColor: "#ffffff"
		}
		MouseArea {
			id: backMouseArea
			anchors.fill: parent
			onClicked: backClicked()
		}
	}

	Image {
		visible: title == '' && backVisible == false
		anchors.verticalCenter: parent.verticalCenter
		source: "headerLogo.png"
	}
	Text {
		id: titleText
		anchors.verticalCenter: parent.verticalCenter
		anchors.left: backButton.right
		anchors.leftMargin: 30
		anchors.right: parent.right
		anchors.rightMargin: 30
		font.pixelSize: 40
		font.weight: Font.Bold
		color: "white"
		style: Text.Raised;
		styleColor: "#003959"
		elide: Text.ElideRight
	}

	Image {
		source: "headerShade.png"
		anchors.top: parent.bottom
		anchors.left: parent.left
		anchors.right: parent.right
		fillMode: Image.TileHorizontally
	}
}

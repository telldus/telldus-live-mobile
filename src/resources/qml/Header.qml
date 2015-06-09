import QtQuick 2.0
import Telldus 1.0

Item {
	id: header
	property alias title: titleText.text
	property alias backVisible: backButton.visible
	signal backClicked()
	anchors.left: parent.left
	anchors.right: parent.right
	anchors.top: parent.top
	height: 103 * SCALEFACTOR

	Image {
		source: "../images/headerBg.png"
		fillMode: Image.TileHorizontally
		width: parent.width/SCALEFACTOR
		scale: SCALEFACTOR
		transformOrigin: Item.TopLeft
		smooth: true

		Image {
			visible: title == '' && backVisible == false
			anchors.verticalCenter: parent.verticalCenter
			source: "../images/headerLogo.png"
			smooth: true
		}
	}
	Item {
		id: backButton
		visible: false
		width: backText.width + ((25 + 15) * SCALEFACTOR)
		height: 50
		anchors.left: parent.left
		anchors.leftMargin: 30 * SCALEFACTOR
		anchors.verticalCenter: parent.verticalCenter
		BorderImage {
			source: backMouseArea.pressed ? "../images/headerButtonBackActive.png" : "../images/headerButtonBack.png"
			border {left: 23; right: 8; top: 24; bottom: 25}
			width: parent.width/SCALEFACTOR
			scale: SCALEFACTOR
			transformOrigin: Item.Left
		}
		Text {
			id: backText
			text: "Back"
			anchors.verticalCenter: parent.verticalCenter
			anchors.left: parent.left
			anchors.leftMargin: 25 * SCALEFACTOR
			font.pixelSize: 25 * SCALEFACTOR
			font.weight: Font.Bold
			color: "#06456a"
			style: Text.Raised;
			styleColor: "#ffffff"
		}
	}
	MouseArea {
		id: backMouseArea
		enabled: backButton.visible
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		anchors.left: backButton.left
		anchors.right: backButton.right
		onClicked: backClicked()
	}

	Text {
		id: titleText
		anchors.verticalCenter: parent.verticalCenter
		anchors.left: backButton.right
		anchors.leftMargin: 30 * SCALEFACTOR
		anchors.right: parent.right
		anchors.rightMargin: 30 * SCALEFACTOR
		font.pixelSize: 40 * SCALEFACTOR
		font.weight: Font.Bold
		color: "white"
		style: Text.Raised;
		styleColor: "#003959"
		elide: Text.ElideRight
	}

	Image {
		source: "../images/headerShade.png"
		anchors.top: parent.bottom
		anchors.left: parent.left
		anchors.right: parent.right
		fillMode: Image.TileHorizontally
	}
}

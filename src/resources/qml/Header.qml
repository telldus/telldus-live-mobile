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
	height: mainHeader.height

	Image {
		id: mainHeader
		source: "../images/headerBg.png"
		fillMode: Image.TileHorizontally
		width: parent.width / SCALEFACTOR
		transformOrigin: Item.TopLeft
		smooth: true
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.right: parent.right
		height: 50 * SCALEFACTOR
	}
	Image {
		visible: title == '' && backVisible == false
		anchors.verticalCenter: mainHeader.verticalCenter
		anchors.horizontalCenter: mainHeader.horizontalCenter
		height: mainHeader.height - (10 * SCALEFACTOR)
		source: "../" + (SCALEFACTOR > 2 ? "images@2x" : "images") + "/headerLogo.png"
		smooth: true
		fillMode: Image.PreserveAspectFit
	}
	Item {
		id: backButton
		visible: false
		width: backText.width + (22 * SCALEFACTOR)
		height: 25 * SCALEFACTOR
		anchors.left: parent.left
		anchors.leftMargin: 10 * SCALEFACTOR
		anchors.verticalCenter: parent.verticalCenter
		BorderImage {
			source: backMouseArea.pressed ? "../images/headerButtonBackActive.png" : "../images/headerButtonBack.png"
			border {left: 23; right: 8; top: 24; bottom: 25}
			width: parent.width / SCALEFACTOR * 2
			height: parent.height / SCALEFACTOR * 2
			scale: SCALEFACTOR / 2
			transformOrigin: Item.TopLeft
		}
		Text {
			id: backText
			text: "Back"
			anchors.verticalCenter: parent.verticalCenter
			anchors.left: parent.left
			anchors.leftMargin: 15 * SCALEFACTOR
			font.pixelSize: 12 * SCALEFACTOR
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
		anchors.horizontalCenter: parent.horizontalCenter
		font.pixelSize: 20 * SCALEFACTOR
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

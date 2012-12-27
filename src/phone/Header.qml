import QtQuick 1.1
import Telldus 1.0

Image {
	id: header
	property alias title: titleText.text
	signal backClicked()
	anchors.left: parent.left
	anchors.right: parent.right
	anchors.top: parent.top

	source: "headerBg.png"
	fillMode: Image.TileHorizontally
	height: 103
	Image {
		visible: title == ''
		anchors.verticalCenter: parent.verticalCenter
		source: "headerLogo.png"
	}
	Text {
		id: titleText
		anchors.verticalCenter: parent.verticalCenter
		anchors.left: parent.left
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
}

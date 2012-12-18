import QtQuick 1.1
import Telldus 1.0

Image {
	id: header
	anchors.left: parent.left
	anchors.right: parent.right
	anchors.top: parent.top

	source: "headerBg.png"
	fillMode: Image.TileHorizontally
	height: 103
	Image {
		anchors.verticalCenter: parent.verticalCenter
		source: "headerLogo.png"
	}
}

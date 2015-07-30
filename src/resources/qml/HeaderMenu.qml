import QtQuick 2.0

Item {
	id: headerMenu
	property alias items: children.children
	property alias activeItem: children.activeItem
	height: 57 * SCALEFACTOR / 2
	anchors.top: header.bottom
	anchors.left: parent.left
	anchors.right: parent.right
	Image {
		height: 67 * SCALEFACTOR / 2
		width: parent.width
		anchors.top: parent.top
		source: "../images/headerMenuBg.png"
		fillMode: Image.TileHorizontally
//		scale: SCALEFACTOR / 2
		transformOrigin: Item.TopLeft
	}
	Row {
		id: children
		property variant activeItem
		anchors.fill: parent
	}
}

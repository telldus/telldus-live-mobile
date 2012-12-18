import QtQuick 1.0

Item {
	id: headerMenu
	property alias items: children.children
	property alias activeItem: children.activeItem
	height: 57
	anchors.top: header.bottom
	anchors.left: parent.left
	anchors.right: parent.right
	Image {
		height: 67
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.top: parent.top
		source: "headerMenuBg.png"
		fillMode: Image.TileHorizontally
	}
	Row {
		id: children
		property HeaderMenuItem activeItem
		anchors.fill: parent
	}
}

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

	/*BorderImage {
		width: parent.width/2
		height: parent.height
		source: "headerButtonActive.png"
		border {left: 20; top: 20; right: 20; bottom: 20 }
		Text {
			anchors.centerIn: parent
			text: "All devices"
			font.pixelSize: 30
			font.weight: Font.Bold
			color: "white"
			style: Text.Raised;
			styleColor: "#003959"
		}
	}*/
	/*Item {
		width: parent.width/2
		height: parent.height
		anchors.right: parent.right
		Text {
			anchors.centerIn: parent
			text: "Favourites"
			font.pixelSize: 30
			font.weight: Font.Bold
			color: "#d5ebff"
			style: Text.Raised;
			styleColor: "#003959"
		}
	}*/
	Component.onCompleted: {
		/*for(var i in items) {
			console.log("Set p");
			items[i].parent = headerMenu
		}*/
	}
}

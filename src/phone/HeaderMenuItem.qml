import QtQuick 2.0

Item {
	id: headerMenuItem
	property alias title: label.text
	property bool active: parent.activeItem == headerMenuItem
	signal activated()
	width: parent.width/2
	height: parent.height

	BorderImage {
		anchors.fill: parent
		source: "headerButtonActive.png"
		border {left: 20; top: 20; right: 20; bottom: 20 }
		opacity: active ? 1 : 0
	}
	Image {
		source: "headerMenuButtonDivider.png"
		height: parent.height
		fillMode: Image.TileVertically
		anchors.right: parent.left
	}

	Text {
		id: label
		anchors.centerIn: parent
		font.pixelSize: 30*SCALEFACTOR
		font.weight: Font.Bold
		color: active ? "white" : "#d5ebff"
		style: Text.Raised;
		styleColor: "#003959"
	}

	MouseArea {
		anchors.fill: parent
		onClicked: headerMenuItem.activated()
	}
}

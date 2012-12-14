import QtQuick 1.0

Item {
	id: settingsPage
	Image {
		id: header
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right
		source: "headerBg.png"
		fillMode: Image.TileHorizontally
		height: 103
		Image {
			anchors.verticalCenter: parent.verticalCenter
			source: "headerLogo.png"
		}
	}

	Text {
		text: "Settings-sidan"
		horizontalAlignment: Text.AlignHCenter
		font.pixelSize: 100
		anchors.centerIn: parent
		rotation: -45
		transformOrigin: Item.Center
	}

}

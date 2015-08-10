import QtQuick 2.0
import Telldus 1.0

Rectangle {
	id: header
	property alias title: titleText.text
	property alias backVisible: backButton.visible
	property alias editButtonVisible: editButton.visible
	signal backClicked()
	signal editClicked()
	anchors.left: parent.left
	anchors.top: parent.top
	height: screen.isPortrait ? 50 * SCALEFACTOR : screen.height
	width: screen.isPortrait ? screen.width : 50 * SCALEFACTOR
	color: "#20334d"

	Item {
		id: mainHeader
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		Item {
			id: leftButton
			width: 50 * SCALEFACTOR
			height: 50 * SCALEFACTOR
			anchors.top: parent.top
			anchors.left: parent.left
			clip: true
			Item {
				id: backButton
				visible: false
				width: backText.width + ((12 + 8) * SCALEFACTOR)
				height: 25 * SCALEFACTOR
				anchors.centerIn: parent
				clip: true
				BorderImage {
					source: "../" + (SCALEFACTOR > 2 ? "images@2x" : "images") + (backMouseArea.pressed ? "/headerButtonBackActive.png" : "/headerButtonBack.png")
					border {left: SCALEFACTOR > 2 ? 46 : 23 ; right: SCALEFACTOR > 2 ? 16 : 8 ; top: SCALEFACTOR > 2 ? 48 : 24 ; bottom: SCALEFACTOR > 2 ? 50 : 25 }
					width: parent.width * 2 / SCALEFACTOR
					scale: SCALEFACTOR / 2
					transformOrigin: Item.TopLeft
				}
				Text {
					id: backText
					text: "Back"
					anchors.verticalCenter: parent.verticalCenter
					anchors.left: parent.left
					anchors.leftMargin: 12 * SCALEFACTOR
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
			Image {
				id: drawerButton
				visible: !backButton.visible
				anchors.centerIn: parent
				height: 40 * SCALEFACTOR
				width: drawerButton.height
				source: "../" + (SCALEFACTOR > 2 ? "images@2x" : "images") + "/drawerIcon.png"
				smooth: true
				fillMode: Image.PreserveAspectFit
			}
			MouseArea {
				id: drawerMouseArea
				enabled: !backButton.visible
				anchors.top: parent.top
				anchors.bottom: parent.bottom
				anchors.left: drawerButton.left
				anchors.right: drawerButton.right
				onClicked: mainInterface.onMenu();
			}
		}
		Item {
			id: rightButton
			width: 50 * SCALEFACTOR
			height: 50 * SCALEFACTOR
			anchors.bottom: parent.bottom
			anchors.right: parent.right
			clip: true
			Text {
				id: editButton
				visible: false
				color: "#ffffff"
				text: "Edit"
				anchors.centerIn: parent
			}
			MouseArea {
				id: editButtonMouseArea
				enabled: editButton.visible
				anchors.fill: parent
				onClicked: editClicked()
			}
		}
		Item {
			id: mainHeaderCenter
			anchors.left: screen.isPortrait ? leftButton.right : parent.left
			anchors.top: screen.isPortrait ? parent.top : leftButton.bottom
			anchors.right: screen.isPortrait ? rightButton.left : parent.right
			anchors.bottom: screen.isPortrait ? parent.bottom : rightButton.top
			clip: true
			Image {
				visible: title == '' && backVisible == false
				anchors.centerIn: parent
				width: screen.isPortrait ? parent.width : parent.height
				height: (screen.isPortrait ? parent.height : parent.width) - (10 * SCALEFACTOR)
				rotation: screen.isPortrait ? 0 : 270
				source: "../" + (SCALEFACTOR > 2 ? "images@2x" : "images") + "/headerLogo.png"
				smooth: true
				fillMode: Image.PreserveAspectFit
			}
			Text {
				id: titleText
				anchors.verticalCenter: parent.verticalCenter
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.leftMargin: 10 * SCALEFACTOR
				anchors.rightMargin: 10 * SCALEFACTOR
				font.pixelSize: 18 * SCALEFACTOR
				font.weight: Font.Bold
				color: "white"
				style: Text.Raised;
				styleColor: "#003959"
				elide: Text.ElideRight
				rotation: screen.isPortrait ? 0 : 270
			}
		}
	}
}

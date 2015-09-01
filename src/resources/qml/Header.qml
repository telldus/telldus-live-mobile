import QtQuick 2.0
import Telldus 1.0
import QtQuick.Window 2.2

Rectangle {
	id: header
	property alias title: titleText.text
	property alias backVisible: backButton.visible
	property alias editButtonVisible: editButton.visible
	property var headerHeight: 50
	signal backClicked()
	signal editClicked()
	anchors.left: parent.left
	anchors.top: parent.top
	height: screen.showHeaderAtTop ? headerHeight * SCALEFACTOR : mainView.height
	width: screen.showHeaderAtTop ? mainView.width : headerHeight * SCALEFACTOR
	color: properties.theme.colors.telldusBlue

	Item {
		id: mainHeader
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		Item {
			id: leftButton
			width: headerHeight * SCALEFACTOR
			height: headerHeight * SCALEFACTOR
			anchors.top: parent.top
			anchors.left: parent.left
			clip: true
			Item {
				id: backButton
				visible: false
				anchors.centerIn: parent
				height: (leftButton.height - 10) * SCALEFACTOR
				width: height
				Image {
					id: backButtonImage
					anchors.centerIn: parent
					height: parent.height * (0.5 / SCALEFACTOR)
					width: height
					source: "../svgs/iconArrowLeft.svg"
					smooth: true
					fillMode: Image.PreserveAspectFit
					sourceSize.width: width * 2
					sourceSize.height: height * 2
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
			Item {
				id: drawerButton
				visible: !backButton.visible
				anchors.centerIn: parent
				height: (leftButton.height - 10) * SCALEFACTOR
				width: height
				Image {
					id: drawerButtonImage
					anchors.centerIn: parent
					height: parent.height * (0.5 / SCALEFACTOR)
					width: height
					source: "../svgs/iconHamburger.svg"
					smooth: true
					fillMode: Image.PreserveAspectFit
					sourceSize.width: width * 2
					sourceSize.height: height * 2
				}
			}
			MouseArea {
				id: drawerMouseArea
				enabled: !backButton.visible
				anchors.top: parent.top
				anchors.bottom: parent.bottom
				anchors.left: parent.left
				anchors.right: parent.right
				onClicked: mainInterface.onMenu();
			}
		}
		Item {
			id: rightButton
			width: headerHeight * SCALEFACTOR
			height: headerHeight * SCALEFACTOR
			anchors.bottom: parent.bottom
			anchors.right: parent.right
			clip: true
			Item {
				id: editButton
				visible: false
				anchors.centerIn: parent
				height: (rightButton.height - 10) * SCALEFACTOR
				width: height
				Image {
					id: editButtonImage
					anchors.centerIn: parent
					height: parent.height * 0.6 / SCALEFACTOR
					width: height
					source: "image://icons/favourite/#ffffff"
					smooth: true
					fillMode: Image.PreserveAspectFit
					sourceSize.width: width * 2
					sourceSize.height: height * 2
				}
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
			anchors.left: screen.showHeaderAtTop ? leftButton.right : parent.left
			anchors.top: screen.showHeaderAtTop ? parent.top : leftButton.bottom
			anchors.right: screen.showHeaderAtTop ? rightButton.left : parent.right
			anchors.bottom: screen.showHeaderAtTop ? parent.bottom : rightButton.top
			clip: true
			Item {
				visible: title == '' && backVisible == false
				anchors.centerIn: parent
				width: screen.showHeaderAtTop ? parent.width : parent.height
				height: (screen.showHeaderAtTop ? parent.height : parent.width) - (10 * SCALEFACTOR)
				rotation: screen.showHeaderAtTop ? 0 : 270
				Image {
					anchors.centerIn: parent
					width: parent.width * 0.825
					height: parent.height * 0.825
					source: "../svgs/logoTelldusLive.svg"
					smooth: true
					fillMode: Image.PreserveAspectFit
					sourceSize.width: width * 2
					sourceSize.height: height * 2
				}
			}
			Text {
				id: titleText
				anchors.verticalCenter: parent.verticalCenter
				anchors.horizontalCenter: parent.horizontalCenter
				width: screen.showHeaderAtTop ? parent.width : parent.height
				font.pixelSize: 18 * SCALEFACTOR
				font.weight: Font.Bold
				color: "white"
				style: Text.Raised;
				styleColor: "#003959"
				elide: Text.ElideRight
				rotation: screen.showHeaderAtTop ? 0 : 270
				horizontalAlignment: Text.AlignHCenter
			}
		}
	}
}

import QtQuick 2.0
import QtQuick.Window 2.2
import Telldus 1.0
import Tui 0.1

View {
	id: tabBarBackground
	height: screen.showHeaderAtTop ? (UI_PLATFORM == "android" ? Units.dp(48) : Units.dp(49)) : undefined
	width: screen.showHeaderAtTop ? undefined : (UI_PLATFORM == "android" ? Units.dp(48) : Units.dp(56))
	tintColor: "#E0E0E0"
	elevation: (UI_PLATFORM == "android" ? 2 : 0)
	Rectangle {
		anchors.fill: parent
		anchors.topMargin: screen.showHeaderAtTop ? (UI_PLATFORM == "android" ? Units.dp(0) : Units.dp(1)) : undefined
		anchors.leftMargin: screen.showHeaderAtTop ? undefined : (UI_PLATFORM == "android" ? Units.dp(0) : Units.dp(1))
		color: (UI_PLATFORM == "android" ? properties.theme.colors.telldusBlue : "#f5f5f5")
		Component {
			id: tabBarItem
			Item {
				width: screen.showHeaderAtTop ? (UI_PLATFORM == "android" ? tabBarItemText.width + Units.dp(24) + (index == 0 ? Units.dp(32) : Units.dp(0)) : tabBar.width / 4) : parent.width
				height: screen.showHeaderAtTop ? parent.height : (UI_PLATFORM == "android" ? tabBarItemText.width + Units.dp(24) + (index == 0 ? Units.dp(32) : Units.dp(0)) : tabBar.height / 4)
				Item {
					id: tabBarItemInner
					anchors.right: UI_PLATFORM == "android" ? (screen.showHeaderAtTop ? parent.right : undefined) : undefined
					anchors.bottom: UI_PLATFORM == "android" ? (screen.showHeaderAtTop ? undefined : parent.bottom) : undefined
					anchors.horizontalCenter: UI_PLATFORM == "android" ? undefined : parent.horizontalCenter
					anchors.verticalCenter: UI_PLATFORM == "android" ? undefined : parent.verticalCenter
					height: UI_PLATFORM == "android" ? (screen.showHeaderAtTop ? Units.dp(48) : tabBarItemText.width + Units.dp(24) ) : Units.dp(48)
					width: UI_PLATFORM == "android" ? (screen.showHeaderAtTop ? tabBarItemText.width + Units.dp(24) : parent.width) : parent.width
					Item {
						id: dashboardIcon
						visible: UI_PLATFORM != "android"
						anchors.top: parent.top
						anchors.topMargin: Units.dp(2)
						anchors.horizontalCenter: parent.horizontalCenter
						height: Units.dp(32)
						width: Units.dp(32)
						Image {
							id: dashboardIconImage
							anchors.fill: parent
							anchors.margins: Units.dp(6)
							source: "image://icons/" + title.toLowerCase() + "/" + (index == tabPage.currentIndex ? properties.theme.colors.telldusOrange : "#616161")
							asynchronous: true
							smooth: true
							fillMode: Image.PreserveAspectFit
							sourceSize.width: width * 2
							sourceSize.height: height * 2
						}
					}
					Rectangle {
						id: tabBarItemIndicator
						visible: (UI_PLATFORM == "android") && (index == tabPage.currentIndex)
						height: screen.showHeaderAtTop ? Units.dp(2) : undefined
						width: screen.showHeaderAtTop ? undefined : Units.dp(2)
						anchors.top: screen.showHeaderAtTop ? undefined : parent.top
						anchors.left: screen.showHeaderAtTop ? parent.left : undefined
						anchors.right: parent.right
						anchors.bottom: parent.bottom
						color: "#ffffff"
					}
					Text {
						id: tabBarItemText
						anchors.bottom: UI_PLATFORM == "android" ? undefined : parent.bottom
						anchors.bottomMargin: UI_PLATFORM == "android" ? undefined : Units.dp(4)
						anchors.left: UI_PLATFORM == "android" ? undefined : parent.left
						anchors.right: UI_PLATFORM == "android" ? undefined : parent.right
						horizontalAlignment: UI_PLATFORM == "android" ? undefined : Text.AlignHCenter
						anchors.horizontalCenter: UI_PLATFORM == "android" ? parent.horizontalCenter : undefined
						anchors.verticalCenter: UI_PLATFORM == "android" ? parent.verticalCenter : undefined
						font.bold: UI_PLATFORM == "android" ? true : false
						text: UI_PLATFORM == "android" ? title.toUpperCase() : title
						font.pixelSize: UI_PLATFORM == "android" ? Units.dp(14) : Units.dp(8)
						color: (index == tabPage.currentIndex ? (UI_PLATFORM == "android" ? "#ffffff" : properties.theme.colors.telldusOrange) : (UI_PLATFORM == "android" ? "#b2ffffff" : "#616161"))
						rotation: UI_PLATFORM == "android" ? (screen.showHeaderAtTop ? 0 : 270) : undefined
					}
				}
				MouseArea {
					anchors.fill: parent
					onClicked: {
						tabPage.currentIndex = index;
					}
				}
			}
		}
		ListView {
			id: tabBar
			anchors.fill: parent
			model: pageModel
			delegate: tabBarItem
			orientation: screen.showHeaderAtTop ? Qt.Horizontal : Qt.Vertical
			maximumFlickVelocity: Units.dp(1500)
			spacing: 0
			currentIndex: tabPage.currentIndex
		}
	}
}

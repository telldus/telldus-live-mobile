import QtQuick 2.0
import QtQuick.Window 2.2
import Telldus 1.0
import Tui 0.1

View {
	id: tabBarBackground
	height: screen.showHeaderAtTop ? (Qt.platform.os == "android" ? Units.dp(48) : Units.dp(49)) : undefined
	width: screen.showHeaderAtTop ? undefined : (Qt.platform.os == "android" ? Units.dp(48) : Units.dp(56))
	tintColor: "#E0E0E0"
	elevation: (Qt.platform.os == "android" ? 2 : 0)
	Rectangle {
		anchors.fill: parent
		anchors.topMargin: screen.showHeaderAtTop ? (Qt.platform.os == "android" ? Units.dp(0) : Units.dp(1)) : undefined
		anchors.leftMargin: screen.showHeaderAtTop ? undefined : (Qt.platform.os == "android" ? Units.dp(0) : Units.dp(1))
		color: (Qt.platform.os == "android" ? properties.theme.colors.telldusBlue : "#f5f5f5")
		Component {
			id: tabBarItem
			Item {
				visible: inTabBar
				width: inTabBar ? (screen.showHeaderAtTop ? (Qt.platform.os == "android" ? tabBarItemText.width + Units.dp(24) + (index == 0 ? Units.dp(32) : Units.dp(0)) : tabBar.width / 4) : parent.width) : 0
				height: inTabBar ? (screen.showHeaderAtTop ? parent.height : (Qt.platform.os == "android" ? tabBarItemText.width + Units.dp(24) + (index == 0 ? Units.dp(32) : Units.dp(0)) : tabBar.height / 4)) : 0
				Item {
					id: tabBarItemInner
					anchors.right: Qt.platform.os == "android" ? (screen.showHeaderAtTop ? parent.right : undefined) : undefined
					anchors.bottom: Qt.platform.os == "android" ? (screen.showHeaderAtTop ? undefined : parent.bottom) : undefined
					anchors.horizontalCenter: Qt.platform.os == "android" ? undefined : parent.horizontalCenter
					anchors.verticalCenter: Qt.platform.os == "android" ? undefined : parent.verticalCenter
					height: Qt.platform.os == "android" ? (screen.showHeaderAtTop ? Units.dp(48) : tabBarItemText.width + Units.dp(24) ) : Units.dp(48)
					width: Qt.platform.os == "android" ? (screen.showHeaderAtTop ? tabBarItemText.width + Units.dp(24) : parent.width) : parent.width
					Item {
						id: dashboardIcon
						visible: Qt.platform.os != "android"
						anchors.top: parent.top
						anchors.topMargin: Units.dp(2)
						anchors.horizontalCenter: parent.horizontalCenter
						height: Units.dp(32)
						width: Units.dp(32)
						Image {
							id: dashboardIconImage
							anchors.fill: parent
							anchors.margins: Units.dp(6)
							source: "image://icons/" + title.toLowerCase() + "/" + (index ==  pageModel.selectedIndex ? properties.theme.colors.telldusOrange : "#616161")
							asynchronous: true
							smooth: true
							fillMode: Image.PreserveAspectFit
							sourceSize.width: width * 2
							sourceSize.height: height * 2
						}
					}
					Rectangle {
						id: tabBarItemIndicator
						visible: (Qt.platform.os == "android") && (index ==  pageModel.selectedIndex)
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
						anchors.bottom: Qt.platform.os == "android" ? undefined : parent.bottom
						anchors.bottomMargin: Qt.platform.os == "android" ? undefined : Units.dp(4)
						anchors.left: Qt.platform.os == "android" ? undefined : parent.left
						anchors.right: Qt.platform.os == "android" ? undefined : parent.right
						horizontalAlignment: Qt.platform.os == "android" ? undefined : Text.AlignHCenter
						anchors.horizontalCenter: Qt.platform.os == "android" ? parent.horizontalCenter : undefined
						anchors.verticalCenter: Qt.platform.os == "android" ? parent.verticalCenter : undefined
						font.bold: Qt.platform.os == "android" ? true : false
						text: Qt.platform.os == "android" ? title.toUpperCase() : title
						font.pixelSize: Qt.platform.os == "android" ? Units.dp(14) : Units.dp(8)
						color: (index ==  pageModel.selectedIndex ? (Qt.platform.os == "android" ? "#ffffff" : properties.theme.colors.telldusOrange) : (Qt.platform.os == "android" ? "#b2ffffff" : "#616161"))
						rotation: Qt.platform.os == "android" ? (screen.showHeaderAtTop ? 0 : 270) : undefined
					}
				}
				MouseArea {
					anchors.fill: parent
					onClicked: {
						pageModel.selectedIndex = index;
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
		}
	}
}
import QtQuick 2.4
import QtQuick.Window 2.2
import Tui 0.1

Rectangle {
	id: mainInterface
	property bool menuViewVisible: false
	color: "#F5F5F5";

	ListModel {
		id: pageModel

		ListElement {
			title: "Dashboard"
			page: "DashboardPage.qml"
		}
		ListElement {
			title: "Devices"
			page: "DevicePage.qml"
		}
		ListElement {
			title: "Sensors"
			page: "SensorPage.qml"
		}
		ListElement {
			title: "Scheduler"
			page: "SchedulerPage.qml"
		}
	}

	Rectangle {
		id: menuViewUnderlay
		visible: mainInterface.menuViewVisible
		anchors.fill: parent
		color: "#000000"
		opacity: (menuViewTranslate.x / menuView.width) * 0.5
		z: UI_PLATFORM == 'android' ? mainView.z + 1 : mainView.z - 2

		MouseArea {
			anchors.fill: parent
			onClicked: {
				mainInterface.closeMenu();
			}
		}
	}

	View {
		id: menuView
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		anchors.left: UI_PLATFORM == "android" ? undefined : parent.left
		width: Math.min((screen.showHeaderAtTop ? mainInterface.width : mainInterface.height) * 0.8, Units.dp(288))
		tintColor:  UI_PLATFORM == "android" ? "#ffffff" : "#212121";
		x: -width - Units.dp(50)
		z: UI_PLATFORM == 'android' ? mainView.z + 2 : mainView.z - 1
		transform: UI_PLATFORM == "android" ? menuViewTranslate : undefined
		elevation: UI_PLATFORM == "android" ? 4 : 0

		Translate {
			id: menuViewTranslate
			x: 0
			Behavior on x { NumberAnimation { duration: 300; easing.type: Easing.OutQuad } }
		}

		Component {
			id: drawerMenuItemComponent
			Item {
				width: parent.width
				height: Units.dp(56) + (drawerMenuItem.childView == "" ? Units.dp(0) : drawerMenuItemLoader.height)
				Rectangle {
					id: drawerMenuItemTitle
					width: parent.width
					height: Units.dp(56)
					color: index ==  tabPage.currentIndex && properties.ui.supportsKeys ? properties.theme.colors.telldusOrange : "transparent"
					Item {
						id: dashboardIcon
						anchors.left: parent.left
						anchors.leftMargin: Units.dp(16)
						anchors.verticalCenter: parent.verticalCenter
						height: Units.dp(32)
						width: Units.dp(32)
						Image {
							id: dashboardIconImage
							anchors.fill: parent
							anchors.margins: Units.dp(4)
							source: "image://icons/" + drawerMenuItem.icon + "/" + (UI_PLATFORM == "android" ? properties.theme.colors.telldusBlue : "#ffffff");
							asynchronous: true
							smooth: true
							fillMode: Image.PreserveAspectFit
							sourceSize.width: width * 2
							sourceSize.height: height * 2
						}
					}
					Text {
						id: dashboardButton
						color: UI_PLATFORM == "android" ? properties.theme.colors.telldusBlue : "#ffffff"
						font.pixelSize: Units.dp(20)
						text: qsTranslate("pages", drawerMenuItem.title)
						anchors.verticalCenter: parent.verticalCenter
						anchors.left: parent.left
						anchors.leftMargin: Units.dp(56)
					}
					MouseArea {
						anchors.fill: parent
						enabled: mainInterface.menuViewVisible;
						onClicked: {
							overlayPage.title = qsTranslate("pages", drawerMenuItem.title);
							overlayPage.icon = drawerMenuItem.icon;
							overlayPage.source = Qt.resolvedUrl(drawerMenuItem.page);
						}
					}
				}
				Loader {
					id: drawerMenuItemLoader
					visible: drawerMenuItem.childView != ""
					source: "DrawerChildViewConnectedLocations.qml"
					asynchronous: true
					anchors.left: parent.left
					anchors.top: drawerMenuItemTitle.bottom
					anchors.right: parent.right
				}
			}
		}

		ListView {
			id: mainMenu
			anchors.top:  UI_PLATFORM == "android" ? menuUserDetailsAndroid.bottom : menuUserDetails.bottom
			anchors.topMargin: UI_PLATFORM == "android" ? Units.dp(16) : undefined
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.bottom: parent.bottom
			model: drawerMenuModel
			delegate: drawerMenuItemComponent
			maximumFlickVelocity: Units.dp(1500)
			spacing: Units.dp(0)
			pressDelay: 100
		}
		Rectangle {
			id: menuUserDetails
			visible: !(UI_PLATFORM == "android")
			anchors.left: parent.left
			anchors.top: menuViewOffset.bottom
			anchors.right: parent.right
			height: Units.dp(72)
			color: menuView.tintColor
			Rectangle {
				id: menuUserDetailsDivider
				anchors.left: parent.left
				anchors.leftMargin: Units.dp(72)
				anchors.right: parent.right
				anchors.bottom: parent.bottom
				anchors.bottomMargin: Units.dp(20)
				height: Units.dp(1)
				color: "#BDBDBD"
			}
			Rectangle {
				id: menuUserDetailsInitialsBox
				anchors.left: parent.left
				anchors.leftMargin: Units.dp(12)
				anchors.verticalCenter: parent.verticalCenter
				color: properties.theme.colors.telldusOrange
				width: Units.dp(40)
				height: width
				radius: Units.dp(4)
				Text {
					id: menuUserDetailsInitials
					anchors.centerIn: parent
					text: user.firstname.charAt(0) + user.lastname.charAt(0)
					font.pixelSize: Units.dp(20)
					color: "#ffffff"
				}

			}
			Text {
				anchors.left: parent.left
				anchors.leftMargin: Units.dp(72)
				anchors.verticalCenter: parent.verticalCenter
				text: user.firstname + " " + user.lastname
				width: parent.width
				wrapMode: Text.WordWrap
				font.pixelSize: Units.dp(16)
				color: "#ffffff"
			}
			MouseArea {
				id: mouseArea
				anchors.fill: parent
				onClicked: {
					overlayPage.title = "Profile"
					overlayPage.icon = 'house'
					overlayPage.source = Qt.resolvedUrl("UserDetails.qml");
					overlayPage.childObject = user
				}
			}
		}
		Rectangle {
			id: menuUserDetailsAndroid
			visible: UI_PLATFORM == "android"
			anchors.left: parent.left
			anchors.top: parent.top
			anchors.right: parent.right
			height: Units.dp(108)
			color: properties.theme.colors.telldusBlue
			Rectangle {
				id: menuUserDetailsAndroidInitialsBox
				anchors.top: parent.top
				anchors.topMargin: Units.dp(20)
				anchors.horizontalCenter: parent.horizontalCenter
				color: properties.theme.colors.telldusOrange
				width: Units.dp(40)
				height: width
				radius: Units.dp(4)
				Text {
					id: menuUserDetailsAndroidInitials
					anchors.centerIn: parent
					text: user.firstname.charAt(0) + user.lastname.charAt(0)
					font.pixelSize: Units.dp(20)
					color: "#ffffff"
				}

			}
			Text {
				anchors.top: menuUserDetailsAndroidInitialsBox.bottom
				anchors.topMargin: Units.dp(12)
				anchors.horizontalCenter: parent.horizontalCenter
				text: user.firstname + " " + user.lastname
				wrapMode: Text.WordWrap
				font.pixelSize: Units.dp(16)
				color: "#ffffff"
			}
		}

		Rectangle {
			id: menuViewOffset
			anchors.left: parent.left
			anchors.top: parent.top
			anchors.right: parent.right
			color: menuView.tintColor
			height: UI_PLATFORM == 'ios' ? Screen.height - Screen.desktopAvailableHeight : 0
			z: 999999999999
		}
	}
	View {
		id: mainView
		anchors.fill: parent
		elevation: UI_PLATFORM == "android" ? 0 : 4
		tintColor: properties.theme.colors.dashboardBackground
		transform: UI_PLATFORM == "android" ? undefined : mainViewTranslate
		z: 100

		MouseArea {
			id: captureAllClicks
			anchors.fill: parent
			preventStealing: false
		}

		Translate {
			id: mainViewTranslate
			x: 0
			Behavior on x { NumberAnimation { duration: 300; easing.type: Easing.OutQuad } }
		}
		Component {
			id: pagesDelegate
			Loader {
				id: tabPageLoader
				width: tabPageContainer.width
				height: tabPageContainer.height
				source: Qt.resolvedUrl(page)
				focus: true
				asynchronous: true
				clip: true
				Keys.onPressed: {
					if (properties.ui.supportsKeys) {
						if (event.key == Qt.Key_Left) {
							mainInterface.openMenu();
							event.accepted = true;
						}
					}
				}
				onLoaded: {
					if (index == tabPage.currentIndex) {
						setAsCurrentIndex();
					}
				}
				function setAsCurrentIndex() {
					if (tabPageLoader.status == Loader.Ready) {
						header.title = "";
						header.editButtonVisible = false;
						header.backVisible = false;
						tabPageLoader.item.updateHeader();
					}
					dev.logScreenView('/' + title.toLowerCase());
				}
				function onBackClicked() {
					if (tabPageLoader.item.onBackClicked) {
						tabPageLoader.item.onBackClicked();
					}
				}
				function onEditClicked() {
					if (tabPageLoader.item.onEditClicked) {
						tabPageLoader.item.onEditClicked();
					}
				}
			}
		}
		Item {
			id: tabPageContainer

			anchors.left: parent.left
			anchors.right: parent.right
			anchors.bottom: tabBar.top
			anchors.top: header.bottom

			ListView {
				id: tabPage
				anchors.fill: parent
				model: pageModel
				delegate: pagesDelegate
				maximumFlickVelocity: Units.dp(1500)
				spacing: Units.dp(0)
				focus: true
				orientation: ListView.Horizontal
				layoutDirection: Qt.LeftToRight
				snapMode: ListView.SnapOneItem
				highlightRangeMode: ListView.StrictlyEnforceRange
				highlightMoveVelocity: tabPage.width * pageModel.size
				boundsBehavior: Flickable.StopAtBounds
				onCurrentIndexChanged: {
					if (tabPage.currentItem) {
						tabPage.currentItem.setAsCurrentIndex();
					}
				}
			}
			Connections {
				target: header
				onBackClicked: {
					tabPage.currentItem.onBackClicked();
				}
				onEditClicked: {
					tabPage.currentItem.onEditClicked();
				}
			}
			View {
				id: highQueueWarning
				visible: telldusLive.queueLength >= 20
				anchors.left: tabPage.left
				anchors.right: tabPage.right
				anchors.top: tabPage.top
				height: Units.dp(32)
				z: header.z + 1
				tintColor: "#E53935"
				elevation: 2

				Text {
					id: highQueueWarningText
					color: "#ffffff"
					font.pixelSize: Units.dp(12)
					text: "Internet connection problems detected"
					anchors.verticalCenter: parent.verticalCenter
					anchors.horizontalCenter: parent.horizontalCenter
				}
			}
			Item {
				id: progressBarComponent
				visible: telldusLive.queueLength > 0 && !highQueueWarning.visible
				anchors.left: tabPage.left
				anchors.right: tabPage.right
				anchors.top: tabPage.top
				height: Units.dp(6)
				z: header.z + 1
				onWidthChanged: {
					progressIndicatorRectangle.restart();
				}
				onVisibleChanged: {
					progressIndicatorRectangle.restart();
				}

				ProgressIndicatorRectangle {
					id: progressIndicatorRectangle
					anchors.fill: parent
				}

			}
		}
		TabBar {
			id: tabBar
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.bottom: parent.bottom
			anchors.top: undefined
			height: Units.dp(49)
			width: undefined

		}
		Header {
			id: header
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.top: mainViewOffset.bottom
			anchors.bottom: undefined
			height: Units.dp(56)
			width: mainView.width
		}
		Rectangle {
			id: mainViewOffset
			anchors.left: parent.left
			anchors.top: parent.top
			anchors.right: parent.right
			color: properties.theme.colors.telldusBlue
			height: UI_PLATFORM == 'ios' ? Screen.height - Screen.desktopAvailableHeight : 0
			z: 999999999999
		}
		SwipeArea {
			anchors.left: parent.left
			anchors.top: parent.top
			anchors.bottom: parent.bottom
			width: mainInterface.menuViewVisible ? parent.width : Units.dp(10)
			onSwipe: {
				switch (direction) {
				case "left":
					mainInterface.closeMenu()
					break
				case "right":
					mainInterface.openMenu()
					break
				}
			}
			onClicked: {
				if (mainInterface.menuViewVisible) {
					mainInterface.closeMenu()
				}
			}
		}
	}

	states: [
		State {
			name: 'headerNotAtTop'
			when: UI_PLATFORM != "android" && !screen.showHeaderAtTop
			AnchorChanges {
				target: header
				anchors.right: undefined
				anchors.bottom: parent.bottom
			}
			PropertyChanges {
				target: header
				height: mainView.height
				width: Units.dp(56)
			}
			AnchorChanges {
				target: tabBar
				anchors.left: undefined
				anchors.right: parent.right
				anchors.bottom: parent.bottom
				anchors.top: parent.top
			}
			PropertyChanges {
				target: tabBar
				height: undefined
				width: Units.dp(56)
			}
			AnchorChanges {
				target: tabPageContainer
				anchors.left: header.right
				anchors.right: tabBar.left
				anchors.bottom: parent.bottom
				anchors.top: parent.top
			}
		},
		State {
			name: 'android'
			when: UI_PLATFORM == "android" && screen.showHeaderAtTop
			AnchorChanges {
				target: header
				anchors.right: parent.right
				anchors.bottom: undefined
			}
			PropertyChanges {
				target: header
				height: Units.dp(56)
				width: mainView.width
			}
			AnchorChanges {
				target: tabBar
				anchors.left: parent.left
				anchors.right: parent.right
				anchors.bottom: undefined
				anchors.top: header.bottom
			}
			PropertyChanges {
				target: tabBar
				height: Units.dp(48)
				width: undefined
			}
			AnchorChanges {
				target: tabPageContainer
				anchors.left: parent.left
				anchors.right: parent.right
				anchors.bottom: parent.bottom
				anchors.top: tabBar.bottom
			}
		},
		State {
			name: 'android_headerNotAtTop'
			when: UI_PLATFORM == "android" && !screen.showHeaderAtTop
			AnchorChanges {
				target: header
				anchors.right: undefined
				anchors.bottom: parent.bottom
			}
			PropertyChanges {
				target: header
				height: mainView.height
				width: Units.dp(56)
			}
			AnchorChanges {
				target: tabBar
				anchors.left: header.right
				anchors.right: undefined
				anchors.bottom: parent.bottom
				anchors.top: parent.top
			}
			PropertyChanges {
				target: tabBar
				height: undefined
				width: Units.dp(49)
			}
			AnchorChanges {
				target: tabPageContainer
				anchors.left: tabBar.right
				anchors.right: parent.right
				anchors.bottom: parent.bottom
				anchors.top: parent.top
			}
		}
	]

	function openMenu()
	{
		if (UI_PLATFORM == "android") {
			menuViewTranslate.x = menuView.width + Units.dp(50);
		} else {
			mainViewTranslate.x = menuView.width;
		}
		mainInterface.menuViewVisible = true;
		mainMenu.focus = true;
	}

	function closeMenu()
	{
		if (UI_PLATFORM == "android") {
			menuViewTranslate.x = 0;
		} else {
			mainViewTranslate.x = 0;
		}
		mainInterface.menuViewVisible = false;
		tabPage.focus = true;
	}

	function setActivePage(pageId) {
		tabPage.currentIndex = pageId;
	}

}

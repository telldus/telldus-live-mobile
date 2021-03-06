import QtQuick 2.0
import Tui 0.1

Item {
	id: componentRoot
	property int activePage: 0

	Column {
		id: buttonRow
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right
		Rectangle {
			width: parent.width
			height: Units.dp(56)
			color: activePage == 0 ? properties.theme.colors.telldusOrange : "transparent"
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
					source: "../svgs/iconDashboard.svg"
					asynchronous: true
					smooth: true
					fillMode: Image.PreserveAspectFit
					sourceSize.width: width * 2
					sourceSize.height: height * 2
				}
			}
			Text {
				id: dashboardButton
				color: "#ffffff"
				font.pixelSize: Units.dp(20)
				text: qsTranslate("pages", "Dashboard")
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: parent.left
				anchors.leftMargin: Units.dp(72)
			}
			MouseArea {
				anchors.fill: parent
				onClicked: changePage(0)
			}
		}
		Rectangle {
			width: parent.width
			height: Units.dp(56)
			color: activePage == 1 ? properties.theme.colors.telldusOrange : "transparent"
			Item {
				id: deviceIcon
				anchors.left: parent.left
				anchors.leftMargin: Units.dp(16)
				anchors.verticalCenter: parent.verticalCenter
				height: Units.dp(32)
				width: Units.dp(32)
				Image {
					id: deviceIconImage
					anchors.fill: parent
					anchors.margins: Units.dp(4)
					source: "../svgs/iconDevices.svg"
					asynchronous: true
					smooth: true
					fillMode: Image.PreserveAspectFit
					sourceSize.width: width * 2
					sourceSize.height: height * 2
				}
			}
			Text {
				id: deviceButton
				color: "#ffffff"
				font.pixelSize: Units.dp(20)
				text: qsTranslate("messages", "Devices")
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: parent.left
				anchors.leftMargin: Units.dp(72)
			}
			MouseArea {
				anchors.fill: parent
				onClicked: changePage(1)
			}
		}
		Rectangle {
			width: parent.width
			height: Units.dp(56)
			color: activePage == 2 ? properties.theme.colors.telldusOrange : "transparent"
			Item {
				id: sensorIcon
				anchors.left: parent.left
				anchors.leftMargin: Units.dp(16)
				anchors.verticalCenter: parent.verticalCenter
				height: Units.dp(32)
				width: Units.dp(32)
				Image {
					id: sensorIconImage
					anchors.fill: parent
					anchors.margins: Units.dp(4)
					source: "../svgs/iconSensors.svg"
					asynchronous: true
					smooth: true
					fillMode: Image.PreserveAspectFit
					sourceSize.width: width * 2
					sourceSize.height: height * 2
				}
			}
			Text {
				id: sensorButton
				color: "#ffffff"
				font.pixelSize: Units.dp(20)
				text: qsTranslate("messages", "Sensors")
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: parent.left
				anchors.leftMargin: Units.dp(72)
			}
			MouseArea {
				anchors.fill: parent
				onClicked: changePage(2)
			}
		}
		Rectangle {
			width: parent.width
			height: Units.dp(56)
			color: activePage == 3 ? properties.theme.colors.telldusOrange : "transparent"
			Item {
				id: schedulerIcon
				anchors.left: parent.left
				anchors.leftMargin: Units.dp(16)
				anchors.verticalCenter: parent.verticalCenter
				height: Units.dp(32)
				width: Units.dp(32)
				Image {
					id: schedulerIconImage
					anchors.fill: parent
					anchors.margins: Units.dp(4)
					source: "../svgs/iconScheduler.svg"
					asynchronous: true
					smooth: true
					fillMode: Image.PreserveAspectFit
					sourceSize.width: width * 2
					sourceSize.height: height * 2
				}
			}
			Text {
				id: schedulerButton
				color: "#ffffff"
				font.pixelSize: Units.dp(20)
				text: "Scheduler"
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: parent.left
				anchors.leftMargin: Units.dp(72)
			}
			MouseArea {
				anchors.fill: parent
				onClicked: changePage(3)
			}
		}
		Rectangle {
			width: parent.width
			height: Units.dp(56)
			color: activePage == 4 ? properties.theme.colors.telldusOrange : "transparent"
			Item {
				id: settingsIcon
				anchors.left: parent.left
				anchors.leftMargin: Units.dp(16)
				anchors.verticalCenter: parent.verticalCenter
				height: Units.dp(32)
				width: Units.dp(32)
				Image {
					id: settingsIconImage
					anchors.fill: parent
					anchors.margins: Units.dp(4)
					source: "../svgs/iconSettings.svg"
					asynchronous: true
					smooth: true
					fillMode: Image.PreserveAspectFit
					sourceSize.width: width * 2
					sourceSize.height: height * 2
				}
			}
			Text {
				id: settingsButton
				color: "#ffffff"
				font.pixelSize: Units.dp(20)
				text: "Settings"
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: parent.left
				anchors.leftMargin: Units.dp(72)
			}
			MouseArea {
				anchors.fill: parent
				onClicked: changePage(4)
			}
		}
		Rectangle {
			visible: false
			width: parent.width
			height: Units.dp(56)
			color: activePage == 5 ? properties.theme.colors.telldusOrange : "transparent"
			Item {
				id: debugIcon
				anchors.left: parent.left
				anchors.leftMargin: Units.dp(16)
				anchors.verticalCenter: parent.verticalCenter
				height: Units.dp(32)
				width: Units.dp(32)
			}
			Text {
				id: debugButton
				color: "#ffffff"
				font.pixelSize: Units.dp(20)
				text: "Debug"
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: parent.left
				anchors.leftMargin: Units.dp(72)
			}
			MouseArea {
				anchors.fill: parent
				onClicked: changePage(5)
			}
		}
	}

	states: [
		State {
			when: activePage == 0
			//PropertyChanges { target: dashboardButtonBackground; opacity: 1 }
		},
		State {
			when: activePage == 1
			//PropertyChanges { target: deviceButtonBackground; opacity: 1 }
		},
		State {
			when: activePage == 2
			//PropertyChanges { target: sensorButtonBackground; opacity: 1 }
		},
		State {
			when: activePage == 3
			//PropertyChanges { target: schedulerButtonBackground; opacity: 1 }
		},
		State {
			when: activePage == 4
			//PropertyChanges { target: settingsButtonBackground; opacity: 1 }
		},
		State {
			when: activePage == 5
			//PropertyChanges { target: settingsButtonBackground; opacity: 1 }
		}
	]

	transitions: [
		Transition {
//			NumberAnimation { properties: "opacity"; duration: 100 }
		}
	]

	function changePage(pageId) {
		mainInterface.onMenu();
		mainInterface.setActivePage(pageId);
	}
}

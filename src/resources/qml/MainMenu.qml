import QtQuick 2.0

Item {
	id: componentRoot
	property int activePage: 0
	anchors.fill: parent
	anchors.leftMargin: 10 * SCALEFACTOR

	Column {
		id: buttonRow
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right
		height: parent.height
		spacing: 15 * SCALEFACTOR
		Rectangle {
			width: parent.width
			height: 42 * SCALEFACTOR
			color: activePage == 0 ? properties.theme.colors.telldusOrange : "transparent"
			Item {
				id: dashboardIcon
				anchors.left: parent.left
				anchors.leftMargin: 10 * SCALEFACTOR
				anchors.verticalCenter: parent.verticalCenter
				height: 24 * SCALEFACTOR
				width: 24 * SCALEFACTOR
				Image {
					id: dashboardIconImage
					anchors.fill: parent
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
				font.pixelSize: 22 * SCALEFACTOR
				text: "Dashboard"
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: dashboardIcon.right
				anchors.leftMargin: 10 * SCALEFACTOR
			}
			MouseArea {
				anchors.fill: parent
				onClicked: changePage(0)
			}
		}
		Rectangle {
			width: parent.width
			height: 42 * SCALEFACTOR
			color: activePage == 1 ? properties.theme.colors.telldusOrange : "transparent"
			Item {
				id: deviceIcon
				anchors.left: parent.left
				anchors.leftMargin: 10 * SCALEFACTOR
				anchors.verticalCenter: parent.verticalCenter
				height: 24 * SCALEFACTOR
				width: 24 * SCALEFACTOR
				Image {
					id: deviceIconImage
					anchors.fill: parent
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
				font.pixelSize: 22 * SCALEFACTOR
				text: "Devices"
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: deviceIcon.right
				anchors.leftMargin: 10 * SCALEFACTOR
			}
			MouseArea {
				anchors.fill: parent
				onClicked: changePage(1)
			}
		}
		Rectangle {
			width: parent.width
			height: 42 * SCALEFACTOR
			color: activePage == 2 ? properties.theme.colors.telldusOrange : "transparent"
			Item {
				id: sensorIcon
				anchors.left: parent.left
				anchors.leftMargin: 10 * SCALEFACTOR
				anchors.verticalCenter: parent.verticalCenter
				height: 24 * SCALEFACTOR
				width: 24 * SCALEFACTOR
				Image {
					id: sensorIconImage
					anchors.fill: parent
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
				font.pixelSize: 22 * SCALEFACTOR
				text: "Sensors"
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: sensorIcon.right
				anchors.leftMargin: 10 * SCALEFACTOR
			}
			MouseArea {
				anchors.fill: parent
				onClicked: changePage(2)
			}
		}
		Rectangle {
			width: parent.width
			height: 42 * SCALEFACTOR
			color: activePage == 3 ? properties.theme.colors.telldusOrange : "transparent"
			Item {
				id: schedulerIcon
				anchors.left: parent.left
				anchors.leftMargin: 10 * SCALEFACTOR
				anchors.verticalCenter: parent.verticalCenter
				height: 24 * SCALEFACTOR
				width: 24 * SCALEFACTOR
				Image {
					id: schedulerIconImage
					anchors.fill: parent
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
				font.pixelSize: 22 * SCALEFACTOR
				text: "Scheduler"
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: schedulerIcon.right
				anchors.leftMargin: 10 * SCALEFACTOR
			}
			MouseArea {
				anchors.fill: parent
				onClicked: changePage(3)
			}
		}
		Rectangle {
			width: parent.width
			height: 42 * SCALEFACTOR
			color: activePage == 4 ? properties.theme.colors.telldusOrange : "transparent"
			Item {
				id: settingsIcon
				anchors.left: parent.left
				anchors.leftMargin: 10 * SCALEFACTOR
				anchors.verticalCenter: parent.verticalCenter
				height: 24 * SCALEFACTOR
				width: 24 * SCALEFACTOR
				Image {
					id: settingsIconImage
					anchors.fill: parent
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
				font.pixelSize: 22 * SCALEFACTOR
				text: "Settings"
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: settingsIcon.right
				anchors.leftMargin: 10 * SCALEFACTOR
			}
			MouseArea {
				anchors.fill: parent
				onClicked: changePage(4)
			}
		}
		Rectangle {
			visible: false
			width: parent.width
			height: 42 * SCALEFACTOR
			color: activePage == 5 ? properties.theme.colors.telldusOrange : "transparent"
			Item {
				id: debugIcon
				anchors.left: parent.left
				anchors.leftMargin: 10 * SCALEFACTOR
				anchors.verticalCenter: parent.verticalCenter
				height: 24 * SCALEFACTOR
				width: 24 * SCALEFACTOR
			}
			Text {
				id: debugButton
				color: "#ffffff"
				font.pixelSize: 22 * SCALEFACTOR
				text: "Debug"
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: debugIcon.right
				anchors.leftMargin: 10 * SCALEFACTOR
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

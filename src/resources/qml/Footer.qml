import QtQuick 2.0

Item {
	id: footer
	property int activePage: 1
	height: 60 * SCALEFACTOR
	Image {
		id: footerBg
		source: "../images/footerBg.png"
		height: 70 * SCALEFACTOR
		fillMode: Image.TileHorizontally
		anchors.bottom: parent.bottom
		anchors.left: parent.left
		anchors.right: parent.right
	}

	Row {
		id: buttonRow
		anchors.bottom: parent.bottom
		anchors.left: parent.left
		anchors.right: parent.right
		height: 60 * SCALEFACTOR
		Item {
			width: parent.width/3
			height: parent.height
			BorderImage {
				id: deviceButtonBackground
				anchors.fill: parent
				source: "../images/footerButtonActive.png"
				border {left: 20; top: 20; right: 20; bottom: 20 }
				opacity: 0
			}
			Image {
				id: deviceButton
				height: sourceSize.height
				scale: 2
				smooth: true
				fillMode: Image.PreserveAspectFit
				anchors.centerIn: parent
				source: "../images/footerIconDevices.png"
			}
			MouseArea {
				anchors.fill: parent
				onClicked: mainInterface.setActivePage(0)
			}
		}
		Image {
			source: "../images/menuButtonDivider.png"
			height: parent.height
			fillMode: Image.TileVertically
		}
		Item {
			width: parent.width/3
			height: parent.height
			BorderImage {
				id: sensorButtonBackground
				anchors.fill: parent
				source: "../images/footerButtonActive.png"
				border {left: 20; top: 20; right: 20; bottom: 20 }
				opacity: 0
			}
			Image {
				id: sensorButton
				anchors.centerIn: parent
				height: sourceSize.height
				scale: 2
				smooth: true
				fillMode: Image.PreserveAspectFit
				source: "../images/footerIconSensors.png"
			}
			MouseArea {
				anchors.fill: parent
				onClicked: mainInterface.setActivePage(1)
			}
		}
		Image {
			source: "../images/menuButtonDivider.png"
			height: parent.height
			fillMode: Image.TileVertically
		}
		Item {
			width: parent.width/3
			height: parent.height
			BorderImage {
				id: settingsButtonBackground
				anchors.fill: parent
				source: "../images/footerButtonActive.png"
				border {left: 20; top: 20; right: 20; bottom: 20 }
				opacity: 0
			}
			Image {
				id: settingsButton
				anchors.centerIn: parent
				height: sourceSize.height
				scale: 2
				smooth: true
				fillMode: Image.PreserveAspectFit
				source: "../images/footerIconSettings.png"
			}
			MouseArea {
				anchors.fill: parent
				onClicked: mainInterface.setActivePage(2)
			}
		}
	}

	states: [
		State {
			when: activePage == 0
			PropertyChanges { target: deviceButtonBackground; opacity: 1 }
			PropertyChanges { target: deviceButton; source: "../images/footerIconDevicesActive.png" }
		},
		State {
			when: activePage == 1
			PropertyChanges { target: sensorButtonBackground; opacity: 1 }
			PropertyChanges { target: sensorButton; source: "../images/footerIconSensorsActive.png" }
		},
		State {
			when: activePage == 2
			PropertyChanges { target: settingsButtonBackground; opacity: 1 }
			PropertyChanges { target: settingsButton; source: "../images/footerIconSettingsActive.png" }
		}
	]

	transitions: [
		Transition {
			NumberAnimation { properties: "opacity"; duration: 100 }
		}
	]
}

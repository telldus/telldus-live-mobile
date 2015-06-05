import QtQuick 2.0

Item {
	id: footer
	property int activePage: 0
	height: 125*SCALEFACTOR
	Image {
		id: footerBg
		source: "footerBg.png"
		height: 140*SCALEFACTOR
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
		height: 122*SCALEFACTOR
		Item {
			width: parent.width/3
			height: parent.height
			BorderImage {
				id: deviceButtonBackground
				anchors.fill: parent
				source: "footerButtonActive.png"
				border {left: 20; top: 20; right: 20; bottom: 20 }
				opacity: 0
			}
			Image {
				id: deviceButton
				height: sourceSize.height*SCALEFACTOR
				smooth: true
				fillMode: Image.PreserveAspectFit
				anchors.centerIn: parent
				source: "footerIconDevices.png"
			}
			MouseArea {
				anchors.fill: parent
				onClicked: mainInterface.setActivePage(0)
			}
		}
		Image {
			source: "menuButtonDivider.png"
			height: parent.height
			fillMode: Image.TileVertically
		}
		Item {
			width: parent.width/3
			height: parent.height
			BorderImage {
				id: sensorButtonBackground
				anchors.fill: parent
				source: "footerButtonActive.png"
				border {left: 20; top: 20; right: 20; bottom: 20 }
				opacity: 0
			}
			Image {
				id: sensorButton
				anchors.centerIn: parent
				height: sourceSize.height*SCALEFACTOR
				smooth: true
				fillMode: Image.PreserveAspectFit
				source: "footerIconSensors.png"
			}
			MouseArea {
				anchors.fill: parent
				onClicked:mainInterface.setActivePage(1)
			}
		}
		Image {
			source: "menuButtonDivider.png"
			height: parent.height
			fillMode: Image.TileVertically
		}
		Item {
			width: parent.width/3
			height: parent.height
			BorderImage {
				id: settingsButtonBackground
				anchors.fill: parent
				source: "footerButtonActive.png"
				border {left: 20; top: 20; right: 20; bottom: 20 }
				opacity: 0
			}
			Image {
				id: settingsButton
				anchors.centerIn: parent
				height: sourceSize.height*SCALEFACTOR
				smooth: true
				fillMode: Image.PreserveAspectFit
				source: "footerIconSettings.png"
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
			PropertyChanges { target: deviceButton; source: "footerIconDevicesActive.png" }
		},
		State {
			when: activePage == 1
			PropertyChanges { target: sensorButtonBackground; opacity: 1 }
			PropertyChanges { target: sensorButton; source: "footerIconSensorsActive.png" }
		},
		State {
			when: activePage == 2
			PropertyChanges { target: settingsButtonBackground; opacity: 1 }
			PropertyChanges { target: settingsButton; source: "footerIconSettingsActive.png" }
		}
	]

	transitions: [
		Transition {
			NumberAnimation { properties: "opacity"; duration: 100 }
		}
	]

	Item {
		states: [
			State {
				// BlackBerry Q10
				when: screen.height < 800 && SCALEFACTOR == 1
				PropertyChanges { target: footer; height: 85 }
				PropertyChanges { target: footerBg; height: 95 }
				PropertyChanges { target: buttonRow; height: 83 }
			}

		]
	}
}

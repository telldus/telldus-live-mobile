import QtQuick 2.0
import Telldus 1.0

Item {
	MouseArea {
		id: buttonsMouseArea
		preventStealing: true
		anchors.fill: parent
		onPressAndHold: pressedAndHeld()
		onPressedChanged: {
			if (!pressed) {
				dimArea.shown = false
			}
		}
		drag.target: dimArea.shown ? dimHandle : undefined
		drag.axis: Drag.XandYAxis
		drag.minimumX: 0
		drag.maximumX: dimArea.width - dimHandle.width
		drag.minimumY: 0
		drag.maximumY: 0
	}
	Item {
		id:dimArea
		property bool shown: false
		onShownChanged: {
			if (!shown) {
				var value = Math.round(dimHandle.x / (dimArea.width - dimHandle.width) * 255);
				device.dim(value)
			}
		}
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: parent.top
		height: parent.height
		opacity: shown ? 1 : 0
		Behavior on opacity { NumberAnimation { duration: 200 } }
		BorderImage {
			border { left: 22; top: 20; right: 22; bottom: 24 }
			source: "../images/dimBg.png"
			anchors.fill: parent
			anchors.leftMargin: -dimHandle.width/2
			anchors.rightMargin: -dimHandle.width/2
		}
		BorderImage {
			source: "../images/dimSliderBg.png"
			height: 12
			border { left: 6; top: 6; right: 6; bottom: 5 }
			anchors.verticalCenter: parent.verticalCenter
			anchors.left: parent.left
			anchors.leftMargin: dimHandle.width/2
			anchors.right: parent.right
			anchors.rightMargin: dimHandle.width/2
		}
		Image {
			id: dimHandle
			source: "../images/dimSliderButton.png"
			anchors.verticalCenter: parent.verticalCenter
			x: (device.stateValue / 255) * (dimArea.width-dimHandle.width)
			Connections {
				target: device
				onStateValueChanged: {
					dimHandle.x = (stateValue / 255) * (dimArea.width-dimHandle.width)
				}
			}
		}
	}

	Item {
		height: parent.height
		anchors.left: parent.left
		anchors.right: separator.left
		BorderImage {
			anchors.fill: parent
			anchors.rightMargin: -15
			border {left: 15; top: 49; right: 0; bottom: 49 }
			source: "../images/buttonBgClickLeft.png"
			opacity: offMouseArea.pressed || buttonsMouseArea.pressed ? 1 : 0
		}
		Image {
			anchors.centerIn: parent
			source: device.state == 2 ? "../images/buttonActionOffActive.png" : "../images/buttonActionOff.png"
			smooth: true
		}
		MouseArea {
			id: offMouseArea
			preventStealing: true
			anchors.fill: parent
			drag.target: dimArea.shown ? dimHandle : undefined
			drag.axis: Drag.XandYAxis
			drag.minimumX: 0
			drag.maximumX: dimArea.width - dimHandle.width
			drag.minimumY: 0
			drag.maximumY: 0
			onPressAndHold: pressedAndHeld()
			onClicked: {
				device.turnOff()
			}
			onPressedChanged: {
				if (!pressed) {
					dimArea.shown = false
				}
			}
		}
	}

	Item {
		id: separator
		anchors.horizontalCenter: parent.horizontalCenter
		height: parent.height
		width: 30
		z:1
		Image {
			anchors.centerIn: parent
			source: methods & 16 ? "../images/buttonDividerDim.png" : "../images/buttonDivider.png"
			height: 70
			fillMode: Image.TileVertically
			Text {
				visible: methods & 16
				color: "#00659F"
				text: Math.round(device.stateValue/255*100) + '%'
				font.pixelSize: 14
				font.bold: true
				style: Text.Raised;
				styleColor: "#fff"
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.top: parent.top
				anchors.topMargin: 34
				smooth: true
			}
		}
	}

	Item {
		height: parent.height
		anchors.left: separator.right
		anchors.right: parent.right
		BorderImage {
			anchors.fill: parent
			anchors.leftMargin: -15
			border {left: 0; top: 49; right: 15; bottom: 49 }
			source: "../images/buttonBgClickRight.png"
			opacity: onMouseArea.pressed || buttonsMouseArea.pressed ? 1 : 0
		}
		Image {
			anchors.centerIn: parent
			source: device.state == 1 || device.state == 16 ? "../images/buttonActionOnActive.png" : "../images/buttonActionOn.png"
			smooth: true
		}
		MouseArea {
			id: onMouseArea
			preventStealing: true
			anchors.fill: parent
			drag.target: dimArea.shown ? dimHandle : undefined
			drag.axis: Drag.XandYAxis
			drag.minimumX: 0
			drag.maximumX: dimArea.width - dimHandle.width
			drag.minimumY: 0
			drag.maximumY: 0
			onClicked: device.turnOn()
			onPressAndHold: pressedAndHeld()
			onPressedChanged: {
				if (!pressed) {
					dimArea.shown = false
				}
			}
		}
	}
	function pressedAndHeld() {
		if ((methods & 16) == 0) {
			return;
		}
		dimArea.shown = true
	}
}

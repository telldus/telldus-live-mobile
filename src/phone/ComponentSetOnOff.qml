import QtQuick 1.1
import Telldus 1.0

Component {
	id: componentSetOnOff
	Item {
		MouseArea {
			id: buttonsMouseArea
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
		Rectangle {
			id:dimArea
			property bool shown: false
			onShownChanged: {
				if (!shown) {
					var value = Math.round(dimHandle.x / (dimArea.width - dimHandle.width) * 100);
					device.dim(value)
				}
			}
			color: "red"
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.bottom: parent.top
			height: parent.height
			opacity: shown ? 1 : 0
			Behavior on opacity { NumberAnimation { duration: 200 } }
			Rectangle {
				id: dimHandle
				color: "blue"
				width: 20
				height: 20
				anchors.verticalCenter: parent.verticalCenter
				x: (device.stateValue / 100) * (dimArea.width-dimHandle.width)
				Connections {
					target: device
					onStateValueChanged: {
						dimHandle.x = (stateValue / 100) * (dimArea.width-dimHandle.width)
					}
				}
			}
		}

		Row {
			id: row
			anchors.fill: parent
			Item {
				height: parent.height
				width: 96
				BorderImage {
					anchors.fill: parent
					anchors.rightMargin: -15
					border {left: 15; top: 49; right: 0; bottom: 49 }
					source: "buttonBgClickLeft.png"
					opacity: offMouseArea.pressed || buttonsMouseArea.pressed ? 1 : 0
				}
				Image {
					anchors.centerIn: parent
					source: device.state == 2 ? "buttonActionOffActive.png" : "buttonActionOff.png"
				}
				MouseArea {
					id: offMouseArea
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
				height: parent.height
				width: 30
				z:1
				Image {
					anchors.centerIn: parent
					source: device.methods & 16 ? "buttonDividerDim.png" : "buttonDivider.png"
					height: 70
					fillMode: Image.TileVertically
					Text {
						visible: device.methods & 16
						color: "#00659F"
						text: device.stateValue + '%'
						font.pixelSize: 14
						font.bold: true
						style: Text.Raised;
						styleColor: "#fff"
						anchors.horizontalCenter: parent.horizontalCenter
						anchors.top: parent.top
						anchors.topMargin: 34
					}
				}
			}
			Item {
				height: parent.height
				width: 96
				BorderImage {
					anchors.fill: parent
					anchors.leftMargin: -15
					border {left: 0; top: 49; right: 15; bottom: 49 }
					source: "buttonBgClickRight.png"
					opacity: onMouseArea.pressed || buttonsMouseArea.pressed ? 1 : 0
				}
				Image {
					anchors.centerIn: parent
					source: device.state == 1 || device.state == 16 ? "buttonActionOnActive.png" : "buttonActionOn.png"
				}
				MouseArea {
					id: onMouseArea
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
		}
		function pressedAndHeld() {
			if ((device.methods & 16) == 0) {
				return;
			}
			dimArea.shown = true
		}
	}
}

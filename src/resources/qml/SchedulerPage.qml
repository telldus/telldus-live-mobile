import QtQuick 2.0
import Telldus 1.0

Item {
	id: schedulerPage
	Component {
		id: schedulerDelegate
		Text {
			color: "#20334d"
			width: list.width
			font.pixelSize: 16 * SCALEFACTOR
			font.weight: Font.Bold
			//text: device.name
			text: "foo"
			elide: Text.ElideRight
		}
	}
	ListView {
		id: list
		anchors.fill: parent
		anchors.topMargin: screen.isPortrait ? header.height : 0
		anchors.leftMargin: screen.isPortrait ? 0 : header.width
		model: schedulerModel
		delegate: schedulerDelegate
		spacing: 0
		maximumFlickVelocity: 1500 * SCALEFACTOR
	}
	Header {
		id: header
		anchors.topMargin: 0
		title: "Scheduler"
	}
}

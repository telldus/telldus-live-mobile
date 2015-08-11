import QtQuick 2.0
import Telldus 1.0

Item {
	Text {
		id: deviceName
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.verticalCenter: parent.verticalCenter
		color: "#ffffff"
		font.pixelSize: 20 * SCALEFACTOR
		text: "WEATHER"
	}
}
import QtQuick 1.1
import "mainscripts.js" as MainScripts

Rectangle {
	width: parent.width
	height: MainScripts.HEADERHEIGHT
	color: "blue"

	property alias text: label.text

	Text{
		id: label
		color: "white"
		font.weight: Font.Bold
		font.pixelSize: 26
		anchors.centerIn: parent
	}
}

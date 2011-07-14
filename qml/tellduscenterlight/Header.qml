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
		font.family: "Nokia Pure Text"
		font.weight: Font.Bold
		font.pixelSize: 26
		anchors.verticalCenter: parent.verticalCenter
		anchors.left: parent.left
		anchors.leftMargin: 16
	}
}

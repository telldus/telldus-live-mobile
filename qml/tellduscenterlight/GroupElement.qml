import Qt 4.7
import "mainscripts.js" as MainScripts

Item{
	id: device
	height: MainScripts.DEVICEROWHEIGHT
	width: parent.width
	Text{
		text: "TESTGROUP"
		color: "blue"
	}
}

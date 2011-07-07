import Qt 4.7

import "../mainscripts.js" as MainScripts

Item{
	id: menuOption
	property alias text: optiontext.text

	height: MainScripts.MENUOPTIONHEIGHT
	width: optiontext.width + MainScripts.MARGIN_TEXT
	Rectangle{
		id: menuOptionRect
		anchors.fill: parent
		color: "lightgray"
		Text{
			id: optiontext
			anchors.centerIn: parent
		}
		MouseArea{
			id: optionMouseArea
			anchors.fill: parent
			hoverEnabled: true
			onEntered: {
				menuOptionRect.color = "darkgray"
			}
			onExited: {
				menuOptionRect.color = "lightgray"
			}

			onPressed: {
				menuOptionRect.color = "blue"
			}
			onReleased: {
				if(optionMouseArea.containsMouse){
					menuOptionRect.color = "darkgray"
				}
				else{
					menuOptionRect.color = "lightgray"
				}
				console.log("GÖR NÅGOT")
			}
		}
	}
}

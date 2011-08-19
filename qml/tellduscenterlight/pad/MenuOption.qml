import Qt 4.7

import "../mainscripts.js" as MainScripts

Item{
	id: menuOption
	property alias text: optiontext.text
	property bool isHeader: false
	property int optionWidth: optiontext.width + MainScripts.MARGIN_TEXT
	property string optionValue: ''
	property bool hideIfFavorite: false

	signal selected()

	height: MainScripts.MENUOPTIONHEIGHT
	width: parent == undefined ? optionWidth : (optionWidth > parent.width ? optionWidth : parent.width)

	Item{
		id: menuOptionRect
		anchors.fill: parent

		Rectangle{
			id: menubackground
			anchors.fill: menuOptionRect
			visible: false
			color: 'black'
		}

		Text{
			id: optiontext
			anchors.centerIn: parent
			color: isHeader ? "white" : "black"
			font.bold: isHeader
		}
		MouseArea{
			id: optionMouseArea
			anchors.fill: parent
			enabled: !isHeader
			hoverEnabled: true
			onEntered: {
				menubackground.color = "darkgray"
				menubackground.visible = true
			}
			onExited: {
				menubackground.visible = false
			}

			onPressed: {
				menubackground.color = "blue"
			}
			onReleased: {
				if(optionMouseArea.containsMouse){
					menubackground.color = "darkgray"
				}
				else{
					menubackground.color = "lightgray"
				}
				menuOption.selected()
			}
		}
	}
}

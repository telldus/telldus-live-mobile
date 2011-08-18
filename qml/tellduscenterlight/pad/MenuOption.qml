import Qt 4.7

import "../mainscripts.js" as MainScripts

Item{
	id: menuOption
	property alias text: optiontext.text
	//property string align: ''
	property bool isHeader: false
	//property bool showArrow: false
	property int optionWidth: optiontext.width + MainScripts.MARGIN_TEXT
	property string optionValue: ''
	property bool hideIfFavorite: false
	height: MainScripts.MENUOPTIONHEIGHT
	width: parent == undefined ? optionWidth : (optionWidth > parent.width ? optionWidth : parent.width)
	signal released()

	Item{
		id: menuOptionRect
		anchors.fill: parent
		//TODO visible: menuOption.parent.assignTo == undefined || !deviceMenu.assignTo.hideFavoriteToggle || !hideIfFavorite

		Rectangle{
			id: menubackground
			anchors.fill: menuOptionRect
			visible: false //isHeader
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
				//menubackground.color = "lightgray"
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
				deviceMenu.optionSelected(menuOption.optionValue)
				menuOption.released();
			}
		}
		/*
		Text{
			id: leftarrow //TODO image
			text: "\u21E6"
			visible: showArrow && align == 'right'
			anchors.right: parent.left
			anchors.rightMargin: -5 - leftarrow.width //TODO
			anchors.verticalCenter: optiontext.verticalCenter
			color: isHeader ? "white" : "black"
		}

		Text{
			id: rightarrow //TODO image
			text: "\u21E8"
			visible: showArrow && align == 'left'
			anchors.left: parent.right
			anchors.leftMargin: -5 - rightarrow.width //TODO
			anchors.verticalCenter: optiontext.verticalCenter
			color: isHeader ? "white" : "black"
		}
		*/
	}
}

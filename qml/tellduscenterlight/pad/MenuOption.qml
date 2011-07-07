import Qt 4.7

import "../mainscripts.js" as MainScripts

Item{
	id: menuOption
	property alias text: optiontext.text
	property string align: ''
	property bool isHeader: false
	property bool showArrow: false
	property int optionWidth: leftarrow.width + optiontext.width + MainScripts.MARGIN_TEXT
	property string optionValue: ''
	height: MainScripts.MENUOPTIONHEIGHT
	width: optionWidth > parent.width ? optionWidth : parent.width

	Rectangle{
		id: menuOptionRect
		anchors.fill: parent
		color: isHeader ? "black" : "lightgray"
		Text{
			id: optiontext
			anchors.centerIn: parent
			color: isHeader ? "white" : "black"
		}
		MouseArea{
			id: optionMouseArea
			anchors.fill: parent
			visible: !isHeader
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
				deviceMenu.optionSelected(menuOption.optionValue)
			}
		}
		Text{
			id: leftarrow //TODO image
			text: "\u21E6"
			visible: showArrow && align == 'right'
			anchors.right: optiontext.left
			anchors.verticalCenter: optiontext.verticalCenter
		}

		Text{
			id: rightarrow //TODO image
			text: "\u21E8"
			visible: showArrow && align == 'left'
			anchors.left: optiontext.right
			anchors.verticalCenter: optiontext.verticalCenter
		}
	}
}

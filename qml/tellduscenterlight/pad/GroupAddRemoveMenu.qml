import Qt 4.7
import "../mainscripts.js" as MainScripts
import ".."

Rectangle{
	id: groupAddRemoveMenu
	height: menuColumn.height
	width: menuColumn.width
	color: "lightgray"
	property string align: ''
	property variant selectedGroup

	Column{
		id: menuColumn

		MenuOption{
			text: "Add/Remove"
			showArrow: true
			align: groupAddRemoveMenu.align
			isHeader: true
		}

		Repeater{
			model: deviceModel
			Rectangle{
				property int optionWidth: optiontext.width + MainScripts.MARGIN_TEXT + 50 //TODO
				height: MainScripts.MENUOPTIONHEIGHT
				width: parent == undefined ? optionWidth : (optionWidth > parent.width ? optionWidth : parent.width)
				color: "lightgray"
				Rectangle{
					id: checkbox
					anchors.left: parent.left
					anchors.leftMargin: 10 //TODO
					width: 20 //TODO
					height: 20 //TODO
					Text{
						anchors.centerIn: parent
						text: "X"
						visible: groupAddRemoveMenu.selectedGroup != undefined && groupAddRemoveMenu.selectedGroup.hasDevice(modelData.id)
					}
					MouseArea{
						anchors.fill: parent
						onClicked: {
							if(groupAddRemoveMenu.selectedGroup.hasDevice(modelData.id)){
								groupAddRemoveMenu.selectedGroup.removeDevice(modelData.id);
							}
							else{
								groupAddRemoveMenu.selectedGroup.addDevice(modelData.id);
							}
						}
					}
				}

				Text{
					id: optiontext
					anchors.left: checkbox.right
					anchors.leftMargin: 10 //TODO
					anchors.verticalCenter: checkbox.verticalCenter
					color: "black"
					text: modelData.name
				}
			}
		}
	}
	//visible: selectedDevice != undefined && selectedDevice.type == MainScripts.GROUPTYPE && grouplist.wasHeld
}

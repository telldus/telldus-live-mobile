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
			model: rawDeviceModel   //TODO groups too?
			Rectangle{
				property int optionWidth: optiontext.width + MainScripts.MARGIN_TEXT + 50 //TODO
				height: groupAddRemoveMenu.selectedGroup != undefined && modelData.id == groupAddRemoveMenu.selectedGroup.id ? 0 : MainScripts.MENUOPTIONHEIGHT  //some protection for group in group loop
				width: optionWidth > parent.width ? optionWidth : parent.width
				color: "lightgray"
				Rectangle{
					id: checkbox
					anchors.left: parent.left
					anchors.leftMargin: 10 //TODO
					width: 20 //TODO
					height: 20 //TODO
					Text{
						id: checked
						anchors.centerIn: parent
						text: "X"
						visible: groupAddRemoveMenu.selectedGroup != undefined && groupAddRemoveMenu.selectedGroup.hasDevice(modelData.id)
					}
					MouseArea{
						anchors.fill: parent
						onClicked: {
							if(checked.visible){
							//if(groupAddRemoveMenu.selectedGroup.hasDevice(modelData.id)){  //TODO why didn't this work? Change back when fixed
								groupAddRemoveMenu.selectedGroup.removeDevice(modelData.id);
								checked.visible = false;
								console.log("visible false");
							}
							else{
								groupAddRemoveMenu.selectedGroup.addDevice(modelData.id);
								checked.visible = true;
								console.log("visible true");
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
}

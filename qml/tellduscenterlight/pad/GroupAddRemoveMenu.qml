import Qt 4.7
import "../mainscripts.js" as MainScripts
import ".."

Menu{
	id: groupAddRemoveMenu
	property variant selectedGroup

	content: menuComp

	Component{
		id: menuComp

		Flickable{
			height: main.height - 200 //TODO
			width:  menuColumn.width
			contentHeight: menuColumn.height
			clip: true
			Column{
				id: menuColumn

				MenuOption{
					text: "Add/Remove from group"
					isHeader: true
				}

				Repeater{
					model: rawDeviceModel

					Item{
						property int optionWidth: optiontext.width + MainScripts.MARGIN_TEXT + 50 //TODO
						height: groupAddRemoveMenu.selectedGroup != undefined && modelData.id == groupAddRemoveMenu.selectedGroup.id ? 0 : MainScripts.MENUOPTIONHEIGHT  //some protection for group in group loop
						width: optionWidth > parent.width ? optionWidth : parent.width
						visible: groupAddRemoveMenu.selectedGroup == undefined || modelData.id != groupAddRemoveMenu.selectedGroup.id
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
									if(selectedGroup.hasDevice(modelData.id)){
										selectedGroup.removeDevice(modelData.id);
										checked.visible = false;
									}
									else{
										selectedGroup.addDevice(modelData.id);
										checked.visible = true;
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
	}
}

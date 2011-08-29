import Qt 4.7
import "../mainscripts.js" as MainScripts
import ".."

Menu{
	id: groupAddRemoveMenu
	property variant selectedGroup

	content: Column{
		MenuOption{
			text: "Add/Remove from group"
			isHeader: true
		}

		Flickable{
			height: Math.min(main.height/4*3, deviceModel.height)
			width:  parent.width
			contentHeight: deviceModel.height
			clip: true


			Column {
				id: deviceModel
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

		MenuSeparator {}

		MenuOption {
			text: "Remove group"
			onSelected: confirm.show();
			ConfirmationDialog {
				id: confirm
				message: 'Are you sure you want to remove this group?'
				onAccepted: {
					//We hide the menu since the call to removeDevice is asynchronous and can happen later.
					groupAddRemoveMenu.hide();
					deviceModelController.removeDevice(selectedGroup.id)
				}
			}
		}
	}
}

import Qt 4.7
import "../mainscripts.js" as MainScripts
import ".."

DeviceElement{
	id: deviceElement
	showMenu: true

	MouseArea{
		anchors.fill: parent
		visible: showMenu
		onClicked: {
			//TODO will this work (or is it too small, hard to avoid dim for example?), or press (for a while, "wasHeld") and then release to trigger this?
			selectedDevice = device;
			if(device.type == MainScripts.GROUPTYPE){
				var comp = Qt.createComponent("GroupContentMenu.qml");  //this menu needs to be added in script, when in QML only groups in groups are messed up
				var groupContentMenu = comp.createObject(deviceElement);
				groupContentMenu.show();
			}
			else{
				deviceMenu.show();
			}
		}
		onPressAndHold: {
			if(device.type == MainScripts.GROUPTYPE){
				selectedDevice = device;

				var comp = Qt.createComponent("GroupAddRemoveMenu.qml");
				var groupAddRemoveMenu = comp.createObject(deviceElement, {"selectedGroup": device});
				groupAddRemoveMenu.selectedGroup = device;
				groupAddRemoveMenu.show();
			}
		}
	}

	DefaultMenu{
		id: deviceMenu
		headerText: "Device options"

		Component{
			id: deviceOptionsComp
			Column{
				MenuOption{
					text: "Toggle favorite"
					onSelected: {
						deviceMenu.hide();
						if(selectedDevice.isFavorite){
							selectedDevice.isFavorite = false;
						}
						else{
							selectedDevice.isFavorite = true;
						}
						selectedDevice = undefined;
					}
					visible: !hideFavoriteToggle
				}
				MenuOption{
					text: "Add to group"
					onSelected: {
						addToGroupMenu.show();
					}

					DefaultMenu{
						id: addToGroupMenu
						Component{
							id: footer
							Column {
								MenuSeparator {}
								MenuOption{
									text: "Add to new group"
									optionValue: "new"
									MouseArea{
										anchors.fill: parent
										onClicked: createGroup.show()
									}
									CreateGroupMenu {
										id: createGroup
										addDevice: device
									}
								}
							}
						}

						headerText: "Select group"
						footerComponent: footer

						model: groupModel

						onOptionSelected: {
							var group = deviceModelController.findDevice(value);
							group.addDevice(selectedDevice.id)

							selectedDevice = undefined
							addToGroupMenu.hide();
							deviceMenu.hide();
						}
					}
				}
				MenuOption{
					text: "Edit device"
					onSelected: {
						editDevice.visible = true;
						editDevice.update();
						deviceMenu.hide();
					}
				}
			}
		}

		footerComponent: deviceOptionsComp
	}
}

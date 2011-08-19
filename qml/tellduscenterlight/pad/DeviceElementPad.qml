import Qt 4.7
import "../mainscripts.js" as MainScripts
import ".."

DeviceElement{
	id: deviceElement
	showMenu: true

	//TODO kanske ha den här ändå, men varför syns den direkt?
/*
	GroupAddRemoveMenu{
		id: groupAddRemoveMenu
	}
*/
	MouseArea{
		anchors.fill: parent
		visible: showMenu
		onClicked: {
			//TODO will this work (or is it too small, hard to avoid dim for example?), or press (for a while, "wasHeld") and then release to trigger this?
			//if(selectedPane == MainScripts.FULL_DEVICE){
				selectedDevice = device;
				//var menu = deviceMenu;
				//deviceMenu.assignTo = deviceElement
				if(device.type == MainScripts.GROUPTYPE){

					var comp = Qt.createComponent("GroupContentMenu.qml");  //TODO this belongs to pad, move...
					/*
					if(comp.status != Component.Ready) {
						console.log(comp.errorString())
					}
					else{
						console.log("Was ready");
					}
					*/

					var groupContentMenu = comp.createObject(deviceElement); //, {"selectedGroup": device});
					//menu = groupContentMenu;
					//groupContentMenu.selectedGroup = device;
					//main.groupContentMenu = groupContentMenu;
					groupContentMenu.show();
				}
				else{
					deviceMenu.show(); // visible = true
				}

				//menuX(deviceElement, menu);
				//menu.y = deviceElement.y + deviceElement.height/4
			//}
		}
		onPressAndHold: {
			if(device.type == MainScripts.GROUPTYPE){ //selectedPane == MainScripts.FULL_DEVICE &&
				/*
				if(main.groupAddRemoveMenu != undefined){
					main.groupAddRemoveMenu.destroy(); //remove already displayed menu
				}
				*/

				selectedDevice = device;

				var comp = Qt.createComponent("GroupAddRemoveMenu.qml");
				if(comp.status != Component.Ready) {
					console.log(comp.errorString())
				}
				else{
					console.log("Was ready");
				}
				var groupAddRemoveMenu = comp.createObject(deviceElement, {"selectedGroup": device});
				groupAddRemoveMenu.selectedGroup = device;
				groupAddRemoveMenu.show();
				/*
				var comp = Qt.createComponent("pad/GroupAddRemoveMenu.qml");    //TODO this belongs to pad, move...

				var groupAddRemoveMenu = comp.createObject(main, {"selectedGroup": device}); //TODO set initial values here (and remove undefined-checks)...
				//menuX(deviceElement, groupAddRemoveMenu);

				groupAddRemoveMenu.selectedGroup = device;
				groupAddRemoveMenu.y = deviceElement.y + deviceElement.height/4
				main.groupAddRemoveMenu = groupAddRemoveMenu;
				*/
			}
		}
	}

	DefaultMenu{
		id: deviceMenu
		headerText: "Header"

		model: ListModel{
			ListElement{
				text: "Toggle favorite"
				optionValue: 'addfavorite'
				hideIfFavorite: true //TODO
			}
			ListElement{
				text: "Add to group"
				optionValue: 'addtogroup'
			}
			ListElement{
				text: "Edit device"
				optionValue: 'editdevice'
			}
		}

		onOptionSelected: {
			addToGroupMenu.hide();
			if(value == "addtogroup"){				
				addToGroupMenu.show(); //visible = true
			}
			else if(value == "editdevice"){
				editDevice.visible = true;
				editDevice.update();
				deviceMenu.hide();
			}
			else if(value == "addfavorite"){
				deviceMenu.hide();
				if(selectedDevice.isFavorite){
					selectedDevice.isFavorite = false;
				}
				else{
					selectedDevice.isFavorite = true;
				}
				selectedDevice = undefined;
			}
			//deviceMenu.hide(); // visible = false;
		}
		//visible: selectedDevice != undefined && selectedDevice.type == MainScripts.DEVICETYPE

		DefaultMenu{
			id: addToGroupMenu
			//assignTo: deviceMenu
			Component{
				id: footer
				MenuOption{
					text: "Add to new group"
					optionValue: "new"
					//align: deviceMenu.align
					width: 100 //TODO
					MouseArea{
						anchors.fill: parent
						onClicked: {
							//addToGroupMenu.visible = false
							console.log("TODO ADD NEW GROUP, set name and stuff, and then add this device there");
							selectedDevice = undefined;
						}
					}
				}
			}

			/*anchors.top: deviceMenu.bottom
			anchors.topMargin: 10 //TODO
			anchors.horizontalCenter: deviceMenu.horizontalCenter
			*/
			headerText: "Select group"
			footerComponent: footer

			model: groupModel

			onOptionSelected: {
				//addToGroupMenu.visible = false  //TODO
				var group = deviceModelController.findDevice(value);
				console.log("Should have added to " + group.id)
				group.addDevice(selectedDevice.id)

				selectedDevice = undefined
				addToGroupMenu.hide();
				deviceMenu.hide();
			}

			//visible: false
		}
	}
}

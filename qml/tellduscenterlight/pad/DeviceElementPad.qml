import Qt 4.7
import "../mainscripts.js" as MainScripts
import ".."

DeviceElement{
	id: deviceElement
	showMenu: true

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
				console.log("Should have added to " ); //+ group.id)
				group.addDevice(selectedDevice.id)

				selectedDevice = undefined
				addToGroupMenu.hide();
				deviceMenu.hide();
			}

			//visible: false
		}
	}
}

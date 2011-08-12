import Qt 4.7
import "../mainscripts.js" as MainScripts
import ".."

DeviceElement{
	id: deviceElement
	MouseArea{
		anchors.fill: parent
		onClicked: {
			//TODO will this work (or is it too small, hard to avoid dim for example?), or press (for a while, "wasHeld") and then release to trigger this?
			//if(selectedPane == MainScripts.FULL_DEVICE){
				selectedDevice = device;
				var menu = deviceMenu;
				if(device.type == MainScripts.GROUPTYPE){
					var comp = Qt.createComponent("GroupContentMenu.qml");
					var groupContentMenu = comp.createObject(main, {"selectedGroup": device});
					menu = groupContentMenu;
					groupContentMenu.selectedGroup = device;
					main.groupContentMenu = groupContentMenu;
				}
				menuX(deviceElement, menu);
				menu.y = deviceElement.y + deviceElement.height/4
			//}
		}
		onPressAndHold: {
			if(device.type == MainScripts.GROUPTYPE){ //selectedPane == MainScripts.FULL_DEVICE &&
				if(main.groupAddRemoveMenu != undefined){
					main.groupAddRemoveMenu.destroy(); //remove already displayed menu
				}

				selectedDevice = device;
				var comp = Qt.createComponent("GroupAddRemoveMenu.qml");

				var groupAddRemoveMenu = comp.createObject(main, {"selectedGroup": device}); //TODO set initial values here (and remove undefined-checks)...
				menuX(deviceElement, groupAddRemoveMenu);

				groupAddRemoveMenu.selectedGroup = device;
				groupAddRemoveMenu.y = deviceElement.y + deviceElement.height/4
				main.groupAddRemoveMenu = groupAddRemoveMenu;
			}
		}
	}
}

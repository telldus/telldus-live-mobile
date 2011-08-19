/*
import Qt 4.7
import ".."

Menu{
	id: groupContentMenu

	Rectangle{
	height: 200 //TODO
	width: 300 //TODO
	color: 'red'
	}
	//color: "lightgray"
	//property string align: ''
	clip: true
	property variant selectedGroup
*/
	//property int deviceElementLeftX: 0
	//property int deviceElementRightX: 0
	//x: deviceElementRightX + groupContentMenu.width >= main.width ? deviceElementLeftX - groupContentMenu.width : deviceElementRightX

	/*
	onXChanged: {
		deviceMenu.deviceElementLeftX = groupContentMenu.x
		deviceMenu.deviceElementRightX = groupContentMenu.x + groupContentMenu.width
		if(groupContentMenu.deviceElementRightX + groupContentMenu.width >= main.width){
			groupContentMenu.align = 'left'
		}
		else{
			groupContentMenu.align = 'right'
		}
	}
	*/

	/*
	MenuOption{
		id: groupContentMenuHeaderSensor
		text: "Sensors"
		showArrow: true
		align: groupContentMenu.align
		isHeader: true
		z: 5
		visible: selectedGroup.sensors != undefined && selectedGroup.sensors.count > 0
	}
	ListView {
		id: groupsensorlist
		height: parent.height - groupContentMenuHeader.height
		width: 300 //TODO
		anchors.top: groupContentMenuHeader.bottom
		model: selectedGroup.groupContentMenuHeaderSensor

		delegate: SensorElement {}
	}
	*/
/*
	content: compMenu

	Component{
		id: compMenu

		Item{
			MenuOption{
				id: groupContentMenuHeader
				text: "Devices"
				//showArrow: true //!groupContentMenuHeaderSensor.visible
				//align: groupContentMenu.align
				isHeader: true
				z: 5
			}

			ListView {
				id: groupdevicelist
				height: parent.height - groupContentMenuHeader.height
				width: 300 //TODO
				anchors.top: groupContentMenuHeader.bottom

				model: selectedGroup != undefined ? selectedGroup.devices() : undefined //TODO why is this needed?

				/*
				delegate: DeviceElementPad {
					hideFavoriteToggle: true
				}
				*/
/*			}
		}
	}
}
*/

import Qt 4.7
import ".."
import "../mainscripts.js" as MainScripts


Menu{

	id: groupContentMenu
	//property string align: (deviceMenu.x + deviceMenu.width) >= main.width ? 'left' : 'right'
	//property bool menuShowArrow: false
	//property int deviceElementLeftX: 0
	//property int deviceElementRightX: 0
	//width: menuComp.width
	//height: menuComp.height
	//x: deviceElementRightX + deviceMenu.width >= main.width ? deviceElementLeftX - deviceMenu.width : deviceElementRightX

//	Menu{
//		assignTo: visualDevice

		content: menuComp //menuComp
//	}

	Component{
		id: menuComp

		Column{
			id: menuColumn
			width: MainScripts.LISTWIDTH

			MenuOption{
				id: groupContentMenuHeader
				text: "Devices"
				//showArrow: true //!groupContentMenuHeaderSensor.visible
				//align: groupContentMenu.align
				isHeader: true
				z: 5
			}

			Repeater {
				id: groupdevicelist
				//height: 300  //TODO parent.height - groupContentMenuHeader.height
				//width: 300 //TODO

				//model: selectedGroup != undefined ? selectedGroup.devices() : undefined //TODO why is this needed?

				model: device.devices() //selectedGroup.devices()
				delegate: DeviceElementPad { //TODO DeviceElementPad, to get menus etc too
					//hideFavoriteToggle: true
				}
			}
		}
	}
}

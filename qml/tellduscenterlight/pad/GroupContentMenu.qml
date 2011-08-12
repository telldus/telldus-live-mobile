import Qt 4.7
import ".."

Rectangle{
	id: groupContentMenu

	height: 200 //TODO
	width: 300 //TODO
	color: "lightgray"
	property string align: ''
	clip: true
	property variant selectedGroup
	property int deviceElementLeftX: 0
	property int deviceElementRightX: 0
	x: deviceElementRightX + groupContentMenu.width >= main.width ? deviceElementLeftX - groupContentMenu.width : deviceElementRightX

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

	MenuOption{
		id: groupContentMenuHeaderSensor
		text: "Sensors"
		showArrow: true
		align: groupContentMenu.align
		isHeader: true
		z: 5
		visible: true //TODO selectedGroup.sensors != undefined && selectedGroup.sensors.count > 0
	}
	ListView {
		id: groupsensorlist
		height: parent.height - groupContentMenuHeader.height
		width: 300 //TODO
		anchors.top: groupContentMenuHeader.bottom
		model: selectedGroup.groupContentMenuHeaderSensor

		delegate: SensorElement {}
	}
	MenuOption{
		id: groupContentMenuHeader
		text: "Devices"
		showArrow: !groupContentMenuHeaderSensor.visible
		align: groupContentMenu.align
		isHeader: true
		z: 5
	}
	ListView {
		id: groupdevicelist
		height: parent.height - groupContentMenuHeader.height
		width: 300 //TODO
		anchors.top: groupContentMenuHeader.bottom

		model: selectedGroup.devices

		delegate: DeviceElement {
			hideFavoriteToggle: true
		}
	}
}

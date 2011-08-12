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
		id: groupContentMenuHeader
		text: "Devices"
		showArrow: true
		align: groupContentMenu.align
		isHeader: true
		z: 5
	}
	ListView {
		id: groupdevicelist
		height: parent.height - groupContentMenuHeader.height
		width: 300 //TODO
		anchors.top: groupContentMenuHeader.bottom

		model: deviceModel //TODO not all devices of course: groupContentMenu.selectedGroup != undefined ? groupContentMenu.selectedGroup.deviceModel : undefined

		delegate: DeviceElement {
			hideFavoriteToggle: true
		}
	}
}

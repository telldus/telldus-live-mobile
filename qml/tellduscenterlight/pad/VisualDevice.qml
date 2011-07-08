import Qt 4.7

Rectangle {
	id: visualDevice
	height: 40
	width: 40
	color: "red"
	//make this default, then the content and size may differ, depending on for exampele sensor or device, and onclick event, but move etc common

	//TODO edit mode? When it's ok to move around stuff?

	MouseArea {
		property int movedX: 0
		property int movedY: 0
		anchors.fill: parent
		drag.target: visualDevice
		drag.axis: Drag.XandYAxis
		drag.minimumX: 0
		drag.maximumX: 800 //TODO
		onPressed: {
			movedX = visualDevice.x
			movedY = visualDevice.y
			console.log(mouseX)
		}

		onClicked: {
			console.log("clicked") //TODO show info bubble
			infoBubble.visible = !infoBubble.visible
		}
		onReleased: {
			if(movedX != visualDevice.x || movedY != visualDevice.y){
				console.log("HAS MOVED")
				//TODO store this value
			}
		}
		onPressAndHold: {
			console.log("Pressed and held"); //TODO: menu with delete option
			visualDeviceMenu.visible = true
		}
	}

	DefaultMenu{
		//TODO here or only one for whole layout?
		id: visualDeviceMenu

		model: ListModel{
			ListElement{
				text: "Device options"
				showArrow: true
				isHeader: true
			}
			ListElement{
				text: "Remove from layout"
				optionValue: 'removefromlayout'
			}
		}

		onOptionSelected: {
			addToGroupMenu.visible = false
			if(value == "removefromlayout"){
				visualDevice.destroy()
			}
		}
		visible: false
	}

	Rectangle{
		id: infoBubble
		height: 200 //TODO
		width: 200 //TODO
		anchors.bottom: visualDevice.top
		anchors.bottomMargin: 110
		anchors.horizontalCenter: visualDevice.horizontalCenter

		Rectangle{
			color: "white"
			height: 200
			width: parent.width
			anchors.top: parent.top
			z:2
		}
		Rectangle{
			id: bubblebottom
			height: 141  //TODO check out transformOrigin if this should be used at all
			width: 141
			rotation: 45
			color: "white"
			anchors.verticalCenter: parent.bottom
			anchors.horizontalCenter: parent.horizontalCenter
			z:1
		}

		visible:false

	}
}

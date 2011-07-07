import Qt 4.7

Rectangle {
	id: visualDevice
	height: 40
	width: 40
	color: "red"
	//make this default, then the content and size may differ, depending on for exampele sensor or device, and onclick event, but move etc common

	//TODO edit mode? When it's ok to move around stuff?

	MouseArea {
		anchors.fill: parent
		drag.target: visualDevice
		drag.axis: Drag.XandYAxis
		drag.minimumX: 0
		drag.maximumX: 800 //TODO
		onClicked: {
			console.log("clicked") //TODO show info bubble
		}
		onReleased: {
			console.log("Well?", mouse.wasHeld)  //TODO ccheck drag here, but only if it has been moved,
		}
		onPressAndHold: {
			console.log("Pressed and held"); //TODO: menu with delete option
		}
	}
}

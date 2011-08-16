import Qt 4.7

Popup {
	property bool modal: false
	id:menu
	preferredPosition: horizontal
	z: parent.z+2

	Rectangle {
		id: shadow
		color: "black"
		opacity: 0.3
		parent: menu.parent
		width: root.width
		height: root.height
		visible: menu.visible && modal
		z: menu.z-1
	}
	onVisibleChanged: {
		if (visible) {
			var coord = root.mapToItem(menu.parent,0,0)
			shadow.x = coord.x
			shadow.y = coord.y
		}
	}

	MouseArea {
		id: mouseArea
		enabled: menu.visible
		parent: modalArea
		anchors.fill: parent
		onPressed: {
			var coord = menu.mapFromItem(mouseArea, mouse.x, mouse.y);
			if (menu.coordInside(coord)) {
				//Pass on mouse events
				mouse.accepted = false;
			} else {
				menu.visible = false;
				if (!modal) {
					mouse.accepted = false;
				}
			}
		}
	}

}

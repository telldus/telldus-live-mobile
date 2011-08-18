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
		visible: menu.open && modal
		z: menu.z-1
	}
	onOpenChanged: {
		if (open) {
			var coord = root.mapToItem(menu.parent,0,0)
			shadow.x = coord.x
			shadow.y = coord.y
		}
	}

	MouseArea {
		id: mouseArea
		enabled: menu.open
		parent: modalArea
		anchors.fill: parent
		onPressed: {
			var coord = menu.mapFromItem(mouseArea, mouse.x, mouse.y);
			if (menu.coordInside(coord)) {
				//Pass on mouse events
				mouse.accepted = false;
			} else {
				menu.hide();
				if (!modal) {
					mouse.accepted = false;
				}
			}
		}
	}

}

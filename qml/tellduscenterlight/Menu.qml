import Qt 4.7

Item {
	property variant assignTo: parent
	property bool modal: false

	property alias content: popup.content
	property alias open: popup.open

	id:menu

	MouseArea {
		id: mouseArea
		enabled: popup.open
		parent: modalArea
		anchors.fill: parent
		onPressed: {
			var coord = popup.mapFromItem(mouseArea, mouse.x, mouse.y);
			if (popup.coordInside(coord)) {
				//Pass on mouse events
				mouse.accepted = false;
			} else {
				popup.hide();
				if (!modal) {
					mouse.accepted = false;
				}
			}
		}
	}

	Item {
		id: pseudoAssign
		parent: modalArea
		width: assignTo.width
		height: assignTo.height
	}
	Rectangle {
		id: shadow
		color: "black"
		opacity: 0.3
		parent: modalArea
		width: modalArea.width
		height: modalArea.height
		visible: popup.open && modal
	}


	Popup {
		id:popup
		parent: modalArea
		assignTo: pseudoAssign
		preferredPosition: horizontal
		containInside: modalArea

		onOpenChanged: {
			if (open) {
				var coord = menu.assignTo.mapToItem(modalArea,0,0)
				pseudoAssign.x = coord.x
				pseudoAssign.y = coord.y
			}
		}

	}
	function show() { popup.show() }
	function hide() { popup.hide() }
	function toggle() { popup.toggle() }
}

import Qt 4.7

BorderImage {
	property variant content
	property variant assignTo: parent

	id: popup
	source: "tooltip.png"
	border { left: 45; top: 8; right: 10; bottom: 20 }
	visible:false

	width: contentObject.width + (border.right * 2)
	height: contentObject.height + border.top + border.bottom

	Loader {
		id: contentObject
		x: popup.border.right
		y: popup.border.top
		sourceComponent: content
	}

	Item {
		states: [
			State {
				name: ""
				AnchorChanges { target: popup; anchors.bottom: assignTo.top }
			},
			State {
				name: "lower";
				when: assignTo.y < popup.height
				AnchorChanges {
					target: popup
					anchors.bottom: undefined
					anchors.top: assignTo.bottom
				}
			}
		]
	}
	Item {
		states: [
			State {
				name: ""
				AnchorChanges { target: popup; anchors.left: assignTo.left }
			},
			State {
				name: "right"
				when: assignTo.x > (assignTo.parent.width - popup.width)
				AnchorChanges {
					target:  popup
					anchors.left: undefined
					anchors.right: assignTo.right
				}
			}

		]
	}
}

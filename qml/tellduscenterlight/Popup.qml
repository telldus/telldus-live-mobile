import Qt 4.7

BorderImage {
	//My Enums
	property string vertical: "vertical"
	property string horizontal: "horizontal"

	property variant content
	property variant assignTo: parent
	property string preferredPosition: vertical

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
		id: properties
		property bool isHorizontal: popup.preferredPosition == popup.horizontal
		property bool isVertical: !isHorizontal

		property bool isRight: assignTo.x > (assignTo.parent.width - popup.width)
		property bool isLeft: assignTo.x > (assignTo.parent.width - popup.width - assignTo.width)

		property bool isOver: assignTo.y > (assignTo.parent.height - popup.height)
		property bool isUnder: assignTo.y < popup.height
	}
	Item {
		states: [
			State {
				when: !properties.isOver && properties.isHorizontal
				AnchorChanges { target: popup; anchors.top: assignTo.top }
			},
			State {
				name: "upper"
				when: properties.isOver && properties.isHorizontal
				AnchorChanges { target: popup; anchors.bottom: assignTo.bottom }
			},
			State {
				when: !properties.isUnder && properties.isVertical
				AnchorChanges { target: popup; anchors.bottom: assignTo.top }
			},
			State {
				name: "under";
				when: properties.isUnder && properties.isVertical
				AnchorChanges { target: popup; anchors.bottom: undefined; anchors.top: assignTo.bottom }
			}
		]
	}
	Item {
		states: [
			State {
				when: !properties.isLeft && properties.isHorizontal
				AnchorChanges { target: popup; anchors.left: assignTo.right }
			},
			State {
				name: "left"
				when: properties.isLeft && properties.isHorizontal
				AnchorChanges { target: popup; anchors.left: undefined; anchors.right: assignTo.left; }
			},
			State {
				when: !properties.isRight && properties.isVertical
				AnchorChanges { target: popup; anchors.left: assignTo.left }
				PropertyChanges { target: popup; anchors.leftMargin: Math.max(-25, -assignTo.x) }
			},
			State {
				name: "right"
				when: properties.isRight && properties.isVertical
				AnchorChanges { target:  popup; anchors.left: undefined; anchors.right: assignTo.right; }
				PropertyChanges { target: popup; anchors.rightMargin: -25 }
			}

		]
	}
}

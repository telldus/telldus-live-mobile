import Qt 4.7

Item {
	//My Enums
	property string vertical: "vertical"
	property string horizontal: "horizontal"

	property Component content
	property variant assignTo: parent
	property variant containInside: assignTo.parent
	property string preferredPosition: vertical

	id: popup
	width: contentLoader.width
	height: contentLoader.height
	visible:false


	Item {
		id: properties
		property bool isHorizontal: popup.preferredPosition == popup.horizontal
		property bool isVertical: !isHorizontal

		property bool isRight: assignTo.x > (containInside.width - popup.width)
		property bool isLeft: assignTo.x > (containInside.width - popup.width - assignTo.width)

		property bool isOver: assignTo.y > (containInside.height - popup.height)
		property bool isUnder: assignTo.y < popup.height

	}

	Loader {
		id: contentLoader
		sourceComponent: popup.visible ? contentComponent : undefined
	}
	Component {
		id: contentComponent
		Item {
			width: borderImage.width
			height: borderImage.height
			BorderImage {
				id: borderImage
				source: "tooltip.png"
				border { left: 45; top: 8; right: 10; bottom: 20 }

				width: contentObject.width + (border.right * 2)
				height: contentObject.height + border.top + border.bottom

				Item {
					id: rotationProperties
					property int origin: Math.min(popup.height, popup.width)/2
				}

				transform: [
					Rotation { id: rotationX; origin.x: popup.width/2; origin.y: popup.height/2; axis { x: 1; y: 0; z: 0} },
					Rotation { id: rotationY; origin.x: popup.width/2; origin.y: popup.height/2; axis { x: 0; y: 1; z: 0} }
				]
				Item {
					states: [
						State {
							when: properties.isUnder && properties.isVertical
							PropertyChanges { target: rotationX; angle: 180 }
							PropertyChanges { target: contentObject; y: borderImage.border.bottom }
						}
					]
				}
				Item {
					states: [
						State {
							name: "right"
							when: properties.isRight && properties.isVertical
							PropertyChanges { target: rotationY; angle: 180; }
						}
					]
				}
			}

			Loader {
				id: contentObject
				x: borderImage.border.right
				y: borderImage.border.top
				sourceComponent: content
			}
		}
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
				AnchorChanges { target: popup; anchors.top: assignTo.bottom }
			}
		]
		transitions: Transition {
			AnchorAnimation { duration: 100 }
		}
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
				AnchorChanges { target: popup; anchors.right: assignTo.left; }
			},
			State {
				when: !properties.isRight && properties.isVertical
				AnchorChanges { target: popup; anchors.left: assignTo.left }
				PropertyChanges { target: popup; anchors.leftMargin: Math.max(-25, -assignTo.x) }
			},
			State {
				name: "right"
				when: properties.isRight && properties.isVertical
				AnchorChanges { target:  popup; anchors.right: assignTo.right; }
				PropertyChanges { target: popup; anchors.rightMargin: Math.max(-25, -(containInside.width - assignTo.x - assignTo.width)) }
			}

		]
		transitions: Transition {
			AnchorAnimation { duration: 100 }
		}

	}
}

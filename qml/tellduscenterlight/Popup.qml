import Qt 4.7

Item {
	//My Enums
	property string vertical: "vertical"
	property string horizontal: "horizontal"

	property Component content
	property variant assignTo: parent
	property variant containInside: assignTo.parent != undefined ? assignTo.parent : assignTo //TODO, set to something else default (when undefined)
	property bool open: false
	property string preferredPosition: vertical

	id: popup
	width: properties.isHorizontal ? contentLoader.height : contentLoader.width
	height: properties.isHorizontal ? contentLoader.width : contentLoader.height

	opacity: open ? 1 : 0
	Behavior on opacity { NumberAnimation{ duration: 200 } }
	visible: opacity > 0 ? true : false

	Item {
		id: properties
		property bool isHorizontal: popup.preferredPosition == popup.horizontal
		property bool isVertical: !isHorizontal

		property bool isRight: assignTo.x > (containInside.width - contentLoader.width)
		property bool isLeft: assignTo.x > (containInside.width - contentLoader.height - assignTo.width)

		property bool isOver: assignTo.y > (containInside.height - contentLoader.width + 25)
		property bool isUnder: assignTo.y < contentLoader.height

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

				property int hMargin: border.right * 2
				property int vMargin: border.top + border.bottom

				width: contentObject.width + hMargin
				height: contentObject.height + vMargin

				MouseArea {
					//Used to prevent clicking things behind the popup
					anchors.fill: parent
				}

				Item {
					id: rotationProperties
					property int origin: (parent.height > parent.width ? Math.max(parent.height, parent.width) : Math.min(parent.height, parent.width))/2
				}

				transform: [
					Rotation { id: rotationX; origin.x: borderImage.width/2; origin.y: borderImage.height/2; axis { x: 1; y: 0; z: 0} },
					Rotation { id: rotationY; origin.x: borderImage.width/2; origin.y: borderImage.height/2; axis { x: 0; y: 1; z: 0} },
					Rotation { id: rotationZ; origin.x: rotationProperties.origin; origin.y: rotationProperties.origin; axis { x: 0; y: 0; z: 1} }
				]
				Item {
					states: [
						State {
							when: properties.isOver && properties.isHorizontal
							PropertyChanges { target: rotationY; angle: 180 }
						},
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
							name: "left"
							when: properties.isLeft && properties.isHorizontal
							PropertyChanges { target: rotationX; angle: 180 }
							PropertyChanges { target: contentObject; x: borderImage.border.top }
						},
						State {
							name: "right"
							when: properties.isRight && properties.isVertical
							PropertyChanges { target: rotationY; angle: 180; }
						}
					]
				}
				Item { //Only for isHorizontal
					states: [
						State {
							name: ""
						},
						State {
							when: properties.isHorizontal
							PropertyChanges { target: rotationZ; angle: 90 }
							PropertyChanges { target: borderImage; height: contentObject.width + vMargin; width: contentObject.height + hMargin }
						}
					]
				}
			}

			Loader {
				id: contentObject
				x: properties.isHorizontal ? borderImage.border.bottom : borderImage.border.right
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
				PropertyChanges { target: popup; anchors.topMargin: Math.max(-25, -assignTo.y) }
			},
			State {
				name: "upper"
				when: properties.isOver && properties.isHorizontal
				AnchorChanges { target: popup; anchors.top: assignTo.bottom }
				PropertyChanges { target: popup; anchors.topMargin: -contentLoader.width+Math.min(25,containInside.height - assignTo.y - assignTo.height) }
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
				AnchorChanges { target: popup; anchors.left: assignTo.left; }
				PropertyChanges { target:popup; anchors.leftMargin: -contentLoader.height }
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

	function show() {
		open = true
	}
	function hide() {
		open = false
	}
	function toggle() {
		open = !open
	}

	function coordInside(coord) {
		if (coord.x < 0 || coord.y < 0) {
			return false;
		}
		if (preferredPosition == vertical) {
			if (coord.x > menu.width || coord.y > menu.height) {
				return false;
			}
			return true;
		}
		if (coord.x > menu.height || coord.y > menu.width) {
			return false;
		}
		return true;
	}
}

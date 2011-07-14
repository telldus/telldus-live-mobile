import Qt 4.7

Rectangle{
	id: tabButton
	property string name: ''
	property int selectionTabId
	signal clicked()
	signal released()
	height: 40 //TODO
	width: parent.width
	color: buttonMouseArea.pressed ? 'blue' : 'gray'

	Text{
		anchors.centerIn: parent
		text: name
	}
	MouseArea{
		id: buttonMouseArea
		anchors.fill: parent
		onClicked: {
			tabButton.clicked();
		}
		onPressAndHold: {
			if(selectionTabId > 0){
				tabEditMenu.visible = true;
			}
		}
	}
	Rectangle{
		id: tabEditMenu
		anchors.left: tabButton.right
		anchors.top: tabButton.top
		width: tabEditMenuColumn.width
		height: tabEditMenuColumn.height
		color: "lightgray"
		Column{
			id: tabEditMenuColumn

			MenuOption{
				text: "Edit Tab"
				showArrow: false
				optionValue: 'todo'
				align: 'right'
				isHeader: true
			}

			Rectangle{
				height: updateNameButtonRect.height
				width: updateNameTextInput.width + updateNameButtonRect.width
				color: "white"
				TextInput{
					id: updateNameTextInput
					anchors.left: parent.left
					text: name
					height: 40 //TODO
					width: 100 //TODO
					anchors.verticalCenter: parent.verticalCenter  //TODO
					cursorVisible: true  //TODO set focus...
					focus: true
				}
				Rectangle{
					id: updateNameButtonRect
					height: updateNameTextInput.height
					width: updateNameButton.width
					anchors.left: updateNameTextInput.right
					anchors.top: parent.top
					Text{
						id: updateNameButton
						text: "Update name"
						anchors.verticalCenter: parent.verticalCenter
					}
					MouseArea{
						id: updateNameMouseArea
						anchors.fill: parent
						hoverEnabled: true
						onClicked: {
							name = updateNameTextInput.text
							tabEditMenu.visible = false
						}
					}
					color: updateNameMouseArea.pressed ? "blue" : updateNameMouseArea.containsMouse ? "darkgray" : "lightgray"
				}
			}

			MenuOption{
				text: "Delete Tab"
				showArrow: false
				align: 'right'
				isHeader: false
				onReleased: {
					tabButton.released()
					tabEditMenu.visible = false
				}
			}
		}

		visible: false
	}
}

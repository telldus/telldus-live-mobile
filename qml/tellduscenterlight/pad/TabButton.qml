import Qt 4.7
import ".."

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
			if(selectionTabId > 0 && editable){
				tabEditMenu.show();
			}
		}
	}

	Menu{
		id: tabEditMenu
		content: Column {
			Component.onCompleted: {
				tabName.forceActiveFocus();
			}
			MenuHeader {
				text: "Edit tab"
			}

			Rectangle {
				color: 'white'
				height: tabName.height + 10
				width: parent.width
				TextInput {
					id: tabName
					width: parent.width - 10
					anchors.centerIn: parent
					text: name
				}
			}

			MenuOption {
				text: "Update name"
				onSelected: {
					tabEditMenu.hide()
					name = tabName.text
				}
			}
			MenuSeparator {}

			MenuOption{
				text: "Delete Tab"
				isHeader: false
				onSelected: {
					tabButton.released()
					tabEditMenu.hide();
				}
			}

			//TODO upload background image somehow...
		}
	}
}

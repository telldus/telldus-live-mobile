import Qt 4.7
import ".."
import "../mainscripts.js" as MainScripts

Rectangle{
	id: tabButton
	property string name: ''
	property int selectionTabId
	signal clicked()
	signal released()
	height: MainScripts.DEFAULTBUTTONHEIGHT
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

			MenuOption {
				text: "Pick background image"
				onSelected: {
					tabEditMenu.hide();
					tabEditMenu.forceActiveFocus(); //TODO Trying to remove keyboard again...
					tabName.focus = false; //TODO same as above, seems to be a known bug
					//TODO: show image pick-dialog
				}
				visible: false //TODO visible when image pick-dialog is created
			}

			MenuSeparator {}

			MenuOption{
				text: "Delete Layout"
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

import Qt 4.7
import Telldus 1.0
import ".."

Menu {
	property Device addDevice: null

	id: createGroup
	modal: true
	content: Column {
		Component.onCompleted: { groupName.forceActiveFocus(); }
		MenuHeader {
			text: "Group name:"
		}
		Rectangle {
			color: 'white'
			height: groupName.height + 10
			width: parent.width
			TextInput {
				id: groupName
				width: parent.width - 10
				anchors.centerIn: parent
			}
		}
		MenuOption {
			text: "Create"
			onSelected: {
				createGroup.hide()
				deviceModelController.createGroup(groupName.text, addDevice);
			}
		}
	}
}

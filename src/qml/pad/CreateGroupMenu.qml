import Qt 4.7
import Telldus 1.0
import ".."

Menu {
	property Device addDevice: null

	id: createGroup
	modal: true
	content: Column {
		Component.onCompleted: {
			clients.selectedClient = clientModel.get(0).id
			groupName.forceActiveFocus();
		}
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
		MenuHeader {
			text: "Select a location:"
		}
		Repeater {
			id: clients
			property int selectedClient: 0
			model: clientModel
			delegate: MenuOption {
				Rectangle {
					anchors.left: parent.left
					anchors.leftMargin: 5
					anchors.verticalCenter: parent.verticalCenter
					width: 10
					height: 10

					Rectangle {
						visible: clients.selectedClient == client.id
						radius: 2
						color: "black"
						anchors.centerIn: parent
						width: 4
						height: 4
					}
				}

				text: client.name
				onSelected: clients.selectedClient = client.id
			}
		}

		MenuSeparator {}
		MenuOption {
			text: "Create"
			onSelected: {
				createGroup.hide()
				deviceModelController.createGroup(clients.selectedClient, groupName.text, addDevice);
			}
		}
	}
}

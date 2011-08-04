import Qt 4.7
import "mainscripts.js" as MainScripts

Content {
	id: contentDevice

	Flickable{

		width: parent.width
		height: parent.height
		contentHeight: contentArea.height
		contentWidth: width

		Column{
			id: contentArea
			width: parent.width
			anchors.horizontalCenter: parent.horizontalCenter

			Rectangle{
				height: MainScripts.HEADERHEIGHT
				width: parent.width
				color: "lightgray"
				Text{
					anchors.centerIn: parent
					text: "Devices"
				}
				z: 3
			}

			Repeater {
				model: deviceModel

				DeviceElement{}
			}

			Rectangle{
				height: MainScripts.HEADERHEIGHT
				width: parent.width
				color: "lightgray"
				Text{
					anchors.centerIn: parent
					text: "Groups"
				}
				z: 3
			}

			Repeater {
				model: 10
				/*model: ListModel{
				id: groupModel
				//TODO set something to get groupModel when avail
			}
			*/
				GroupElement{ }
				//visible: om mer än en grupp finns
			}
		}
	}
}

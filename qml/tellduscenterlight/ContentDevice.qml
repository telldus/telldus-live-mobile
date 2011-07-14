import QtQuick 1.1
import com.nokia.meego 1.0
import "mainscripts.js" as MainScripts

Content {
	id: contentDevice

	Flickable{
		id: flickableContent
		width: parent.width
		height: parent.height
		contentHeight: contentArea.height
		contentWidth: width

		Column{
			id: contentArea
			width: parent.width
			anchors.horizontalCenter: parent.horizontalCenter

			Header {
				text: "Devices"
			}

			Repeater {
				model: DeviceListModel{
					id: deviceModel
				}

				DeviceElement{}
			}

			Header {
				text: "Groups"
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
	ScrollDecorator{ flickableItem: flickableContent }
}

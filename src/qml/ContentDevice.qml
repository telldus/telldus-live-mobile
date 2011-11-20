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
			spacing: 11

			Header {
				text: "Devices"
			}

			Repeater {
				model: deviceModel

				DeviceElement{}
			}

			Header {
				text: "Groups"
			}

			Repeater {
				model: groupModel
				DeviceElement{ }
			}
		}
	}
	ScrollDecorator{ flickableItem: flickableContent }
}

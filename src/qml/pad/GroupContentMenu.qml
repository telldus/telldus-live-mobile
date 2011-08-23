import Qt 4.7
import ".."
import "../mainscripts.js" as MainScripts


Menu{

	id: groupContentMenu
	content: menuComp

	Component{
		id: menuComp

		Column{
			id: menuColumn
			width: MainScripts.LISTWIDTH

			MenuOption{
				id: groupContentMenuHeader
				text: "Devices"
				isHeader: true
				z: 5
			}

			Repeater {
				id: groupdevicelist

				model: device.devices()
				delegate: DeviceElementPad {}
			}
		}
	}
}

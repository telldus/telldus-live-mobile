import Qt 4.7
import ".."

Menu{

	id: deviceMenu
	property variant model: undefined
	property variant footerComponent: undefined
	signal optionSelected(string value)
	property string headerText: ''
	content: menuComp

	Component{
		id: menuComp

		Column{
			id: menuColumn

			MenuOption{
				text: headerText
				isHeader: true
				visible: headerText != ''
			}

			Repeater{
				model: deviceMenu.model
				MenuOption{
					text: model.text != undefined ? model.text : model.device.name
					optionValue: model.device != undefined ? model.device.id : (model.optionValue == undefined ? 'false' : model.optionValue)
					isHeader: model.isHeader == undefined ? false : model.isHeader
				}
			}

			Loader{
				id: footer
				sourceComponent: footerComponent
			}
		}
	}
}

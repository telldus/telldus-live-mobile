import Qt 4.7
import ".."

Menu{

	id: deviceMenu
	//property string align: (deviceMenu.x + deviceMenu.width) >= main.width ? 'left' : 'right'
	property variant model: undefined
	property variant footerComponent: undefined
	signal optionSelected(string value)
	//property bool menuShowArrow: false
	property string headerText: ''
	//property int deviceElementLeftX: 0
	//property int deviceElementRightX: 0
	//width: menuComp.width
	//height: menuComp.height
	//x: deviceElementRightX + deviceMenu.width >= main.width ? deviceElementLeftX - deviceMenu.width : deviceElementRightX

//	Menu{
//		assignTo: visualDevice

		content: menuComp //menuComp
//	}

	Component{
		id: menuComp

		Column{
			id: menuColumn

			MenuOption{
				text: headerText
				//showArrow: menuShowArrow
				//align: deviceMenu.align
				isHeader: true
				visible: headerText != ''
			}

			Repeater{
				model: deviceMenu.model
				MenuOption{
					text: model.text != undefined ? model.text : model.device.name
					//showArrow: model.showArrow == undefined ? false : model.showArrow
					optionValue: model.device != undefined ? model.device.id : (model.optionValue == undefined ? 'false' : model.optionValue)
					//align: deviceMenu.align
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

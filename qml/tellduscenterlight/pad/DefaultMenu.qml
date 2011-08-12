import Qt 4.7

Rectangle{

	id: deviceMenu
	property string align: (deviceMenu.x + deviceMenu.width) >= main.width ? 'left' : 'right'
	property variant model: undefined
	signal optionSelected(string value)
	property bool menuShowArrow: false
	property string headerText: ''
	property int deviceElementLeftX: 0
	property int deviceElementRightX: 0
	width: menuColumn.width
	height: menuColumn.height
	x: deviceElementRightX + deviceMenu.width >= main.width ? deviceElementLeftX - deviceMenu.width : deviceElementRightX

	Rectangle{
		height: menuColumn.height
		width: menuColumn.width
		color: "lightgray"

		Column{
			id: menuColumn

			MenuOption{
				text: headerText
				showArrow: menuShowArrow
				align: deviceMenu.align
				isHeader: true
				visible: headerText != ''
			}

			Repeater{
				model: deviceMenu.model
				MenuOption{
					text: model.text != undefined ? model.text : model.device.name
					showArrow: model.showArrow == undefined ? false : model.showArrow
					optionValue: model.device != undefined ? model.device.id : (model.optionValue == undefined ? 'false' : model.optionValue)
					align: deviceMenu.align
					isHeader: model.isHeader == undefined ? false : model.isHeader
				}
			}
		}
	}
}

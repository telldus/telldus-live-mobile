import Qt 4.7

Rectangle{

	id: deviceMenu
	property string align: ''
	property variant model: undefined
	signal optionSelected(string value)
	property bool menuShowArrow: false
	width: menuColumn.width
	height: menuColumn.height

	Rectangle{
		height: menuColumn.height
		width: menuColumn.width
		color: "lightgray"

		Column{
			id: menuColumn
			Repeater{
				model: deviceMenu.model
				MenuOption{
					text: model.text
					showArrow: model.showArrow == undefined ? false : model.showArrow
					optionValue: model.optionValue == undefined ? 'false' : model.optionValue
					align: deviceMenu.align
					isHeader: model.isHeader == undefined ? false : model.isHeader
				}
			}
		}
	}
}

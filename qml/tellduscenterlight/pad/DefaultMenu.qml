import Qt 4.7

Rectangle{

	id: deviceMenu
	property string align: ''
	property variant model: undefined
	signal optionSelected(string value)
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
					text: menuText
					showArrow: menuShowArrow == undefined ? false : menuShowArrow
					optionValue: menuOptionValue
					align: deviceMenu.align
				}
			}
		}
	}
	visible: selectedDevice > 0
}

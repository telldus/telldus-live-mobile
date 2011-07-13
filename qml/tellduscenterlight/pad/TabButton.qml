import Qt 4.7

Rectangle{
	id: tabButton
	property string name: ''
	property int selectionTabId
	signal clicked()
	height: 40 //TODO
	width: parent.width
	color: buttonMouseArea.pressed ? 'blue' : 'gray'

	Text{
		anchors.centerIn: parent
		text: name
	}
	MouseArea{
		id: buttonMouseArea
		anchors.fill: parent
		onClicked: {
			tabButton.clicked();
		}
	}
}

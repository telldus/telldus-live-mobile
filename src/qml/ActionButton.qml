import Qt 4.7

Item {
	id: buttonRect
	height: img.height
	width: img.width

	property string text: ''
	signal clicked()

	Image {
		id: img
		width: sourceSize.width * SCALEFACTOR
		height: sourceSize.height * SCALEFACTOR
		source: text.toLowerCase() + '.png'
	}
	MouseArea {
		id: buttonMouseArea
		anchors.fill: parent
		onClicked: buttonRect.clicked()
	}
}

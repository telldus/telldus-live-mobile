import Qt 4.7

Item {
	property color color: "black"
	id: separator

	height: 10
	width: parent.width

	Rectangle {
		anchors.verticalCenter: parent.verticalCenter
		anchors.left: parent.left
		anchors.right: parent.right
		height: 1
		color: separator.color
	}
}

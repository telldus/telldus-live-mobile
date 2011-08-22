import Qt 4.7
import ".."

Menu {
	signal cancel()
	signal ok()
	property string message: ''
	property bool isConfirmation: true
	modal: true

	content: dialogComp

	Component{
		id: dialogComp
		Item {
			id: dialog
			width: childrenRect.width
			height: childrenRect.height

			Column{

				Text{
					text: message
					anchors.horizontalCenter: parent.horizontalCenter
				}

				Row{
					anchors.horizontalCenter: parent.horizontalCenter
					Rectangle{
						height: 40 //TODO
						width: dialog.width/2
						color: buttonMouseAreaCancel.pressed ? 'blue' : 'gray'
						visible: isConfirmation
						Text{
							text: "Cancel"
							anchors.centerIn: parent
						}
						MouseArea{
							id: buttonMouseAreaCancel
							anchors.fill: parent
							onClicked:{
								cancel();
							}
						}
					}
					Rectangle{
						height: 40 //TODO
						width: dialog.width/2
						color: buttonMouseArea.pressed ? 'blue' : 'gray'
						Text{
							text: "OK"
							anchors.centerIn: parent
						}
						MouseArea{
							id: buttonMouseArea
							anchors.fill: parent
							onClicked:{
								ok();
							}
						}
					}
				}
			}
		}
	}
}

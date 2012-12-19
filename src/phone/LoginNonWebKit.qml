import QtQuick 1.0

Column {
	spacing: 20
	Text {
		id: loginNonWebKit
		text: "Non webkit version"
	}
	Rectangle {
		color: "green"
		width: 300
		height: 150
		Text {
			anchors.centerIn: parent
			text: "Log in"
		}
		MouseArea {
			anchors.fill: parent
			onClicked: {
				console.log("Log in!!!")
			}
		}
	}
}

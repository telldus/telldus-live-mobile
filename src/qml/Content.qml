import QtQuick 1.0

Rectangle{
	id: content
	clip:  true
	property int pane: 0
	property int selected: -1

	height: parent.height
	width: parent.width

	states: [
		State {
			name: "hiddenLeft"; when: selected > pane
			PropertyChanges { target: content; scale: 1; z: 1 }
			AnchorChanges { target: content; anchors.left: undefined; anchors.right: parent.left }
		},
		State {
			name: "hiddenRight"; when: selected < pane
			PropertyChanges { target: content; scale: 1; z: 1 }
			AnchorChanges { target: content; anchors.left: parent.right; anchors.right: undefined }
		},
		State {
			name: "visible"; when: selected == pane
			PropertyChanges { target: content; z: 2; }
			AnchorChanges { target: content; anchors.right: parent.right; anchors.left: undefined }
		}
	]

	transitions: [
		Transition {
			from: "hiddenLeft"
			to: "visible"
			AnchorAnimation { easing.type: Easing.InOutQuad; duration: 500 }
		},
		Transition {
			from: "visible"
			NumberAnimation { easing.type: Easing.InOutQuad; duration: 500; properties: "scale"; from: 1; to: 0.8 }
		},
		Transition {
			from: "hiddenRight"
			to: "visible"
			AnchorAnimation { easing.type: Easing.InOutQuad; duration: 500 }
		}
	]
}

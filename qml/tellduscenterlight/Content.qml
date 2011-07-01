import Qt 4.7

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
			AnchorChanges { target: content; anchors.left: undefined; anchors.right: parent.left }
		},
		State {
			name: "hiddenRight"; when: selected < pane
			AnchorChanges { target: content; anchors.left: parent.right; anchors.right: undefined }
		},
		State {
			name: "visible"; when: selected == pane
			PropertyChanges { target: content; visible: true }
			AnchorChanges { target: content; anchors.right: parent.right; anchors.left: undefined }
		}
	]

	transitions: [
		Transition {
			from: "hiddenLeft"
			to: "visible"
			reversible: true
			AnchorAnimation { easing.type: Easing.InOutQuad; duration: 500 }
		},
		Transition {
			from: "hiddenRight"
			to: "visible"
			reversible: true
			AnchorAnimation { easing.type: Easing.InOutQuad; duration: 500 }
		}
	]
}

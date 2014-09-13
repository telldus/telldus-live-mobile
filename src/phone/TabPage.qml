import QtQuick 2.0
import Telldus 1.0

Item {
	id: tabPage
	property int pageId: 0
	property int currentPage: -1
	property string component: ''
	width: parent.width
	height: parent.height
	anchors.left: parent.left
	anchors.right: parent.right

	Loader {
		id: loader
		anchors.fill: parent
		source: ''
	}

	states: [
		State {
			name: 'left'
			when: currentPage > pageId
			AnchorChanges { target: tabPage; anchors.left: undefined; anchors.right: parent.left }
			PropertyChanges { target: loader; source: '' }
		},
		State {
			name: 'active'
			when: currentPage == pageId
			PropertyChanges { target: loader; source: tabPage.component }
		},
		State {
			name: 'right'
			when: currentPage < pageId
			AnchorChanges { target: tabPage; anchors.left: parent.right; anchors.right: undefined }
			PropertyChanges { target: loader; source: '' }
		}
	]

	transitions: [
		Transition {
			to: 'active'
			reversible: true
			SequentialAnimation {
				PropertyAction { target: loader; property: "source" }
				AnchorAnimation { duration: 250; easing.type: Easing.InOutQuad }
			}
		}
	]
}

import QtQuick 1.0
import Telldus 1.0

Loader {
	id: tabPage
	property int pageId: 0
	property int currentPage: 0
	property string component: ''
	width: parent.width
	height: parent.height
	anchors.left: parent.left
	anchors.right: parent.right
	source: ''

	states: [
		State {
			name: 'left'
			when: currentPage > pageId
			AnchorChanges { target: tabPage; anchors.left: undefined; anchors.right: parent.left }
			PropertyChanges { target: tabPage; source: '' }
		},
		State {
			name: 'active'
			when: currentPage == pageId
			PropertyChanges { target: tabPage; source: tabPage.component }
		},
		State {
			name: 'right'
			when: currentPage < pageId
			AnchorChanges { target: tabPage; anchors.left: parent.right; anchors.right: undefined }
			PropertyChanges { target: tabPage; source: '' }
		}
	]

	transitions: [
		Transition {
			to: 'active'
			reversible: true
			SequentialAnimation {
				PropertyAction { target: tabPage; property: "source" }
				AnchorAnimation { duration: 250; easing.type: Easing.InOutQuad }
			}
		}
	]
}

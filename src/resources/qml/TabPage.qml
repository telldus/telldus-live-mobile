import QtQuick 2.0
import Telldus 1.0

Rectangle {
	id: tabPage
	property int pageId: 0
	property int currentPage: 0
	property string component: ''
	property string bgcolor: '#ffffff'
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
			PropertyChanges { target: loader; source: ''; }
			PropertyChanges { target: tabPage; visible: false; }
		},
		State {
			name: 'active'
			when: currentPage == pageId
			PropertyChanges { target: loader; source: tabPage.component; }
			PropertyChanges { target: tabPage; visible: true; }
		},
		State {
			name: 'right'
			when: currentPage < pageId
			PropertyChanges { target: loader; source: ''; }
			PropertyChanges { target: tabPage; visible: false; }
		}
	]

}

import QtQuick 2.0
import Telldus 1.0

Rectangle {
	id: tabPage
	property int pageId: 0
	property int currentPage: 0
	property string component: ''
	property string bgcolor: '#ffffff'
	anchors.left: parent.left
	anchors.top: mainViewOffset.bottom
	anchors.right: parent.right
	anchors.bottom: parent.bottom

	// This loader shouldn't be asynchronous as it is rather distracting when switching views, most other loaders should be!
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

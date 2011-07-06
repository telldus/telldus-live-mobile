import Qt 4.7
import "mainscripts.js" as MainScripts

Rectangle {
	id: toolbarButton

	property string orientation: 'portrait'
	property int pane: 0

	width: orientation == 'landscape' ? parent.width : childwidth;
	height: orientation == 'portrait' ? parent.height : childheight

	color: "lightgray"
	border.color: "white"
	border.width: 0

	MouseArea{
		anchors.fill: parent
		onClicked: {
			if(telldusLive.isAuthorized){
				selectedPane = pane
			}
		}
	}

	Text{
		id: toolbartext
		anchors.centerIn: parent
		text: MainScripts.getFriendlyText(pane)
	}

	Image{
		id: toolbarimage
		anchors.centerIn: parent
		source: MainScripts.getIconSource(pane)
	}

	states: [
		State {
			name: "disabled"; when: !telldusLive.isAuthorized && pane != 4  //TODO avoid this setting-thing here
			PropertyChanges { target: toolbarButton; opacity: 0.2; border.width: 0; border.color: "white" }
		},
		State {
			name: "selected"; when: pane == selectedPane
			PropertyChanges { target: toolbarButton; opacity: 1; border.width: 2; border.color: "red" }
		}
	]
}

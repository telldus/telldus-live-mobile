import QtQuick 1.0

Rectangle {
	color: "#dceaf6"
	//width: 640
	//height: 1136
	width: 768
	height: 1280

	Component {
		id: component_mainInterface
		MainInterface {
			id: mainInterface
		}
	}
	Loader {
		id: loader_mainInterface
		sourceComponent: component_mainInterface
		anchors.fill: parent
	}
}


import QtQuick 1.1
import com.nokia.meego 1.0

Page {
	id: content
	clip:  true

	height: parent.height
	width: parent.width

	tools: ToolBarLayout {
		ToolIcon { iconId: "toolbar-back"; onClicked: { pageStack.pop(); } }
	}
}

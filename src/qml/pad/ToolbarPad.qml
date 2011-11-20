import QtQuick 1.0
import ".."
import "../mainscripts.js" as MainScripts

Rectangle {
	id: toolbar
	width: MainScripts.TOOLBARWIDTH
	height: parent.height
	property string orientation: 'landscape'  //TODO change with orientation?
	property bool schedulerVisible: false  //TODO future feature: scheduler
	property int childwidth: MainScripts.TOOLBARWIDTH
	property int childheight: parent.height/( 4 + (schedulerVisible? 1 : 0) ) //TODO make dynamic

	Column {
		anchors.fill: parent
		width: parent.width
		spacing: 2

		ToolbarButton{
			pane: MainScripts.FULL_FAVORITE_LAYOUT
			orientation: toolbar.orientation
			//visible: toolbar.parent.favoriteVisible
		}
		ToolbarButton{
			pane: MainScripts.FULL_DEVICE
			orientation: toolbar.orientation
			//visible: toolbar.parent.deviceVisible
		}
		ToolbarButton{
			pane: MainScripts.FULL_SENSOR
			orientation: toolbar.orientation
			//visible: toolbar.parent.sensorVisible
		}
		ToolbarButton{
			pane: MainScripts.SCHEDULER
			orientation: toolbar.orientation
			visible: schedulerVisible //TODO future feature: scheduler
		}
		ToolbarButton{
			pane: MainScripts.FULL_SETTING
			orientation: toolbar.orientation
		}
	}
}

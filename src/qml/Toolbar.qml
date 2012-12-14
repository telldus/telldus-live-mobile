import QtQuick 1.0
import "mainscripts.js" as MainScripts

Rectangle {
	id: toolbar
	property int effectiveParentHeight: parent.height - MainScripts.HEADERHEIGHT - MainScripts.SUBHEADERHEIGHT
	property int childwidth: parent.width/(1 + (parent.favoriteVisible ? 1 : 0) + (parent.deviceVisible ? 1 : 0) + (parent.sensorVisible ? 1 : 0)); //portrait
	property int childheight: effectiveParentHeight/(1 + (parent.favoriteVisible ? 1 : 0) + (parent.deviceVisible ? 1 : 0) + (parent.sensorVisible ? 1 : 0)); //landscape
	property string orientation: 'portrait'

	width: orientation == 'portrait' ? parent.width : MainScripts.TOOLBARWIDTH
	height: orientation == 'landscape' ? effectiveParentHeight : MainScripts.TOOLBARHEIGHT

	//grid didn't work on N900
	Column {
		anchors.fill: parent
		width: parent.width
		spacing: 2
		visible: toolbar.orientation == 'portrait' ? false : true

		ToolbarButton{
			pane: MainScripts.FAVORITE
			orientation: toolbar.orientation
			visible: toolbar.parent.favoriteVisible
		}
		ToolbarButton{
			pane: MainScripts.DEVICE
			orientation: toolbar.orientation
			visible: toolbar.parent.deviceVisible
		}
		ToolbarButton{
			pane: MainScripts.SENSOR
			orientation: toolbar.orientation
			visible: toolbar.parent.sensorVisible
		}
		ToolbarButton{
			pane: MainScripts.SETTING
			orientation: toolbar.orientation
		}
	}

	Row {
		anchors.fill: parent
		width: parent.width
		spacing: 2
		visible: toolbar.orientation == 'portrait' ? true : false

		ToolbarButton{
			pane: MainScripts.FAVORITE
			orientation: toolbar.orientation
			visible: toolbar.parent.favoriteVisible
		}
		ToolbarButton{
			pane: MainScripts.DEVICE
			orientation: toolbar.orientation
			visible: toolbar.parent.deviceVisible
		}
		ToolbarButton{
			pane: MainScripts.SENSOR
			orientation: toolbar.orientation
			visible: toolbar.parent.sensorVisible
		}
		ToolbarButton{
			pane: MainScripts.SETTING
			orientation: toolbar.orientation
		}
	}
}

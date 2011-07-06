import Qt 4.7
import ".."
import "../DeviceList.js" as DeviceList
import "../Sensors.js" as Sensors
import "../mainscripts.js" as MainScripts

Rectangle {
	id: main

	property int selectedPane: defaultSelectedMode()

	Component.onCompleted: {  //TODO what of this can be reused?
		DeviceList.list.setTelldusLive( telldusLive )
		Sensors.list.setTelldusLive( telldusLive )
		selectedPane = defaultSelectedMode()
	}


	DeviceListModel {
		id: deviceModel
	}
	SensorListModel {
		id: sensorModel
	}

	anchors.fill: parent

	/* This doesn't work !?!? why?
	ContentFavorite{
		id: rootPartFavorite
		//anchors.fill: parent //fungerar
		anchors.horizontalCenter: parent.horizontalCenter
		height: parent.height
		width: parent.width

		color: "red"

		/*
		anchors.left: parent.left
		//anchors.horizontalCenter: parent.horizontalCenter
		//anchors.verticalCenter: parent.verticalCenter
		anchors.top: parent.top
		width: parent.width //300
		height: parent.height //500
		color:"red"
		//pane: 0
		//selected: 1

	}
	*/

	ToolbarPad{
		id: toolbar
		anchors.left: parent.left
	}

	Item{
		height: parent.height
		anchors.left: toolbar.right

		ListView {
			id: devicelist
			height: parent.height
			width: 300

			model: DeviceListModel {}

			delegate: DeviceElement { }
		}

		ListView {
			id: grouplist
			height: parent.height
			width: 300
			anchors.left: devicelist.right

			model: DeviceListModel {}

			delegate: DeviceElement { //TODO groups only
			}
		}
		visible: selectedPane == MainScripts.FULL_DEVICE
	}

	ListView {
		id: sensorlist
		height: parent.height
		anchors.left: toolbar.right
		width: 300 //TODO
		model: SensorListModel{ }
		delegate: SensorElement{ }
		z: 1
		visible: selectedPane == MainScripts.FULL_SENSOR
	}

	ListView {
		id: favoritelist
		anchors.right: parent.right
		height: parent.height
		width: 300

		model: DeviceListModel {}

		delegate: DeviceElement {
			hideFavorites: true
		}
		visible: selectedPane != MainScripts.FULL_FAVORITE_LAYOUT
	}

	function defaultSelectedMode(){
		return MainScripts.FULL_DEVICE;
		/*
		if(telldusLive.isAuthorized){

			var favoriteCount = DeviceList.list.favoriteCount();
			var deviceCount = DeviceList.list.count();
			var sensorCount = 0; //TODO

			if(favoriteCount > 0){
				return MainScripts.FAVORITE
			}
			if(deviceCount == 0 && sensorCount > 0){
				//only sensors, go to this tab
				return MainScripts.SENSOR
			}

			if(deviceCount == 0){
				return MainScripts.SETTING //nothing at all yet
			}
			return MainScripts.DEVICE  //default, all other cases
		}
		else{
			return MainScripts.SETTING
		}*/
	}
}

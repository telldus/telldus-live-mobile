import Qt 4.7
import QtWebKit 1.0
import ".."
//import "../DeviceList.js" as DeviceList
import "../Device.js" as Device
import "../Sensors.js" as Sensors
import "../mainscripts.js" as MainScripts

Rectangle {
	id: main

	property int selectedPane: defaultSelectedMode()
	property int selectedDevice: 0

	Component.onCompleted: {  //TODO what of this can be reused?
		//DeviceList.list.setTelldusLive( telldusLive )
		Device.setupCache(deviceModel)
		Sensors.list.setTelldusLive( telldusLive )
		selectedPane = defaultSelectedMode()
	}

	/*DeviceListModel {
		id: deviceModel
	}
	*/

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
			width: 300 //TODO

			model: deviceModel //DeviceListModel {}

			delegate: DeviceElement { }
		}

		ListView {
			id: grouplist
			height: parent.height
			width: 300 //TODO
			anchors.left: devicelist.right

			model: deviceModel //DeviceListModel {}

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
		width: 300 //TODO

		model: deviceModel //DeviceListModel {}

		delegate: DeviceElement {
			hideFavorites: true
		}
		visible: selectedPane != MainScripts.FULL_FAVORITE_LAYOUT
	}

	FavoriteLayout{
		id: favoriteLayout
		visible: selectedPane == MainScripts.FULL_FAVORITE_LAYOUT
		anchors.left: toolbar.right
		anchors.top: parent.top
		width: parent.width - MainScripts.TOOLBARWIDTH
		height: parent.height
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

	MouseArea{
		anchors.fill: parent
		onClicked: {
			selectedDevice = 0
			addToGroupMenu.visible = false
		}
		visible: deviceMenu.visible
	}

	DefaultMenu{
		id: deviceMenu

		model: ListModel{
			ListElement{
				text: "Header"
				showArrow: true
				isHeader: true
			}
			ListElement{
				text: "Add to favorites"
				optionValue: 'addfavorite'
			}
			ListElement{
				text: "Add to group"
				optionValue: 'addtogroup'
			}
			ListElement{
				text: "Edit device"
				optionValue: 'editdevice'
			}
		}

		onOptionSelected: {
			addToGroupMenu.visible = false
			if(value == "addtogroup"){
				addToGroupMenu.visible = true
			}
			if(value == "editdevice"){
				editDevice.visible = true
				editDevice.update()
			}
		}
		visible: selectedDevice > 0
	}

	DefaultMenu{
		id: addToGroupMenu
		anchors.top: deviceMenu.bottom
		anchors.topMargin: 10 //TODO
		anchors.horizontalCenter: deviceMenu.horizontalCenter
		model: ListModel{
			//TODO model dynamic, depending on groups...
			ListElement{
				text: "Include in group"
				isHeader: true
			}
			ListElement{
				text: "Group 1"
			}
			ListElement{
				text: "Group 2"
			}
			ListElement{
				text: "Group 3"
			}
		}
		visible: false
	}

	Rectangle{
		id: editDevice
		color: "white"
		anchors.fill: parent

		WebView{
			id: webview
			anchors.fill: parent
			scale: 1
			smooth: true
		}

		Rectangle{
			color: "red"
			anchors.right: parent.right
			anchors.top:  parent.top
			height: 50
			width: 50
			Text{
				anchors.centerIn: parent
				text: "X"
				font.pointSize: 20
			}
			MouseArea{
				anchors.fill: parent
				onClicked: {
					editDevice.visible = false
				}
			}
		}

		visible: false

		function update(){
			webview.url = "http://example.com/deviceid=" + selectedDevice
		}
	}
}

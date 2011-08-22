import Qt 4.7
import QtWebKit 1.0
import ".."
import "../Device.js" as Device
import "../mainscripts.js" as MainScripts

Rectangle {
	id: main

	property int selectedPane: defaultSelectedMode()
	property variant selectedDevice: undefined

	Component.onCompleted: {
		Device.setupCache(deviceModelController)
		selectedPane = defaultSelectedMode()
	}

	anchors.fill: parent

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
			width: MainScripts.LISTWIDTH

			model: deviceModel

			delegate: DeviceElementPad { }
		}

		ListView {
			id: grouplist
			height: parent.height
			width: MainScripts.LISTWIDTH
			anchors.left: devicelist.right

			model: groupModel

			delegate: DeviceElementPad {}
		}
		visible: selectedPane == MainScripts.FULL_DEVICE
	}

	ListView {
		id: sensorlist
		height: parent.height
		anchors.left: toolbar.right
		width: MainScripts.LISTWIDTH
		model: sensorModel
		delegate: SensorElement{ }
		z: 1
		visible: selectedPane == MainScripts.FULL_SENSOR
	}

	Rectangle{
		color: 'grey'
		anchors.right: floatingFavorites.left
		height: parent.height
		width: 20 //TODO
		visible: parent.width < 1000 && selectedPane != MainScripts.FULL_FAVORITE_LAYOUT //TODO

		MouseArea{
			anchors.fill: parent
			onClicked: {
				floatingFavorites.floatingFavoritesToggled = !floatingFavorites.floatingFavoritesToggled
			}
		}
	}

	Rectangle{
		id: floatingFavorites
		property bool floatingFavoritesToggled: false
		color: 'white'
		anchors.right: parent.right
		height: parent.height
		width: (parent.width > 1000 || floatingFavoritesToggled) ? 300 : 0 //TODO
		visible: selectedPane != MainScripts.FULL_FAVORITE_LAYOUT && (parent.width > 1000 || floatingFavoritesToggled) //TODO

		Behavior on width { PropertyAnimation{} }

		ListView {
			id: favoritelist

			anchors.fill: parent
			model: favoriteModel

			delegate: DeviceElementPad {
				hideFavoriteToggle: true
			}
		}
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
			webview.url = "http://example.com/deviceid=" + selectedDevice.id
		}
	}
}

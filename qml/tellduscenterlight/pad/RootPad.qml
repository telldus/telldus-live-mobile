import Qt 4.7
import QtWebKit 1.0
import ".."
import "../Device.js" as Device
import "../mainscripts.js" as MainScripts

Rectangle {
	id: main

	property int selectedPane: defaultSelectedMode()
	property variant selectedDevice: undefined

	Component.onCompleted: {  //TODO what of this can be reused?
		Device.setupCache(rawDeviceModel)
		//Sensors.list.setTelldusLive( telldusLive )
		selectedPane = defaultSelectedMode()
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

			model: deviceModel

			delegate: DeviceElement { }
		}

		ListView {
			id: grouplist
			height: parent.height
			width: 300 //TODO
			property bool wasHeld: false
			anchors.left: devicelist.right

			model: groupModel

			delegate: DeviceElement {}
		}
		visible: selectedPane == MainScripts.FULL_DEVICE
	}

	ListView {
		id: sensorlist
		height: parent.height
		anchors.left: toolbar.right
		width: 300 //TODO
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

			delegate: DeviceElement {
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

	MouseArea{
		anchors.fill: parent
		onClicked: {
			selectedDevice = undefined
			addToGroupMenu.visible = false
		}
		visible: selectedDevice != undefined //deviceMenu.visible
	}

	Rectangle{
		id: groupContentMenu

		height: 200 //TODO
		width: 300 //TODO
		color: "lightgray"
		property string align: ''
		clip: true
		property variant selectedGroup

		MenuOption{
			id: groupContentMenuHeader
			text: "Devices"
			showArrow: true
			align: groupContentMenu.align
			isHeader: true
			z: 5
		}
		ListView {
			id: groupdevicelist
			height: parent.height - groupContentMenuHeader.height
			width: 300 //TODO
			anchors.top: groupContentMenuHeader.bottom

			model: groupContentMenu.selectedGroup != undefined ? groupContentMenu.selectedGroup.deviceModel : undefined

			delegate: DeviceElement {
				hideFavoriteToggle: true
			}
		}
		//TODO change alignment for this menu
		visible: selectedDevice != undefined && selectedDevice.type == MainScripts.GROUPTYPE && !grouplist.wasHeld;
	}

	Rectangle{
		id: groupAddRemoveMenu
		height: menuColumn.height
		width: menuColumn.width
		color: "lightgray"
		property string align: ''
		property variant selectedGroup

		Column{
			id: menuColumn

			MenuOption{
				text: "Add/Remove"
				showArrow: true
				align: groupAddRemoveMenu.align
				isHeader: true
			}

			Repeater{
				model: deviceModel
				Rectangle{
					property int optionWidth: optiontext.width + MainScripts.MARGIN_TEXT + 50 //TODO
					height: MainScripts.MENUOPTIONHEIGHT
					width: parent == undefined ? optionWidth : (optionWidth > parent.width ? optionWidth : parent.width)
					color: "lightgray"
					Rectangle{
						id: checkbox
						anchors.left: parent.left
						anchors.leftMargin: 10 //TODO
						width: 20 //TODO
						height: 20 //TODO
						Text{
							anchors.centerIn: parent
							text: "X"
							visible: groupAddRemoveMenu.selectedGroup != undefined && groupAddRemoveMenu.selectedGroup.hasDevice(modelData.id)
						}
						MouseArea{
							anchors.fill: parent
							onClicked: {
								if(groupAddRemoveMenu.selectedGroup.hasDevice(modelData.id)){
									groupAddRemoveMenu.selectedGroup.removeDevice(modelData.id);
								}
								else{
									groupAddRemoveMenu.selectedGroup.addDevice(modelData.id);
								}
							}
						}
					}

					Text{
						id: optiontext
						anchors.left: checkbox.right
						anchors.leftMargin: 10 //TODO
						anchors.verticalCenter: checkbox.verticalCenter
						color: "black"
						text: modelData.name
					}
				}
			}
		}
		visible: selectedDevice != undefined && selectedDevice.type == MainScripts.GROUPTYPE && grouplist.wasHeld
	}

	DefaultMenu{
		id: deviceMenu
		headerText: "Header"

		model: ListModel{
			ListElement{
				text: "Toggle favorite"
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
			else if(value == "editdevice"){
				editDevice.visible = true
				editDevice.update()
			}
			else if(value == "addfavorite"){
				if(selectedDevice.isFavorite){
					selectedDevice.isFavorite = false;
				}
				else{
					selectedDevice.isFavorite = true;
				}
				selectedDevice = undefined;
			}
		}
		visible: selectedDevice != undefined && selectedDevice.type == MainScripts.DEVICETYPE
	}

	DefaultMenu{
		id: addToGroupMenu
		anchors.top: deviceMenu.bottom
		anchors.topMargin: 10 //TODO
		anchors.horizontalCenter: deviceMenu.horizontalCenter

		model: groupModel

		onOptionSelected: {
			addToGroupMenu.visible = false
			console.log("TODO Add device " + selectedDevice.id + " to group " + value)

			selectedDevice = undefined
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
			webview.url = "http://example.com/deviceid=" + selectedDevice.id
		}
	}
}

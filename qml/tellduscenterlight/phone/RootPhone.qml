import Qt 4.7
import "../DeviceList.js" as DeviceList
import "../mainscripts.js" as MainScripts
import "../Device.js" as Device
import ".."

Rectangle {
	color: "black"
	id: main

	property int selectedPane: defaultSelectedMode()
	property bool favoriteVisible: favoriteModel.count > 0
	property bool deviceVisible: deviceModel.count > 0
	property bool sensorVisible: sensorModel.count > 0
	property string orientation: main.height/main.width < 1 ? 'landscape' : 'portrait'

	Component.onCompleted: {
		Device.setupCache(deviceModel)
		selectedPane = defaultSelectedMode()
		message.showMessage("LOADED"); //TODO do something with this
	}

	Connections{
		target: telldusLive
		onAuthorizedChanged: {
			console.log("AUTH CHANGED!");
			selectedPane = defaultSelectedMode()  //TODO this is too early, no list yet or something (after login)
		}
	}

	Rectangle{
		id: message
		color: 'black'
		width: parent.width
		height: textblock.height
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.top: header.bottom
		property alias text: textblock.text  //TODO probably more depend on property...

		Text{
			id: textblock
			anchors.centerIn: parent
			color: 'white'
			text: ""
		}
		Timer {
			id: timer
			interval: 5000
			repeat: false
			onTriggered: message.visible = false
		 }

		function showMessage(text){
			message.text = text;
			message.visible = true;
			timer.start();
		}

		z: 100
	}

	Rectangle{
		id: header
		anchors.top: parent.top
		anchors.horizontalCenter: parent.horizontalCenter
		height: MainScripts.MAINHEADERHEIGHT
		width: parent.width
		color: "black"

		Text{
			color: "white"
			anchors.centerIn: parent
			text: "TelldusCenter Light"
		}
		z: 3
	}

	Rectangle{
		id: subheader
		anchors.top: header.bottom
		anchors.horizontalCenter: parent.horizontalCenter
		height: MainScripts.SUBHEADERHEIGHT
		width: parent.width
		color: "lightblue"
		Text{
			anchors.centerIn: parent
			text: MainScripts.getFriendlyText(selectedPane)
		}
		z: 2

		//TEST:
		MouseArea{
			anchors.fill: parent
			onClicked: {
				var test = 'inget';
				if(main.height/main.width < 1){
					test = 'landscape';
				}
				else{
					test = 'portrait';
				}
				message.showMessage("should be " + test);
				if(main.orientation == 'landscape'){
					console.log("to portrait");
					main.orientation = 'portrait';
				}
				else{
					console.log("to landscape");
					main.orientation = 'landscape';
				}
			}
		}
	}

	Item{
		id: contentArea
		anchors.top: subheader.bottom
		anchors.left: parent.left
		z: 1

		ContentFavorite{
			id: contentFavorite
			pane: MainScripts.FAVORITE
			selected: selectedPane
		}
		ContentDevice{
			id: contentDevice
			pane: MainScripts.DEVICE
			selected: selectedPane
		}

		ContentSensor{
			id: contentSensor
			pane: MainScripts.SENSOR
			selected: selectedPane
		}

		ContentSetting{
			id: contentSetting
			pane: MainScripts.SETTING
			selected: selectedPane
		}

		states: [
			State {
				name: "portrait"; when: main.orientation == 'portrait'
				PropertyChanges {
					target: contentArea
					height: parent.height - MainScripts.MAINHEADERHEIGHT - MainScripts.SUBHEADERHEIGHT - MainScripts.TOOLBARHEIGHT
					width: parent.width
				}
				AnchorChanges {
					target: contentArea
					anchors.left: parent.left
				}
			},
			State {
				name: "landscape"; when: main.orientation == 'landscape'
				PropertyChanges {
					target: contentArea
					height: parent.height - MainScripts.MAINHEADERHEIGHT - MainScripts.SUBHEADERHEIGHT
					width: parent.width - MainScripts.TOOLBARWIDTH
				}
				AnchorChanges {
					target: contentArea
					anchors.left: toolbar.right
				}
			}
		]
	}

	Toolbar{
		id: toolbar
		anchors.bottom: parent.bottom
		orientation: main.orientation
		z: 4
	}

	function defaultSelectedMode(){
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
		}
	}
}

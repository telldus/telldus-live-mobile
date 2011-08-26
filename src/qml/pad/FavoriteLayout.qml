import Qt 4.7
import "../mainscripts.js" as MainScripts
import "VisualDeviceList.js" as VisualDeviceList
import ".."

Rectangle {
	property int selectedTabId: VisualDeviceList.tabAreaList.firstTab()
	property int selectedVisualDevice
	property bool editable: false

	id: favoriteLayout

	Connections {
		target: androidComm
		onImagePicked: {
			console.log("TILLBAKA3 med " + imgurl);
			selectedTabId = VisualDeviceList.tabAreaList.firstTab();
			VisualDeviceList.tabAreaList.updateTabAreaBackgroundImage(selectedTabId, imgurl);
			//TODO update current background too, bound or manually here?
		}
	 }

	TabButton{
		id: lock
		anchors.top: parent.top
		anchors.left: parent.left
		width: MainScripts.TOOLBARWIDTH  //TODO
		name: editable ? "Lock" : "Unlock"
		onClicked: {
			editable = !editable
		}
	}

	Rectangle{
		id: tabSelection
		property alias tabButtonRow: tabButtonRow
		color: "darkgray"
		height: tabButtonRow.height
		anchors.left: parent.left
		anchors.top: lock.bottom
		width: MainScripts.TOOLBARWIDTH  //TODO
		z: 99
		Column{
			id: tabButtonRow
			width: parent.width

			TabButton{
				name: "Add new layout"
				onClicked: {
					VisualDeviceList.tabAreaList.insertTabArea('New layout', '');
					if(selectedTabId == 0){
						//no tab selected, select this one
						selectedTabId = VisualDeviceList.tabAreaList.firstTab();
					}
				}
				visible: editable
			}
		}

		Component{
			id: tabSelectionButton
			TabButton{
				z: 99
				ConfirmationDialog{
					id: dialog
					message: "This will delete the tab and everything in it. Continue?"
					onAccepted: {
						VisualDeviceList.tabAreaList.deleteTabArea(selectionTabId);
						selectedTabId = VisualDeviceList.tabAreaList.firstTab();
						dialog.hide();
					}
					onRejected: {
						dialog.hide();
					}
				}

				onClicked: {
					favoriteLayout.selectedTabId = selectionTabId;
				}
				onReleased: {
					dialog.show();
				}
				onNameChanged: {
					VisualDeviceList.tabAreaList.updateTabAreaName(selectionTabId, name);
				}
			}
		}
	}

	Component{
		id: tabArea
		Rectangle{
			property int tabId
			property string name: ''
			property string backgroundimage: ''
			property variant button
			color: "gray" //backgroundimage == '' ? "gray" : ''

			Image{
				anchors.fill: parent
				source: backgroundimage
				visible: backgroundimage != ''
			}

			anchors.left: tabSelection.right
			anchors.top: lock.top
			height: parent.height
			width: parent.width - tabSelection.width
			visible: tabId == selectedTabId
		}
	}

	FavoriteLayoutObjects{
		id: visualDeviceListModel  //TODO has to be named deviceListModel when using DeviceListModel.js...
	}

	ListView{
		id: availableFavoriteList
		anchors.left: parent.left
		anchors.top: tabSelection.bottom
		height: parent.height/3
		model: favoriteModel
		visible: editable && selectedTabId > 0
		z: 160 //above everything
		header: Rectangle {
			width: MainScripts.TOOLBARWIDTH
			height: deviceHeader.height
			Text{
				id: deviceHeader
				font.bold: true
				text: 'Devices'
				anchors.centerIn: parent
			}
		}

		delegate: Rectangle{
			id: availableListDelegate
			height: deviceText.height
			width: MainScripts.TOOLBARWIDTH
			property variant dragActionImage: undefined

			Text{
				id: deviceText
				text: device.name
			}

			MouseArea{
				anchors.fill: parent

				drag.target: undefined
				drag.axis: Drag.XandYAxis
				property bool moved: false

				onPressed: {
					var comp = Qt.createComponent("DragActionImage.qml");
					dragActionImage = comp.createObject(favoriteLayout);
					dragActionImage.source = '../state_1.png'
					drag.target = dragActionImage;
					drag.minimumX = MainScripts.TOOLBARWIDTH
					drag.maximumX = favoriteLayout.width - dragActionImage.width
					drag.minimumY = 0;
					drag.maximumY = favoriteLayout.height - dragActionImage.height;
					dragActionImage.x = mapToItem(favoriteLayout, mouseX, mouseY).x - dragActionImage.width/2;
					dragActionImage.y = mapToItem(favoriteLayout, mouseX, mouseY).y - dragActionImage.height/2;
					moved = false;
				}

				onPositionChanged: {
					moved = true;
				}

				onReleased: {
					var newX = mapToItem(favoriteLayout, mouseX, mouseY).x - MainScripts.TOOLBARWIDTH - dragActionImage.width/2
					var newY = dragActionImage.y;

					var maxWidth = favoriteLayout.width - MainScripts.TOOLBARWIDTH - dragActionImage.width
					var maxHeight = favoriteLayout.height-MainScripts.VISUALDEVICEHEIGHT;
					if(newX > maxWidth){
						newX = maxWidth;
					}
					if(newY > maxHeight){
						newY = maxHeight;
					}
					if(newY < 0){
						newY = 0;
					}
					if(newX < 0){
						newX = 0;
					}

					if(moved){
						//do nothing if not moved
						VisualDeviceList.visualDevicelist.addVisualDevice(newX, newY, device.id, selectedTabId);
					}

					if(dragActionImage != undefined){
						dragActionImage.destroy();
					}
				}

				onClicked:{
					actionPopup.show();
				}
			}

			Menu{
				id: actionPopup
				content: Component {
					Item{
						height: childrenRect.height
						width: childrenRect.width
						Text{
							id: descText
							text: "Drag an action to the layout panel,<br>or drag a whole device from the list"
							wrapMode: Text.WordWrap
						}

						//action for on/off if supported, toggle, dim (slider and presets)...
						Row{
							id: buttonrow
							anchors.top: descText.bottom

							DragAction {
								action: "off"
							}
							DragAction {
								action: "dim"
								dimvalue: 25*255/100
							}
							DragAction {
								action: "dim"
								dimvalue: 50*255/100
							}
							DragAction {
								action: "dim"
								dimvalue: 75*255/100
							}
							DragAction {
								action: "on"
							}
							DragAction {
								action: "toggle"
							}
							DragAction {
								action: "bell"
							}
							DragAction{
								action: "slider"
								anchors.verticalCenter: parent.verticalCenter
							}
						}
					}
				}
			}
		}
	}

	ListView{
		id: availableSensorList
		visible: editable && selectedTabId > 0
		anchors.left: parent.left
		anchors.top: availableFavoriteList.bottom
		height: parent.height/3
		model: sensorModel
		header: Rectangle {
			width: MainScripts.TOOLBARWIDTH
			height: sensorHeader.height
			Text{
				id: sensorHeader
				font.bold: true
				text: 'Sensors'
				anchors.centerIn: parent
			}
		}
		z: 160 //over everything

		delegate: Rectangle{
			id: availableSensorDelegate
			property variant dragActionImage: undefined
			height: sensorText.height
			width: MainScripts.TOOLBARWIDTH

			Text{
				id: sensorText
				text: sensor.name
			}

			MouseArea{
				anchors.fill: parent

				drag.target: undefined
				drag.axis: Drag.XandYAxis
				property bool moved: false

				onPressed: {
					var comp = Qt.createComponent("DragActionImage.qml");
					dragActionImage = comp.createObject(favoriteLayout);
					dragActionImage.source = '../sensor.png'
					drag.target = dragActionImage;
					drag.minimumX = MainScripts.TOOLBARWIDTH
					drag.maximumX = favoriteLayout.width - dragActionImage.width
					drag.minimumY = 0;
					drag.maximumY = favoriteLayout.height - dragActionImage.height;
					dragActionImage.x = mapToItem(favoriteLayout, mouseX, mouseY).x - dragActionImage.width/2;
					dragActionImage.y = mapToItem(favoriteLayout, mouseX, mouseY).y - dragActionImage.height/2;
					moved = false;
				}

				onPositionChanged: {
					moved = true;
				}

				onReleased: {
					var newX = mapToItem(favoriteLayout, mouseX, mouseY).x - MainScripts.TOOLBARWIDTH - dragActionImage.width/2
					var newY = dragActionImage.y;

					var maxWidth = favoriteLayout.width - MainScripts.TOOLBARWIDTH - MainScripts.VISUALSENSORWIDTH
					var maxHeight = favoriteLayout.height-MainScripts.VISUALDEVICEHEIGHT;
					if(newX > maxWidth){
						newX = maxWidth;
					}
					if(newY > maxHeight){
						newY = maxHeight;
					}
					if(newY < 0){
						newY = 0;
					}
					if(newX < 0){
						newX = 0;
					}

					if(moved){
						//do nothing if not moved
						VisualDeviceList.visualDevicelist.addVisualDevice(newX, newY, sensor.id, selectedTabId, MainScripts.SENSOR);
					}

					if(dragActionImage != undefined){
						dragActionImage.destroy();
					}
				}
			}
		}
	}
}

import Qt 4.7
import "../mainscripts.js" as MainScripts
import "VisualDeviceList.js" as VisualDeviceList
import ".."

Rectangle {
	property int selectedTabId: 1 //default
	property int selectedVisualDevice
	property variant visibleMenu

	id: favoriteLayout

	Rectangle{
		id: tabSelection
		property alias tabButtonRow: tabButtonRow
		color: "darkgray"
		height: tabButtonRow.height //parent.height/2
		anchors.left: parent.left
		anchors.top: parent.top
		width: MainScripts.TOOLBARWIDTH  //TODO
		z: 99
		Column{
			id: tabButtonRow
			//height: parent.height
			width: parent.width

			TabButton{
				name: "Add new layout"
				onClicked: {
					VisualDeviceList.tabAreaList.insertTabArea('New layout', '');
				}
			}
		}

		Component{
			id: tabSelectionButton
			TabButton{
				z: 99
				onClicked: {
					favoriteLayout.selectedTabId = selectionTabId;
				}
				onReleased: {
					VisualDeviceList.tabAreaList.deleteTabArea(selectionTabId);
					selectedTabId = 1; //TODO default, but what if this is deleted?
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
			color: "gray"
			anchors.left: tabSelection.right
			anchors.top: tabSelection.top
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
		z: 160 //above everything
		header: Text {
			font.bold: true
			text: 'Devices'
		}

		delegate: Rectangle{
			id: availableListDelegate
			height: deviceText.height
			width: 100 //TODO
			Text{
				id: deviceText
				text: device.name
			}

			MouseArea{
				anchors.fill: parent
				property int initialX: 0
				property int initialY: 0

				property variant mappedCoord: favoriteLayout.mapToItem(availableFavoriteList, 0, 0); //TODO doesn't work for first list element for some reason...

				drag.target: availableListDelegate
				drag.axis: Drag.XandYAxis
				drag.minimumX: mappedCoord.x
				drag.maximumX: mappedCoord.x + favoriteLayout.width - availableListDelegate.width
				drag.minimumY: mappedCoord.y
				drag.maximumY: mappedCoord.y + favoriteLayout.height - availableListDelegate.height

				onPressed: {
					initialX = availableListDelegate.x;
					initialY = availableListDelegate.y;
				}

				onReleased: {

					var newX = availableListDelegate.x - availableListDelegate.width/2;
					var newY = availableListDelegate.y - availableListDelegate.height/2;
					var mapped = availableFavoriteList.mapToItem(favoriteLayout, newX, newY);
					newX = mapped.x;
					newY = mapped.y;

					var maxWidth = favoriteLayout.width - 100; //TODO constants!
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

					if(newX >= 0){
						//do nothing if dropped on list again
						VisualDeviceList.visualDevicelist.addVisualDevice(newX, newY, device.id, selectedTabId);
					}
					availableListDelegate.x = initialX; //reset item location
					availableListDelegate.y = initialY;
				}

				onClicked:{
					console.log("Show popup (perhaps use Mickes?) with action icons that can be dragged...");
					actionPopup.visible = true;
				}
			}

			Menu{
				id: actionPopup
				containInside: favoriteLayout
				content: Component {
					Item{
						height: childrenRect.height
						width: 200 //TODO
						Text{
							id: descText
							text: "Drag an action to the layout panel, or drag a whole device from the list"
							wrapMode: Text.WordWrap
							width: parent.width
						}

						//action for on/off if supported, toggle, dim (slider and presets)...
						Row{
							id: buttonrow
							anchors.top: descText.bottom

							DragAction {
								action: "off"
							}
							DragAction {
								action: "on"
							}
							DragAction {
								action: "bell"
							}
							DragAction {
								action: "dim"
								dimvalue: 25
							}
							DragAction {
								action: "dim"
								dimvalue: 50
							}
							DragAction {
								action: "dim"
								dimvalue: 75
							}
						}
						//TODO SLIDER
					}
				}
			}
		}
	}

	ListView{
		id: availableSensorList
		anchors.left: parent.left
		anchors.top: availableFavoriteList.bottom
		height: parent.height/3
		model: sensorModel
		header: Text {
			font.bold: true
			text: 'Sensors'
		}
		z: 160 //over everything

		delegate: Rectangle{
			id: availableSensorDelegate
			height: sensorText.height
			width: 100 //TODO

			Text{
				id: sensorText
				text: sensor.name
			}

			MouseArea{
				anchors.fill: parent
				property int initialX: 0
				property int initialY: 0

				property variant mappedCoord: favoriteLayout.mapToItem(availableSensorList, 0, 0); //TODO doesn't work for first list element for some reason...

				drag.target: availableSensorDelegate
				drag.axis: Drag.XandYAxis
				drag.minimumX: mappedCoord.x
				drag.maximumX: mappedCoord.x + favoriteLayout.width - availableSensorDelegate.width
				drag.minimumY: mappedCoord.y
				drag.maximumY: mappedCoord.y + favoriteLayout.height - availableSensorDelegate.height

				onPressed: {
					initialX = availableSensorDelegate.x;
					initialY = availableSensorDelegate.y;
				}

				onReleased: {

					//TODO some reuse perhaps...
					var newX = availableSensorDelegate.x - availableSensorDelegate.width/2;
					var newY = availableSensorDelegate.y - availableSensorDelegate.height/2;
					var mapped = availableSensorList.mapToItem(favoriteLayout, newX, newY);
					newX = mapped.x;
					newY = mapped.y;

					var maxWidth = favoriteLayout.width - 100; //TODO constants!
					var maxHeight = favoriteLayout.height-MainScripts.VISUALDEVICEHEIGHT;  //TODO, maybe not same height for sensors
					if(newX > maxWidth){
						newX = maxWidth;
					}
					if(newY > maxHeight){
						newY = maxHeight;
					}
					if(newY < 0){
						newY = 0;
					}

					if(newX >= 0){
						//do nothing if dropped on list again
						VisualDeviceList.visualDevicelist.addVisualDevice(newX, newY, sensor.id, selectedTabId, MainScripts.SENSOR);
					}
					availableSensorDelegate.x = initialX; //reset item location
					availableSensorDelegate.y = initialY;
				}
			}
		}
	}

	MouseArea{
		anchors.fill: parent
		onClicked: {
			visibleMenu.visible = false
		}
		visible: visibleMenu != undefined
	}
}

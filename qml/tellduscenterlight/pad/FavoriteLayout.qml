import Qt 4.7
import "../mainscripts.js" as MainScripts
import "VisualDeviceList.js" as VisualDeviceList
import ".."

Rectangle {
	property int selectedTabId: 1 //default

	id: favoriteLayout

	Rectangle{
		id: tabSelection
		property alias tabButtonRow: tabButtonRow
		color: "darkgray"
		height: tabButtonRow.height //parent.height/2
		anchors.left: parent.left
		anchors.top: parent.top
		width: MainScripts.TOOLBARWIDTH  //TODO
		Column{
			id: tabButtonRow
			//height: parent.height
			width: parent.width

			TabButton{
				name: "Add new layout"
				onClicked: {
					console.log("ADD new layout");
					//TODO
				}
			}
		}
		//TODO button for each tab
		//then another button för adding new tab, and possibly upload image (menu options), or option for this in lower right corner or something

		Component{
			id: tabSelectionButton
			TabButton{
				onClicked: {
					favoriteLayout.selectedTabId = selectionTabId;
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

	DeviceListModel{
		id: deviceListModel
	}

	ListView{
		id: availableFavoriteList
		anchors.left: parent.left
		anchors.top: tabSelection.bottom
		height: parent.height/2
		model: deviceListModel

		delegate: Item{
			id: availableListDelegate
			height: deviceText.height
			width: 100
			Text{
				id: deviceText
				text: model.deviceName
			}

			MouseArea{
				anchors.fill: parent
				property int initialX: 0
				property int initialY: 0

				drag.target: availableListDelegate
				drag.axis: Drag.XandYAxis
				drag.minimumX: 0
				drag.maximumX: 800 //TODO

				onPressed: {
					initialX = availableListDelegate.x;
					initialY = availableListDelegate.y;
				}

				onReleased: {
					if(true || availableListDelegate.x < width && availableListDelegate.y < height){ //TODO, check if dropped within correct bounds
						VisualDeviceList.visualDevicelist.addVisualDevice(availableListDelegate.x - availableListDelegate.width/2, availableListDelegate.y - availableListDelegate.height/2, model.deviceId, tabId);
						availableListDelegate.x = initialX; //reset item location
						availableListDelegate.y = initialY;

						//VisualDeviceList.list.device(model.deviceId).layoutPosition(availableListDelegate.x + availableListDelegate.width/2, availableListDelegate.y + availableListDelegate.height/2, 1);
						//TODO move item back
					}
				}
			}
			//visible: model.tabId != 0 //only show if not already added to a layout (TODO to THIS layout?)
		}
	}
}

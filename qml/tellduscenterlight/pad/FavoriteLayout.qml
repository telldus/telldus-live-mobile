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
		z: 99
		Column{
			id: tabButtonRow
			//height: parent.height
			width: parent.width

			TabButton{
				name: "Add new layout"
				onClicked: {
					console.log("ADD new layout");
					VisualDeviceList.tabAreaList.insertTabArea('New layout', '');
				}
			}
		}
		//TODO button for each tab
		//then another button för adding new tab, and possibly upload image (menu options), or option for this in lower right corner or something

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

	DeviceListModel{
		id: deviceListModel
	}

	ListView{
		id: availableFavoriteList
		anchors.left: parent.left
		anchors.top: tabSelection.bottom
		height: parent.height/2
		model: deviceListModel
		z: 100 //over everything

		delegate: Item{
			id: availableListDelegate
			height: deviceText.height
			width: 100 //TODO
			Text{
				id: deviceText
				text: model.deviceName
			}

			MouseArea{
				anchors.fill: parent
				property int initialX: 0
				property int initialY: 0

				property variant mappedCoord: favoriteLayout.mapToItem(availableFavoriteList, 0, 0); //TODO doesn't work for first list element for some reason...

				drag.target: availableListDelegate
				drag.axis: Drag.XandYAxis
				drag.minimumX: mappedCoord.x
				drag.maximumX: mappedCoord.x + favoriteLayout.width - deviceText.width
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
						VisualDeviceList.visualDevicelist.addVisualDevice(newX, newY, model.deviceId, selectedTabId);
					}
					availableListDelegate.x = initialX; //reset item location
					availableListDelegate.y = initialY;
				}
			}
		}
	}
}

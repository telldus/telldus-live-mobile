import Qt 4.7
import "DeviceList.js" as DeviceList
import "DeviceListModel.js" as Script

ListModel {
	id: deviceListModel

	Component.onCompleted: {
		Script.init(DeviceList.list);
		DeviceList.list.deviceAdded.connect(deviceAdded);
		DeviceList.list.deviceRemoved.connect(deviceRemoved);
	}

	property int favoriteCount: 0

	function deviceAdded(device){
		if(device.isFavorite() == true){
			favoriteCount++;
		}
		device.onChanged.connect(deviceChanged, device);
	}

	function deviceRemoved(device){
		if(device.isFavorite() == true){
			favoriteCount--;
		}
	}

	function deviceChanged(type){
		if(type == 'favorite'){
			if(this.isFavorite()){
				favoriteCount++;
			}
			else{
				favoriteCount--;
			}
		}
	}

}

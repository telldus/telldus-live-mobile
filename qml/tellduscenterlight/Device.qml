import Qt 4.7
import "DeviceList.js" as DeviceList

Item {
	id: device
	property int deviceId: 0
	property bool favorite: false
	onFavoriteChanged: getDevice().setIsFavorite(favorite)
	property int methods: 0
	property string name: ''
	property int state: 0
	property string statevalue: ''

	function turnOn() {
		getDevice().turnOn();
	}
	function turnOff() {
		getDevice().turnOff();
	}
	function bell() {
		getDevice().bell();
	}
	function dim(value) {
		getDevice().dim(value);
	}

	function getDevice() {
		return DeviceList.list.device(deviceId)
	}
	Component.onCompleted: {
		device.deviceId = deviceId;

		var jsDevice = getDevice();
		device.favorite = jsDevice.isFavorite();
		device.methods = jsDevice.methods();
		device.name = jsDevice.name();
		device.state = jsDevice.state();
		device.statevalue = jsDevice.statevalue();

		jsDevice.onChanged.connect(function(what) {
			if (what == 'name') {
				device.name = this.name();
			} else if (what == 'favorite') {
				device.favorite = this.isFavorite()
			} else if (what == 'state') {
				device.state = this.state();
			} else if (what == 'statevalue') {
				device.statevalue = this.statevalue();
			}
		}, jsDevice);
	}
}

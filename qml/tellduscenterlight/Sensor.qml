import Qt 4.7
import "Sensors.js" as Sensors

Item {
	id: sensor
	property int sensorId: 0
	property string name: ''
	property date lastUpdated

	property string temperature: ''
	property bool hasTemperature: false

	property string humidity: ''
	property bool hasHumidity: false

	Component.onCompleted: {
		var jsSensor = Sensors.list.sensor(sensorId);
		sensor.name = jsSensor.name();
		var date = new Date(jsSensor.updated()*1000);
		sensor.lastUpdated = date.toISOString();

		var updateValue = function(what) {
			if (what == 'temp') {
				sensor.temperature = jsSensor.value('temp');
				sensor.hasTemperature = true
			} else if (what == 'humidity') {
				sensor.humidity = jsSensor.value('humidity');
				sensor.hasHumidity = true
			}
		}

		if (jsSensor.hasValue('temp')) {
			updateValue('temp');
		}
		if (jsSensor.hasValue('humidity')) {
			updateValue('humidity');
		}

		jsSensor.onChanged.connect(function(what) {
			if (what == 'name') {
				sensor.name = this.name();
			} else if (what == 'lastUpdated') {
				var date = new Date(this.updated()*1000);
				sensor.lastUpdated = date.toISOString();
			} else {
				updateValue(what);
			}
		}, jsSensor);
	}
}

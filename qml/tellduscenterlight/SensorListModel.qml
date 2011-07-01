import Qt 4.7
import "Sensors.js" as Sensors
import "SensorListModel.js" as Script

ListModel {
	id: sensorListModel

	Component.onCompleted: {
		Script.init(Sensors.list);
	}
}

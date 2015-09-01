var db = LocalStorage.openDatabaseSync("TelldusLiveMobile", "", "Settings used by Telldus Live! mobile", 1000000);

var latestVersion = "1.4";

db.changeVersion(db.version, latestVersion, function(tx) {
	if (db.version < 1.0) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS Device (id INTEGER PRIMARY KEY, name TEXT, methods INTEGER, type INTEGER, favorite INTEGER, state INTEGER, statevalue TEXT)');
		tx.executeSql('CREATE TABLE IF NOT EXISTS Sensor (id INTEGER PRIMARY KEY, name TEXT, lastUpdated INTEGER, temperature REAL, humidity REAL)');
	}
	if (db.version < 1.1) {
		tx.executeSql('ALTER TABLE Sensor ADD rainRate REAL');
		tx.executeSql('ALTER TABLE Sensor ADD rainTotal REAL');
		tx.executeSql('ALTER TABLE Sensor ADD uv REAL');
		tx.executeSql('ALTER TABLE Sensor ADD watt REAL');
		tx.executeSql('ALTER TABLE Sensor ADD windAvg REAL');
		tx.executeSql('ALTER TABLE Sensor ADD windGust REAL');
		tx.executeSql('ALTER TABLE Sensor ADD windDir REAL');
	}
	if (db.version < 1.2) {
		tx.executeSql('ALTER TABLE Sensor ADD luminance REAL');
		tx.executeSql('ALTER TABLE Sensor ADD favorite INTEGER');
	}
	if (db.version < 1.3) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS Scheduler (id INTEGER PRIMARY KEY, deviceId INTEGER, method INTEGER, methodValue TEXT, nextRunTime INTEGER, type INTEGER, hour INTEGER, minute INTEGER, offset INTEGER, randomInterval INTEGER, retries INTEGER, retryInterval INTEGER, weekdays TEXT)');

	}
	if (db.version < 1.4) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS Client (id INTEGER PRIMARY KEY, name TEXT, online INTEGER, editable INTEGER, version TEXT, type TEXT)');
	}
});

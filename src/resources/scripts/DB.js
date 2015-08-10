var db = LocalStorage.openDatabaseSync("TelldusLiveMobile", "", "Settings used by Telldus Live! mobile", 1000000);

var latestVersion = "1.2";

db.changeVersion(db.version, latestVersion, function(tx) {
	if (db.version < 1.0) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS Device(id INTEGER PRIMARY KEY, name TEXT, methods INTEGER, type INTEGER, favorite INTEGER, state INTEGER, statevalue TEXT)');
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
});

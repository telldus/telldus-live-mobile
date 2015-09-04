import QtQuick 2.0

pragma Singleton

Object {
	id: units

	function dp(number) {
		return Math.round(number * SCALEFACTOR);
	}

	function gu(number) {
		return number * gridUnit
	}

	property int gridUnit: dp(64)
}

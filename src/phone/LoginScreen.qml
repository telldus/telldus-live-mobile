import QtQuick 1.0

Item {
	id: loginScreen

	Loader {
		source: HAVE_WEBKIT ? "LoginWebKit.qml" : "LoginNonWebKit.qml"
		anchors.fill: parent
	}
}

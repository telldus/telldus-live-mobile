import QtQuick 1.0

Item {
	id: loginScreen
	Header { id: header }

	Loader {
		source: HAVE_WEBKIT ? "LoginWebKit.qml" : "LoginNonWebKit.qml"
		anchors.top: header.bottom
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: parent.bottom
	}
}

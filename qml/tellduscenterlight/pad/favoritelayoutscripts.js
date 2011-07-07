function fillVisualObjects() {
	var visualDevice = Qt.createComponent("VisualDevice.qml");
	//TODO check ready
	var visualObject = visualDevice.createObject(tabArea);
	visualObject.x = 100;
	visualObject.y = 100;
}

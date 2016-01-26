var numOfElements = 4;
var indicatorRects = new Array(numOfElements);
var allStarted = false;
var currentIndicator = 0;


function createIndicatorObject(currentIndicator) {
	var component = Qt.createComponent("qrc:/resources/qml/ProgressIndicatorRectangle.qml");
	if (component.status == Component.Ready) {
		indicatorRects[currentIndicator] = component.createObject(progressBarComponent, {"width": progressBarComponent.width, "height": progressBarComponent.height});
	}
}

function startNextIndicator() {
	if (currentIndicator > numOfElements) {
		currentIndicator = 0;
		allStarted = true;
		return;
	}

	if (indicatorRects[currentIndicator] == null) {
		createIndicatorObject(currentIndicator);
		return;
	}

	indicatorRects[currentIndicator].startAnimation();
	currentIndicator++;
}

function stopIndicators() {
	allStarted = false;
	currentIndicator = 0;

	for(var i=0; i<=Indicator.numOfElements; i++) {
		var indicator = indicatorRects[i];
		indicator.stopAnimation();
	}
}
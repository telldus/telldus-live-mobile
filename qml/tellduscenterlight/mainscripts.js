var FAVORITE = 1;
var DEVICE = 2;
var SENSOR = 3;
var SETTING = 4;

function getFriendlyText(mode){
	if(mode == FAVORITE){
		return "\u2605 Favorites";
	}
	else if(mode == DEVICE){
		return "\u2615 Devices";
	}
	else if(mode == SENSOR){
		return "\u2614 Sensors";
	}
	else if(mode == SETTING){
		return "\u2692 Settings";
	}
}

function methodContains(methods, method){
	//TODO constants...
	var methodid = 0
	if(method == "on"){
		methodid = 1;
	}
	else if(method == "off"){
		methodid = 2;
	}
	else if(method == "bell"){
		methodid = 4;
	}
	else if(method == "dim"){
		methodid = 16;
	}
	//TODO stop, up, down (, execute)

	return (methods & methodid);
}

var DEVICEROWHEIGHT = 50 * SCALEFACTOR;
var HEADERHEIGHT = 20 * SCALEFACTOR;
var SLIDERHEIGHT = 20 * SCALEFACTOR;
var TOOLBARHEIGHT = 50 * SCALEFACTOR;
var TOOLBARWIDTH = 100 * SCALEFACTOR; //TODO this should be dependent on the widest button text... Possible?
var MAINHEADERHEIGHT = 20 * SCALEFACTOR;
var SUBHEADERHEIGHT = 20 * SCALEFACTOR;

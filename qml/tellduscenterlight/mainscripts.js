var FAVORITE = 1;
var DEVICE = 2;
var SENSOR = 3;
var SETTING = 4;
var FULL_FAVORITE_LAYOUT = 5;
var FULL_DEVICE = 6;
var FULL_SENSOR = 7;
var SCHEDULER = 8;
var FULL_SETTING = 9;

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
	else if(mode == FULL_FAVORITE_LAYOUT){
		return "\u2328";  //TODO icons instead
	}
	else if(mode == FULL_DEVICE){
		return "\u2615";  //TODO icons instead
	}
	else if(mode == FULL_SENSOR){
		return "\u2614";  //TODO icons instead
	}
	else if(mode == SCHEDULER){
		return "\u1F552";  //TODO icons instead
	}
	else if(mode == FULL_SETTING){
		return "\u2692";  //TODO icons instead
	}
}

function getIconSource(mode){
	if(mode == FULL_FAVORITE_LAYOUT){
		//TODO
	}
	return ''
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
var MENUOPTIONHEIGHT = 30 * SCALEFACTOR;
var MARGIN_TEXT = 10 * SCALEFACTOR;
var VISUALDEVICEHEIGHT = 20 * SCALEFACTOR;
var VISUALDEVICEWIDTH = 20 * SCALEFACTOR;
var VISUALSENSORWIDTH = 80 * SCALEFACTOR;

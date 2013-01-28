#include "tellduscenter.h"
#include "config.h"
#import "TestFlight.h"
#import "UIKit/UIDevice.h"

void TelldusCenter::init() {
#if RELEASE_BUILD == 0
	[TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
#endif
	[TestFlight takeOff:TESTFLIGHT_TOKEN];
}


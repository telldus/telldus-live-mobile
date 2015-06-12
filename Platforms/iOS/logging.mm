#include <QDebug>

#include "GAI.h"
#include "GAIFields.h"
#include "GAIDictionaryBuilder.h"

#include "config.h"
#include "utils/dev.h"


void Dev::init() {
	[GAI sharedInstance].dispatchInterval = 10;
//	[[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
	[[GAI sharedInstance] trackerWithTrackingId:@GOOGLE_ANALYTICS_TRACKER];
}

void Dev::deinit() {
}

void Dev::logScreenView(const QString &screenName) {
	id tracker = [[GAI sharedInstance] defaultTracker];
	[tracker set:kGAIScreenName value: screenName.toNSString()];
	[tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

void Dev::logEvent(const QString &category, const QString &action, const QString &label){
	id tracker = [[GAI sharedInstance] defaultTracker];
	[tracker send:[[GAIDictionaryBuilder createEventWithCategory:category.toNSString()
														action:action.toNSString()
														label:label.toNSString()
														value:nil] build]];
}
#include <QDebug>

#include "GAI.h"
#include "GAIFields.h"
#include "GAIDictionaryBuilder.h"

#include "config.h"
#include "utils/dev.h"


void Dev::init() {
#if IS_FEATURE_GOOGLEANALYTICS_ENABLED
	[GAI sharedInstance].dispatchInterval = 10;
	[[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelInfo];
	[[GAI sharedInstance] trackerWithTrackingId:@GOOGLE_ANALYTICS_TRACKER];
#endif

}

void Dev::deinit() {
}

void Dev::logScreenView(const QString &screenName) {
#if IS_FEATURE_LOGGING_ENABLED
    qDebug().noquote() << "[LOG:SCREENVIEW] " + screenName;
#endif
#if IS_FEATURE_GOOGLEANALYTICS_ENABLED
	id tracker = [[GAI sharedInstance] defaultTracker];
	[tracker set:kGAIScreenName value: screenName.toNSString()];
	[tracker send:[[GAIDictionaryBuilder createScreenView] build]];
#endif
}

void Dev::logEvent(const QString &category, const QString &action, const QString &label){
#if IS_FEATURE_LOGGING_ENABLED
	qDebug().noquote() << "[LOG:EVENT] Category: " + category + ", Action: " + action + ", Label: " + label;
#endif
#if IS_FEATURE_GOOGLEANALYTICS_ENABLED
	id tracker = [[GAI sharedInstance] defaultTracker];
	[tracker send:[[GAIDictionaryBuilder createEventWithCategory:category.toNSString() action:action.toNSString() label:label.toNSString() value:nil] build]];
#endif
}
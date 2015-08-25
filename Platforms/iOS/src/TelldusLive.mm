#include <QDebug>
#import "UIKit/UIKit.h"

#include "config.h"
#include "tellduslive.h"
#include "user.h"

void TelldusLive::registerForPush() {
	qDebug() << "[PUSH] Registration";
	UIApplication *application = [UIApplication sharedApplication];
	if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
		[application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
		[application registerForRemoteNotifications];
	} else {
		[application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
	}
}
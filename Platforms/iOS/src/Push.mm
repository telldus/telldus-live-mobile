#include "push.h"

#include <QDebug>
#import "UIKit/UIKit.h"
#import <sys/utsname.h>

void Push::registerForPush() {
	qDebug() << "[PUSH] Registration";
	UIApplication *application = [UIApplication sharedApplication];
	if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
		[application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
		[application registerForRemoteNotifications];
	} else {
		[application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
	}
}

void Push::didRegisterForRemoteNotificationsWithDeviceToken(NSData *deviceToken) {
	NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];

    struct utsname systemInfo;
    uname(&systemInfo);
    QString deviceName = QString::fromNSString([NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding]);

	qDebug().noquote() << "[PUSH] Token: " << QString::fromNSString(token);
	qDebug().noquote() << "[PUSH] Device Name: " << QString::fromNSString([[UIDevice currentDevice] name]);
	qDebug().noquote() << "[PUSH] Device System Version: " << QString::fromNSString([[UIDevice currentDevice] systemVersion]);
	qDebug().noquote() << "[PUSH] Device Model: " << deviceName;

	registerToken(QString::fromNSString(token), QString::fromNSString([[UIDevice currentDevice] name]), "Apple", deviceName, QString::fromNSString([[UIDevice currentDevice] systemVersion]));
}

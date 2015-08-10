#include <QDebug>
#import <sys/utsname.h>

#import "QtAppDelegate.h"
#include "TelldusLive.h"


@implementation QtAppDelegate
static QtAppDelegate *sharedAppDelegate = nil;

+(QtAppDelegate *)sharedQtAppDelegate{
	static dispatch_once_t pred;
	static QtAppDelegate *shared = nil;
	dispatch_once(&pred, ^{
		shared = [[super alloc] init];
	});
	return shared;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	qDebug() << "[APP] Did this launch option happen 1";
	return YES;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	qDebug() << "[APP] Did this launch option happen 2";
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	qDebug() << "[APP] In the background";
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	qDebug() << "[APP] In the foreground";
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

void QtAppDelegateInitialize ()
{
	//want this function to get the current UIApplication, and set itself as the new app delegate.
	[[UIApplication sharedApplication] setDelegate:[QtAppDelegate sharedQtAppDelegate]];
	[[QtAppDelegate sharedQtAppDelegate] setWindow:sharedAppDelegate.window];

	qDebug() << "[APP] AppDelegate Initialized";
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    qDebug().noquote() << "[PUSH] Token: " << QString::fromNSString(token);
    qDebug().noquote() << "[PUSH] Device Name: " << QString::fromNSString([[UIDevice currentDevice] name]);
    qDebug().noquote() << "[PUSH] Device System Version: " << QString::fromNSString([[UIDevice currentDevice] systemVersion]);
    qDebug().noquote() << "[PUSH] Device Model: " << QString::fromNSString([QtAppDelegate deviceName]);

    TelldusLive *telldusLive = TelldusLive::instance();
    if (!telldusLive->isAuthorized()) {
        return;
    }
    telldusLive->registerPushTokenWithApi(QString::fromNSString(token),
                                          QString::fromNSString([[UIDevice currentDevice] name]),
                                          "Apple",
                                          QString::fromNSString([QtAppDelegate deviceName]),
                                          QString::fromNSString([[UIDevice currentDevice] systemVersion])
                                          );
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    qDebug().noquote() << QString("[PUSH] Failed to get token, error: %1").arg(QString::fromNSString(error.description));
}

+ (NSString*) deviceName
{
    struct utsname systemInfo;
    uname(&systemInfo);

    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

@end

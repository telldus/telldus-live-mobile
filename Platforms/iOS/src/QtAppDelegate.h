#import <UIKit/UIKit.h>
#import <QtAppDelegate-C-Interface.h>

@interface QtAppDelegate : UIResponder <UIApplicationDelegate>
+(QtAppDelegate *)sharedQtAppDelegate;
@property (strong, nonatomic) UIWindow *window;

@end
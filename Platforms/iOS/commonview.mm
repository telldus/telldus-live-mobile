#include "commonview.h"
#include <QtGui>
#include <QtGui/qpa/qplatformnativeinterface.h>
#include <QtQuick>
#include <QDebug>
#import "UIKit/UIKit.h"
#import "UIKit/UIScreen.h"

@interface WebViewDelegate : NSObject <UIWebViewDelegate> {
	CommonView *m_view;
}
@end

@implementation WebViewDelegate

- (id) initWithView:(CommonView *)view
{
	self = [super init];
	if (self) {
		m_view = view;
	}
	return self;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	QUrl url = QUrl::fromNSURL([request URL]);
	if (url.scheme() == "x-com-telldus-live-mobile") {
		// Bring back Qt's view controller:
		UIViewController *rvc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
		[rvc dismissViewControllerAnimated:YES completion:nil];
	}
	return YES;
}

@end

void CommonView::init() {
	iosDelegate = [[WebViewDelegate alloc] initWithView:this];
	[[NSUserDefaults standardUserDefaults] registerDefaults:@{ @"UserAgent" : @"Telldus Live! mobile iOS" }];
}

QSize CommonView::windowSize() const {
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	CGFloat screenWidth = screenRect.size.width;
	CGFloat screenHeight = screenRect.size.height;
	return QSize(screenWidth, screenHeight);
}

void CommonView::openUrl(const QUrl &url) {
	// Get the UIView that backs our QQuickWindow:
	UIView *view = static_cast<UIView *>(
																			 QGuiApplication::platformNativeInterface()
																			 ->nativeResourceForWindow("uiview", this->view()));
	UIViewController *qtController = [[view window] rootViewController];

	// Create a new webview controller to show on top of Qt's view controller:
	UIViewController *webViewController = [[[UIViewController alloc] init] autorelease];
	UIWebView *webView = [[[UIWebView alloc] init] autorelease];
	[webView setDelegate: id(iosDelegate)];
	webViewController.view = webView;

	[webView loadRequest:[NSURLRequest requestWithURL:url.toNSURL()]];

	// Tell the imagecontroller to animate on top:
	[qtController presentViewController:webViewController animated:YES completion:nil];
}

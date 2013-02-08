#include "view.h"
#import "UIKit/UIScreen.h"

QSize View::windowSize() const {
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	CGFloat screenWidth = screenRect.size.width;
	CGFloat screenHeight = screenRect.size.height;
	return QSize(screenWidth, screenHeight);
}


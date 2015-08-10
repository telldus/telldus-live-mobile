#include "ObjectiveUtils.h"
#include <UIKit/UIKit.h>

void ObjectiveUtils::setGoodStatusBarStyle()
{
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
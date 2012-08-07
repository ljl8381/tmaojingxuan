//
//  NavigationBar+NC.m
//  My
//
//  Created by Neusoft on 11-6-28.
//

#import "NavigationBar+FG.h"
#import "Color+Hex.h"


#define kDefaultBarFrame			CGRectMake(0, 0, 320, 44)
#define kNavigationFrameOffset 22
#define kNavigationBarHeight 44
// ---------------- Duration ----------------
#define kDurationSystemAnimation 0.3
// ---------------- Tag ----------------
#define kNavigationWithCategory 100
#define kIntZero					0
#define kFloatZero					0.0
#define kStatusBarheight			20
#define kDefaultBarheight			44
#define kSystemAnimationDuration	0.3
#define kScreenWidth                320
#define kDefaultBackgroundColor			[UIColor blueColor]
#define kDefaultBackgroundImageFile		@"image_nav_background.png"
#define kDefaultSourcePath				[[NSBundle mainBundle] resourcePath]
#define kDefaultImageSourcePath			[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"default"]

// the full path of the default image
#define kDefaultBackgroundImagePath		[kDefaultImageSourcePath stringByAppendingPathComponent:kDefaultBackgroundImageFile]

@implementation  UINavigationBar(BB)

/*
 * Redraw the navigation bar rect
 */

- (void)drawRect:(CGRect)rect
{
    
	self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"head_bg.png"]];
    
	//The background image
//	UIImage *backgroundImage = nil;     
//	backgroundImage = [UIImage imageNamed:kDefaultBackgroundImageFile];
//	// Draw the background image
//	[backgroundImage drawInRect:kDefaultBarFrame];

}



@end

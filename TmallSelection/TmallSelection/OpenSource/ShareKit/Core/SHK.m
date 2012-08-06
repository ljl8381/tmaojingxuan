//
//  SHK.m
//  ShareKit
//
//  Created by Nathan Weiner on 6/10/10.

//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//

#import "SHK.h"
#import "SHKActivityIndicator.h"
#import "SFHFKeychainUtils.h"
#import "Reachability.h"
#import </usr/include/objc/objc-class.h>
//#import <MessageUI/MessageUI.h>
#import "SHKSharer.h"


@implementation SHK

@synthesize currentView, pendingView, isDismissingView;
@synthesize rootViewController;

static SHK *currentHelper = nil;
BOOL SHKinit;


+ (SHK *)currentHelper
{
	if (currentHelper == nil)
		currentHelper = [[SHK alloc] init];
	
	return currentHelper;
}

+ (void)initialize
{
	[super initialize];
	
	if (!SHKinit)
	{
		SHKinit = YES;
	}
}

- (void)dealloc
{
	[currentView release];
	[pendingView release];
	[super dealloc];
}



#pragma mark -
#pragma mark View Management

+ (void)setRootViewController:(UIViewController *)vc
{	
	SHK *helper = [self currentHelper];
	[helper setRootViewController:vc];	
}

- (void)showViewController:(UIViewController *)vc
{	
	if (rootViewController == nil)
	{
		// Try to find the root view controller programmically
		
		// Find the top window (that is not an alert view or other window)
		UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
		if (topWindow.windowLevel != UIWindowLevelNormal)
		{
			NSArray *windows = [[UIApplication sharedApplication] windows];
			for(topWindow in windows)
			{
				if (topWindow.windowLevel == UIWindowLevelNormal)
					break;
			}
		}
		
		UIView *rootView = [[topWindow subviews] objectAtIndex:0];	
		id nextResponder = [rootView nextResponder];
		
		if ([nextResponder isKindOfClass:[UIViewController class]])
			self.rootViewController = nextResponder;
		
		else
			NSAssert(NO, @"ShareKit: Could not find a root view controller.  You can assign one manually by calling [[SHK currentHelper] setRootViewController:YOURROOTVIEWCONTROLLER].");
	}
	
	// Find the top most view controller being displayed (so we can add the modal view to it and not one that is hidden)
	UIViewController *topViewController = [self getTopViewController];	
	if (topViewController == nil)
		NSAssert(NO, @"ShareKit: There is no view controller to display from");
	
		
	// If a view is already being shown, hide it, and then try again
	if (currentView != nil)
	{
		self.pendingView = vc;
		[currentView dismissModalViewControllerAnimated:YES];
		return;
	}
		
	// Wrap the view in a nav controller if not already
	if (![vc respondsToSelector:@selector(pushViewController:animated:)])
	{
		UINavigationController *nav = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
		
		if ([nav respondsToSelector:@selector(modalPresentationStyle)])
			nav.modalPresentationStyle = [SHK modalPresentationStyle];
		
		if ([nav respondsToSelector:@selector(modalTransitionStyle)])
			nav.modalTransitionStyle = [SHK modalTransitionStyle];
		
		nav.navigationBar.barStyle = nav.toolbar.barStyle = [SHK barStyle];
		
		[topViewController presentModalViewController:nav animated:YES];			
		self.currentView = nav;
	}
	
	// Show the nav controller
	else
	{		
		if ([vc respondsToSelector:@selector(modalPresentationStyle)])
			vc.modalPresentationStyle = [SHK modalPresentationStyle];
		
		if ([vc respondsToSelector:@selector(modalTransitionStyle)])
			vc.modalTransitionStyle = [SHK modalTransitionStyle];
		
		[topViewController presentModalViewController:vc animated:YES];
		[(UINavigationController *)vc navigationBar].barStyle = 
		[(UINavigationController *)vc toolbar].barStyle = [SHK barStyle];
		self.currentView = vc;
	}
		
	self.pendingView = nil;		
}

- (void)hideCurrentViewController
{
	[self hideCurrentViewControllerAnimated:YES];
}

- (void)hideCurrentViewControllerAnimated:(BOOL)animated
{
	if (isDismissingView)
		return;
	
	if (currentView != nil)
	{
        [currentView dismissModalViewControllerAnimated:animated];
        self.isDismissingView = YES;
        /*
		// Dismiss the modal view
		if ([currentView parentViewController] != nil)
		{
			self.isDismissingView = YES;
			[[currentView parentViewController] dismissModalViewControllerAnimated:animated];
		}
		
		else
        {
            [currentView dismissModalViewControllerAnimated:animated];
            self.isDismissingView = YES;
			self.currentView = nil;
        }
         */
	}
}

- (void)showPendingView
{
    if (pendingView)
        [self showViewController:pendingView];
}


- (void)viewWasDismissed
{
    [[SHK currentHelper] hideCurrentViewControllerAnimated:YES];
	self.isDismissingView = NO;
	
	if (currentView != nil)
		currentView = nil;
	
	if (pendingView)
	{
		// This is an ugly way to do it, but it works.
		// There seems to be an issue chaining modal views otherwise
		// See: http://github.com/ideashower/ShareKit/issues#issue/24
		[self performSelector:@selector(showPendingView) withObject:nil afterDelay:0.02];
		return;
	}
}
										   
- (UIViewController *)getTopViewController
{
	UIViewController *topViewController = rootViewController;
	while (topViewController.modalViewController != nil)
		topViewController = topViewController.modalViewController;
	return topViewController;
}
			
+ (UIBarStyle)barStyle
{
	if ([SHKBarStyle isEqualToString:@"UIBarStyleBlack"])		
		return UIBarStyleBlack;
	
	else if ([SHKBarStyle isEqualToString:@"UIBarStyleBlackOpaque"])		
		return UIBarStyleBlackOpaque;
	
	else if ([SHKBarStyle isEqualToString:@"UIBarStyleBlackTranslucent"])		
		return UIBarStyleBlackTranslucent;
	
	return UIBarStyleDefault;
}

+ (UIModalPresentationStyle)modalPresentationStyle
{
	if ([SHKModalPresentationStyle isEqualToString:@"UIModalPresentationFullScreen"])		
		return UIModalPresentationFullScreen;
	
	else if ([SHKModalPresentationStyle isEqualToString:@"UIModalPresentationPageSheet"])		
		return UIModalPresentationPageSheet;
	
	else if ([SHKModalPresentationStyle isEqualToString:@"UIModalPresentationFormSheet"])		
		return UIModalPresentationFormSheet;
	
	return UIModalPresentationCurrentContext;
}

+ (UIModalTransitionStyle)modalTransitionStyle
{
	if ([SHKModalTransitionStyle isEqualToString:@"UIModalTransitionStyleFlipHorizontal"])		
		return UIModalTransitionStyleFlipHorizontal;
	
	else if ([SHKModalTransitionStyle isEqualToString:@"UIModalTransitionStyleCrossDissolve"])		
		return UIModalTransitionStyleCrossDissolve;
	
	else if ([SHKModalTransitionStyle isEqualToString:@"UIModalTransitionStylePartialCurl"])		
		return UIModalTransitionStylePartialCurl;
	
	return UIModalTransitionStyleCoverVertical;
}

#pragma mark -

+ (NSError *)error:(NSString *)description, ...
{
	va_list args;
    va_start(args, description);
    NSString *string = [[[NSString alloc] initWithFormat:description arguments:args] autorelease];
    va_end(args);
	
	return [NSError errorWithDomain:@"sharekit" code:1 userInfo:[NSDictionary dictionaryWithObject:string forKey:NSLocalizedDescriptionKey]];
}

#pragma mark -
#pragma mark Network

+ (BOOL)connected 
{
	//return NO; // force for offline testing
	Reachability *hostReach = [Reachability reachabilityForInternetConnection];	
	NetworkStatus netStatus = [hostReach currentReachabilityStatus];	
	return !(netStatus == NotReachable);
}

@end


NSString * SHKStringOrBlank(NSString * value)
{
	return value == nil ? @"" : value;
}

NSString * SHKEncode(NSString * value)
{
	if (value == nil)
		return @"";
	
	NSString *string = value;
	
	string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
	string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	string = [string stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
	
	return string;	
}

NSString * SHKEncodeURL(NSURL * value)
{
	if (value == nil)
		return @"";
	
	NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)value.absoluteString,
                                                                           NULL,
																		   CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8);
    [result autorelease];
	return result;
}

NSString* SHKLocalizedString(NSString* key, ...) 
{
	// Localize the format
	NSString *localizedStringFormat = NSLocalizedString(key, key);
	
	va_list args;
    va_start(args, key);
    NSString *string = [[[NSString alloc] initWithFormat:localizedStringFormat arguments:args] autorelease];
    va_end(args);
	
	return string;
}

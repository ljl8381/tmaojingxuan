//
//  SHK.h
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

#define SHK_VERSION @"0.2.1"

#import <Foundation/Foundation.h>
//#import "SHKConfig.h"
#import "SHKItem.h"
#import "SHKActivityIndicator.h"
#import "UIWebView+SHK.h"


@interface SHK : NSObject 
{
	UIViewController *rootViewController;
	UIViewController *currentView;
	UIViewController *pendingView;
	BOOL isDismissingView;
}

@property (nonatomic, assign) UIViewController *rootViewController;
@property (nonatomic, retain) UIViewController *currentView;
@property (nonatomic, retain) UIViewController *pendingView;
@property BOOL isDismissingView;


#pragma mark -

+ (SHK *)currentHelper;


#pragma mark -
#pragma mark View Management

+ (void)setRootViewController:(UIViewController *)vc;
- (void)showViewController:(UIViewController *)vc;
- (void)hideCurrentViewControllerAnimated:(BOOL)animated;
- (void)viewWasDismissed;
- (UIViewController *)getTopViewController;

+ (UIBarStyle)barStyle;
+ (UIModalPresentationStyle)modalPresentationStyle;
+ (UIModalTransitionStyle)modalTransitionStyle;



#pragma mark -

+ (NSError *)error:(NSString *)description, ...;

#pragma mark -
#pragma mark Network

+ (BOOL)connected;

@end


NSString * SHKStringOrBlank(NSString * value);
NSString * SHKEncode(NSString * value);
NSString * SHKEncodeURL(NSURL * value);
NSString* SHKLocalizedString(NSString* key, ...);

//
//  SHKActivityIndicator.m
//  ShareKit
//
//  Created by Nathan Weiner on 6/16/10.

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

#import "SHKActivityIndicator.h"
#import <QuartzCore/QuartzCore.h>

#define SHKdegreesToRadians(x) (M_PI * x / 180.0)

@implementation SHKActivityIndicator

@synthesize centerMessageLabel, subMessageLabel,headMessageLabel;
@synthesize spinner;

static SHKActivityIndicator *currentIndicator = nil;

+ (SHKActivityIndicator *)currentIndicator
{
	if (currentIndicator == nil)
	{
		UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
		
		CGFloat width = 160;
		CGFloat height = 86;
		CGRect centeredFrame = CGRectMake(round(keyWindow.bounds.size.width/2 - width/2),
										  round(keyWindow.bounds.size.height/2 - height/2),
										  width,
										  height);
		
		currentIndicator = [[SHKActivityIndicator alloc] initWithFrame:centeredFrame];
		
		currentIndicator.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
		currentIndicator.opaque = NO;
		currentIndicator.alpha = 0;
		
		currentIndicator.layer.cornerRadius = 10;
		
		currentIndicator.userInteractionEnabled = NO;
		currentIndicator.autoresizesSubviews = YES;
		currentIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |  UIViewAutoresizingFlexibleTopMargin |  UIViewAutoresizingFlexibleBottomMargin;
		
		[currentIndicator setProperRotation:NO];
		
		[[NSNotificationCenter defaultCenter] addObserver:currentIndicator
												 selector:@selector(setProperRotation)
													 name:UIDeviceOrientationDidChangeNotification
												   object:nil];
	}
	
	return currentIndicator;
}


#pragma mark -

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
	
	[centerMessageLabel release];
	[subMessageLabel release];
    [headMessageLabel release];
	[spinner release];
	
	[super dealloc];
}

#pragma mark Creating Message

- (void)show
{	
	if ([self superview] != [[UIApplication sharedApplication] keyWindow]) 
		[[[UIApplication sharedApplication] keyWindow] addSubview:self];
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	
	self.alpha = 0.8;
	
	[UIView commitAnimations];
}

- (void)hideAfterDelay
{
	[self performSelector:@selector(hide) withObject:nil afterDelay:1.5];
}

- (void)hide
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(hidden)];
	
	self.alpha = 0;
	
	[UIView commitAnimations];
}

- (void)persist
{	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.1];
	
	self.alpha = 0.8;
	
	[UIView commitAnimations];
}

- (void)hidden
{
	if (currentIndicator.alpha > 0)
		return;
	
	[currentIndicator removeFromSuperview];
	currentIndicator = nil;
}

- (void)displayActivity:(NSString *)m
{	
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    CGFloat width = 160;
    CGFloat height = 160;
	currentIndicator.frame = CGRectMake(round(keyWindow.bounds.size.width/2 - width/2),
                                        round(keyWindow.bounds.size.height/2 - height/2),
                                        width,
                                        height);

	[self setSubMessage:m];
	[self showSpinner];	
	
	[centerMessageLabel removeFromSuperview];
	centerMessageLabel = nil;
	
	if ([self superview] == nil)
		[self show];
	else
		[self persist];
}

- (void)displayCompleted:(NSString *)m
{	
     UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGFloat width = 160;
    CGFloat height = 86;
	currentIndicator.frame = CGRectMake(round(keyWindow.bounds.size.width/2 - width/2),
                                        round(keyWindow.bounds.size.height/2 - height/2),
                                        width,
                                        height);
	[self setCenterMessage:m];
    [self setSubMessage:@""];
    [self.subMessageLabel removeFromSuperview];
	[spinner removeFromSuperview];
	spinner = nil;
	[currentIndicator removeFromSuperview];
	if ([self superview] == nil)
		[self show];
	else
		[self persist];
		
	[self hideAfterDelay];
}

- (void)displayErrorMessage
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    CGFloat width = 160;
    CGFloat height = 86;
	currentIndicator.frame = CGRectMake(round(keyWindow.bounds.size.width/2 - width/2),
                                        round(keyWindow.bounds.size.height/2 - height/2),
                                        width,
                                        height);
	[self setCenterMessage:@"同学你的网络不给力"];	
    [self setSubMessage:@""];
	[spinner removeFromSuperview];
	spinner = nil;
	
	if ([self superview] == nil)
		[self show];
	else
		[self persist];
    
	[self hideAfterDelay];
}
- (void)setCenterMessage:(NSString *)message
{	
	if (message == nil && centerMessageLabel != nil)
		self.centerMessageLabel = nil;

	else if (message != nil)
	{
		if (centerMessageLabel == nil)
		{
			self.centerMessageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(12,round(self.bounds.size.height/2-50/2),self.bounds.size.width-24,50)] autorelease];
			centerMessageLabel.backgroundColor = [UIColor clearColor];
			centerMessageLabel.opaque = NO;
			centerMessageLabel.textColor = [UIColor whiteColor];
			centerMessageLabel.font = [UIFont boldSystemFontOfSize:17];
			centerMessageLabel.textAlignment = UITextAlignmentCenter;
            centerMessageLabel.numberOfLines = 0;
			centerMessageLabel.shadowColor = [UIColor darkGrayColor];
			centerMessageLabel.shadowOffset = CGSizeMake(1,1);
			
			[self addSubview:centerMessageLabel];
		}
		
		centerMessageLabel.text = message;
	}
}

- (void)setSubMessage:(NSString *)message
{	
	if (message == nil && subMessageLabel != nil)
		self.subMessageLabel = nil;
	
	else if (message != nil)
	{
		if (subMessageLabel == nil)
		{
			self.subMessageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(12,self.bounds.size.height-45,self.bounds.size.width-24,30)] autorelease];
			subMessageLabel.backgroundColor = [UIColor clearColor];
			subMessageLabel.opaque = NO;
			subMessageLabel.textColor = [UIColor whiteColor];
			subMessageLabel.font = [UIFont boldSystemFontOfSize:17];
			subMessageLabel.textAlignment = UITextAlignmentCenter;
			subMessageLabel.shadowColor = [UIColor darkGrayColor];
			subMessageLabel.shadowOffset = CGSizeMake(1,1);
			subMessageLabel.adjustsFontSizeToFitWidth = YES;
			
			[self addSubview:subMessageLabel];
		}
		
		subMessageLabel.text = message;
	}
}

- (void)setHeadMessage:(NSString *)message
{	
    [self.spinner removeFromSuperview];
	if (message == nil && headMessageLabel != nil)
		self.headMessageLabel = nil;
	
	else if (message != nil)
	{
		if (headMessageLabel == nil)
		{
			self.headMessageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(12,round(self.bounds.size.height/2-120/2),self.bounds.size.width-24,30)] autorelease];
			headMessageLabel.backgroundColor = [UIColor clearColor];
			headMessageLabel.opaque = NO;
			headMessageLabel.textColor = [UIColor whiteColor];
			headMessageLabel.font = [UIFont boldSystemFontOfSize:17];
			headMessageLabel.textAlignment = UITextAlignmentCenter;
			headMessageLabel.shadowColor = [UIColor darkGrayColor];
			headMessageLabel.shadowOffset = CGSizeMake(1,1);
			headMessageLabel.adjustsFontSizeToFitWidth = YES;
			
			[self addSubview:headMessageLabel];
		}
		
		headMessageLabel.text = message;
	}
}
	 
- (void)showSpinner
{	
	if (spinner == nil)
	{
		self.spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];

		spinner.frame = CGRectMake(round(self.bounds.size.width/2 - spinner.frame.size.width/2),
								round(self.bounds.size.height/2 - spinner.frame.size.height/2),
								spinner.frame.size.width,
								spinner.frame.size.height);		
		//[spinner release];	
	}
	
	[self addSubview:spinner];
	[spinner startAnimating];
}

#pragma mark -
#pragma mark Rotation

- (void)setProperRotation
{
	[self setProperRotation:YES];
}

- (void)setProperRotation:(BOOL)animated
{
//	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	
	if (animated)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
	}
/**********只竖着loading************************************************/
//	if (orientation == UIDeviceOrientationPortraitUpsideDown)
//		self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, SHKdegreesToRadians(180));	
//	
//	else if (orientation == UIDeviceOrientationLandscapeLeft)
//		self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, SHKdegreesToRadians(90));	
//	
//	else if (orientation == UIDeviceOrientationLandscapeRight)
//		self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, SHKdegreesToRadians(-90));
	
	if (animated)
		[UIView commitAnimations];
}


@end

    //
//  SHKSharer.m
//  ShareKit
//
//  Created by Nathan Weiner on 6/8/10.

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

#import "SHKSharer.h"
#import "SHKActivityIndicator.h"
//#import "SHKFormFieldSettings.h"
//#import "FGHeader.h"
@implementation SHKSharer

@synthesize shareDelegate;
@synthesize item;
@synthesize lastError;
@synthesize quiet, pendingAction;

- (void)dealloc
{
	[item release];
	[shareDelegate release];
	[lastError release];
	
	[super dealloc];
}


#pragma mark -
#pragma mark Configuration : Service Defination

// Each service should subclass these and return YES/NO to indicate what type of sharing they support.
// Superclass defaults to NO so that subclasses only need to add methods for types they support

+ (NSString *)sharerTitle
{
	return @"";
}

- (NSString *)sharerTitle
{
	return [[self class] sharerTitle];
}

+ (NSString *)sharerId
{
	return NSStringFromClass([self class]);
}

- (NSString *)sharerId
{
	return [[self class] sharerId];	
}

+ (BOOL)canShareText
{
	return NO;
}

+ (BOOL)canShareURL
{
	return NO;
}

+ (BOOL)canShareImage
{
	return NO;
}

+ (BOOL)canShareFile
{
	return NO;
}

+ (BOOL)shareRequiresInternetConnection
{
	return YES;
}

+ (BOOL)canShareOffline
{
	return YES;
}

+ (BOOL)requiresAuthentication
{
	return YES;
}

+ (BOOL)canShareType:(SHKShareType)type
{
	switch (type) 
	{
		case SHKShareTypeURL:
			return [self canShareURL];
			break;
			
		case SHKShareTypeImage:
			return [self canShareImage];
			break;
			
		case SHKShareTypeText:
			return [self canShareText];
			break;
			
		case SHKShareTypeFile:
			return [self canShareFile];
			break;
        default:
            break;
	}
	return NO;
}

+ (BOOL)canAutoShare
{
	return YES;
}



#pragma mark -
#pragma mark Configuration : Dynamic Enable

// Allows a subclass to programically disable/enable services depending on the current environment

+ (BOOL)canShare
{
	return YES;
}

- (BOOL)shouldAutoShare
{	
	return [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@_shouldAutoShare", [self sharerId]]];
}


#pragma mark -
#pragma mark Initialization

- (id)init
{
	if (self = [super initWithNibName:nil bundle:nil])
	{
		self.shareDelegate = self;
		self.item = [[[SHKItem alloc] init] autorelease];
				
		if ([self respondsToSelector:@selector(modalPresentationStyle)])
			self.modalPresentationStyle = [SHK modalPresentationStyle];
		
		if ([self respondsToSelector:@selector(modalTransitionStyle)])
			self.modalTransitionStyle = [SHK modalTransitionStyle];
	}
	return self;
}


#pragma mark -
#pragma mark Share Item Loading Convenience Methods

+ (id)shareItem:(SHKItem *)i
{
	//[SHK pushOnFavorites:[self sharerId] forType:i.shareType];
	
	// Create controller and set share options
	SHKSharer *controller = [[self alloc] init];
	controller.item = i;
	
	// share and/or show UI
	[controller share];
	
	return [controller autorelease];
}

+ (id)shareURL:(NSURL *)url
{
	return [self shareURL:url title:nil];
}

+ (id)shareURL:(NSURL *)url title:(NSString *)title
{
	// Create controller and set share options
	SHKSharer *controller = [[self alloc] init];
	controller.item.shareType = SHKShareTypeURL;
	controller.item.URL = url;
	controller.item.title = title;

	// share and/or show UI
	[controller share];

	return [controller autorelease];
}

+ (id)shareImage:(UIImage *)image title:(NSString *)title
{
	// Create controller and set share options
	SHKSharer *controller = [[self alloc] init];
	controller.item.shareType = SHKShareTypeImage;
	controller.item.image = image;
	controller.item.title = title;
	
	// share and/or show UI
	[controller share];
	
	return [controller autorelease];
}

+ (id)shareText:(NSString *)text
{
	// Create controller and set share options
	SHKSharer *controller = [[self alloc] init];
	controller.item.shareType = SHKShareTypeText;
	controller.item.text = text;
	
	// share and/or show UI
	[controller share];
	
	return [controller autorelease];
}

+ (id)shareFile:(NSData *)file filename:(NSString *)filename mimeType:(NSString *)mimeType title:(NSString *)title
{
	// Create controller and set share options
	SHKSharer *controller = [[self alloc] init];
	controller.item.shareType = SHKShareTypeFile;
	controller.item.data = file;
	controller.item.filename = filename;
	controller.item.mimeType = mimeType;
	controller.item.title = title;
	
	// share and/or show UI
	[controller share];
	
	return [controller autorelease];
}


#pragma mark -
#pragma mark Commit Share

- (void)share
{
	// isAuthorized - If service requires login and details have not been saved, present login dialog	
	if (![self authorize])
		self.pendingAction = SHKPendingShare;
	
	// A. First check if auto share is set	
	// B. If it is, try to send
	// If either A or B fail, display the UI
	else if (![self shouldAutoShare])// || ![self tryToSend])
		[self show];
}


#pragma mark -
#pragma mark Authentication
+ (BOOL)isAuthorized
{
    SHKSharer *controller = [[self alloc] init];
    BOOL isAuth=[controller isAuthorized];
    [controller release];
    return isAuth;
}

- (BOOL)isAuthorized
{	
	return NO;
}

- (BOOL)authorize
{
	if ([self isAuthorized])
		return YES;
	
	else 
		[self promptAuthorization];
	
	return NO;
}

- (void)promptAuthorization
{
	if ([[self class] shareRequiresInternetConnection] && ![SHK connected])
	{
		if (!quiet)
		{
			[[[[UIAlertView alloc] initWithTitle:SHKLocalizedString(@"Offline")
										 message:SHKLocalizedString(@"You must be online to login to %@", [self sharerTitle])
										delegate:nil
							   cancelButtonTitle:SHKLocalizedString(@"Close")
							   otherButtonTitles:nil] autorelease] show];
		}
		return;
	}
}

- (void)setShouldAutoShare:(BOOL)b
{
	return [[NSUserDefaults standardUserDefaults] setBool:b forKey:[NSString stringWithFormat:@"%@_shouldAutoShare", [self sharerId]]];
}

#pragma mark Authorization Form

-(void)logout
{
    
}

+ (void)logout
{

}

+ (void)authorize
{	
	SHKSharer *controller = [[self alloc] init];
	[controller authorize];
	[controller release];	
}


#pragma mark -
#pragma mark UI Implementation

- (void)show
{
		[self tryToSend];
}

#pragma mark -
#pragma mark API Implementation

- (BOOL)validateItem
{
	switch (item.shareType) 
	{
		case SHKShareTypeURL:
			return (item.URL != nil);
			break;			
			
		case SHKShareTypeImage:
			return (item.image != nil);
			break;			
			
		case SHKShareTypeText:
			return (item.text != nil);
			break;
			
		case SHKShareTypeFile:
			return (item.data != nil);
			break;
        default:
            break;
	}
	
	return NO;
}

- (BOOL)tryToSend
{
	if (![[self class] shareRequiresInternetConnection] || [SHK connected])
		return [self send];
	
	else if (!quiet)
	{
		[[[[UIAlertView alloc] initWithTitle:SHKLocalizedString(@"离线")
									 message:SHKLocalizedString(@"必须在线来获取 %@ 授权", [self sharerTitle])
									delegate:nil
						   cancelButtonTitle:SHKLocalizedString(@"返回")
						   otherButtonTitles:nil] autorelease] show];
		
		return YES;
	}
	
	
	return NO;
}

- (BOOL)send
{	
	// Does not actually send anything.
	// Your subclass should implement the sending logic.
	// There is no reason to call [super send] in your subclass
	
	// You should never call [XXX send] directly, you should use [XXX tryToSend].  TryToSend will perform an online check before trying to send.
	return NO;
}

#pragma mark -
#pragma mark Default UI Updating

// These are used if you do not provide your own custom UI and delegate


- (void)sharerStartedSending:(SHKSharer *)sharer
{
	if (!quiet)
		[[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(@"正在分享到 %@", [[self class] sharerTitle])];
}

- (void)sharerFinishedSending:(SHKSharer *)sharer
{
	if (!quiet)
		[[SHKActivityIndicator currentIndicator] displayCompleted:SHKLocalizedString(@"分享成功")];
     [[NSNotificationCenter defaultCenter] postNotificationName:SHARE_SUCCESS_NOTIFICATION object:nil userInfo:nil];
}

- (void)sharer:(SHKSharer *)sharer failedWithError:(NSError *)error shouldRelogin:(BOOL)shouldRelogin
{
	if (!quiet)
	{
		[[SHKActivityIndicator currentIndicator] hide];
		
		[[[[UIAlertView alloc] initWithTitle:SHKLocalizedString(@"Error")
									 message:SHKLocalizedString(@"There was an error while sharing")
									delegate:nil
						   cancelButtonTitle:SHKLocalizedString(@"Close")
						   otherButtonTitles:nil] autorelease] show];
		
		if (shouldRelogin)
			[self promptAuthorization];
	}
}

- (void)sharerCancelledSending:(SHKSharer *)sharer
{
	
}

#pragma mark -
#pragma mark Pending Actions

- (void)tryPendingAction
{
	switch (pendingAction) 
	{
		case SHKPendingShare:
			[self share];
			break;
        default:
            break;
	}
}



#pragma mark -

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return (interfaceOrientation==UIInterfaceOrientationPortrait);
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	// Remove the SHK view wrapper from the window
	[[SHK currentHelper] viewWasDismissed];
}


#pragma mark -
#pragma mark Delegate Notifications

- (void)sendDidStart
{		
	if ([shareDelegate respondsToSelector:@selector(sharerStartedSending:)])
		[shareDelegate performSelector:@selector(sharerStartedSending:) withObject:self];	
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"SHKSendDidStartNotification" object:self];
}

- (void)sendDidFinish
{	
	if ([shareDelegate respondsToSelector:@selector(sharerFinishedSending:)])
		[shareDelegate performSelector:@selector(sharerFinishedSending:) withObject:self];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"SHKSendDidFinish" object:self];
}

- (void)sendDidFailShouldRelogin
{
	[self sendDidFailWithError:[SHK error:SHKLocalizedString(@"Could not authenticate you. Please relogin.")] shouldRelogin:YES];
}

- (void)sendDidFailWithError:(NSError *)error
{
	[self sendDidFailWithError:error shouldRelogin:NO];	
}

- (void)sendDidFailWithError:(NSError *)error shouldRelogin:(BOOL)shouldRelogin
{
	self.lastError = error;
		
	if ([shareDelegate respondsToSelector:@selector(sharer:failedWithError:shouldRelogin:)])
		[(SHKSharer *)shareDelegate sharer:self failedWithError:error shouldRelogin:shouldRelogin];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"SHKSendDidFailWithError" object:self];
}

- (void)sendDidCancel
{
	if ([shareDelegate respondsToSelector:@selector(sharerCancelledSending:)])
		[shareDelegate performSelector:@selector(sharerCancelledSending:) withObject:self];	
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"SHKSendDidCancel" object:self];
}


@end

//
//  SHKSina.m
//  ShareKit
//
//  Created by liulin jiang on 12-5-14.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "SHKSina.h"
#import "JSON.h"
#import "SHKItem.h"
#import "Reachability.h"
#import "TSHeader.h"

@implementation SHKSina

- (id)init
{
	if ((self = [super init]))
	{		
        WBEngine *engine = [[WBEngine alloc] initWithAppKey:kSINAWEIBOCONSUMERKEY appSecret:kSINAWEIBOCONSUMERSECRET];
        //[engine setRootViewController:self];
        [engine setDelegate:self];
        [engine setRedirectURI:@"http://"];
        [engine setIsUserExclusive:NO];
        _sinaEngine = [engine retain];
        [engine release];
	}	
	return self;
}

-(void)dealloc
{
    [_sinaEngine release];
    [super dealloc];
}

#pragma mark -
#pragma mark Configuration : Service Defination

+ (NSString *)sharerTitle
{
	return @"新浪微博";
}

- (NSString *)sharerTitle
{
	return @"新浪微博";
}

+ (BOOL)canShareURL
{
	return YES;
}

+ (BOOL)canShareImage
{
	return YES;
}

+ (BOOL)canShareText
{
	return YES;
}

#pragma mark -
#pragma mark Configuration : Dynamic Enable

- (BOOL)shouldAutoShare
{
	return NO;
}

#pragma mark -
#pragma mark Authorization

- (BOOL)isAuthorized
{		
	return ([_sinaEngine isLoggedIn] && ![_sinaEngine isAuthorizeExpired]);
}

- (void)promptAuthorization
{		
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
    {
        [super promptAuthorization];
        return;
    }
	[_sinaEngine logIn];
}

-(void)logout
{
    if ([self isAuthorized]) 
    {
        [_sinaEngine logOut];
        [[SHKActivityIndicator currentIndicator] displayCompleted:SHKLocalizedString(@"Logout from %@", [self sharerTitle])];
    }
}

+ (void)logout
{
    SHKSina *_engine=[[SHKSina alloc] init];
    [_engine logout];
    [_engine release];
}

#pragma mark -
#pragma mark Share API Methods

-(BOOL)validate
{
    BOOL b=[self validateItem];
    if (b&&item.shareType == SHKShareTypeText) 
    {
        NSString *status=[item text];
        return status != nil && status.length > 0;// && status.length <= 140;
    }
    return b;
}

- (BOOL)send
{		
    if (![self validate])
    {
        //[self sendDidFailWithError:[NSError errorWithDomain:@"Sina Weibo" code:2 userInfo:[NSDictionary dictionaryWithObject:@"Content format error" forKey:NSLocalizedDescriptionKey]]];
        return NO;
    }
    NSString *status=[item text];
    if (!status)
    {
        item.text=@"";
    }
    [_sinaEngine sendWeiBoWithText:item.text image:[item image]]; 

    // Notify delegate
    [self sendDidStart];	
    
    return YES;
}

- (void)dismissModalViewControllerAnimated:(BOOL)animated
{
    [super dismissModalViewControllerAnimated:animated];
}

#pragma mark - WBEngineDelegate
- (void)engineAlreadyLoggedIn:(WBEngine *)engine
{
    TRACE(@"");
}

// Log in successfully.
- (void)engineDidLogIn:(WBEngine *)engine
{
    TRACE(@"");
    //注册通知，确保注册成功后reload view
  //  [[NSNotificationCenter defaultCenter] postNotificationName:WEIBO_NOTIFICATION  object:nil userInfo:nil];
    [self send];
}

// Failed to log in.
// Possible reasons are:
// 1) Either username or password is wrong;
// 2) Your app has not been authorized by Sina yet.
- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
{
    TRACE(@"%@",error);
}

// Log out successfully.
- (void)engineDidLogOut:(WBEngine *)engine
{
    TRACE(@"");
    [_sinaEngine release];
    _sinaEngine = nil;
}

// When you use the WBEngine's request methods,
// you may receive the following four callbacks.
- (void)engineNotAuthorized:(WBEngine *)engine
{
    TRACE(@"");
}

- (void)engineAuthorizeExpired:(WBEngine *)engine
{
    TRACE(@"");
}

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
{
    TRACE(@"%@",error);
     [self sendDidFailWithError:nil];
}

- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
    TRACE(@"%@",result);
    [self sendDidFinish];
}
@end

//
//  SHKTencentWeibo.m
//  ShareKit
//
//  Created by icyleaf on 11-04-02.
//  Copyright 2011 icyleaf.com. All rights reserved.

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

#import "SHKTencent.h"
#import "NSString+URLEncoding.h"
#import "JSON.h"
#import "Reachability.h"
#import "TSHeader.h"

@implementation SHKTencent

#pragma -
#pragma Override base functions.
- (id)init
{
	if ((self = [super init]))
	{		
        // OAuth
		RenRenQQEngine *engine = [[RenRenQQEngine alloc] initWithAppKey:kTENCENTWEIBOCONSUMERKEY appSecret:kTENCENTWEIBOCONSUMERSECRET andRedirectURI:kTencentWeiboCallbackUrl];
        //[engine setRootViewController:self];
        [engine setDelegate:self];
        [engine setIsUserExclusive:NO];
        _qqEngine = [engine retain];
        [engine release];
    }	
	return self;
}

-(void)dealloc
{
    [_qqEngine release];
    [super dealloc];
}

#pragma mark -
#pragma mark Configuration : Service Defination

+ (NSString *)sharerTitle
{
	return @"腾讯微博";
}

- (NSString *)sharerTitle
{
	return @"腾讯微博";
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
	return ([_qqEngine isLoggedIn] &&![_qqEngine isAuthorizeExpired]);
}

- (void)promptAuthorization
{		
	//[super promptAuthorization]; // OAuth process	
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
    {
        [super promptAuthorization];
        return;
    }
	[_qqEngine logIn];
}

-(void)logout
{
    if ([self isAuthorized]) 
    {
        [_qqEngine logOut];
        [[SHKActivityIndicator currentIndicator] displayCompleted:SHKLocalizedString(@"Logout from %@", [self sharerTitle])];
    }
}

+ (void)logout
{
    SHKTencent *_engine=[[SHKTencent alloc] init];
    [_engine logout];
    [_engine release];
}
/*
 result:oauth_token=5ed2386f64c840c1b2d45175943669f9&oauth_token_secret=c26e0d0a1ccc9dde87fa8b762a6abc9b&name=jiangll4970
 */
- (void)tokenAccess:(BOOL)refresh
{
    
    
}

#pragma mark -
#pragma mark Share API Methods

- (BOOL)validate
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
		//[self show];
	}
	else
	{	
        NSString *status=[item text];
        if (!status)
        {
            item.text=@"分享图片";
        }
        [_qqEngine sendWeiBoWithText:item.text image:[item image]];
		// Notify delegate
		[self sendDidStart];	
		
		return YES;
	}
	
	return NO;
}

#pragma mark - WBEngineDelegate
- (void)qqengineAlreadyLoggedIn:(RenRenQQEngine *)engine
{
    TRACE(@"");
}

// Log in successfully.
- (void)qqengineDidLogIn:(RenRenQQEngine *)engine
{
    TRACE(@"");
    //注册通知，确保注册成功后reload view
    [[NSNotificationCenter defaultCenter] postNotificationName:WEIBO_NOTIFICATION  object:nil userInfo:nil];
    [self send];
}

// Failed to log in.
// Possible reasons are:
// 1) Either username or password is wrong;
// 2) Your app has not been authorized by Sina yet.
- (void)qqengine:(RenRenQQEngine *)engine didFailToLogInWithError:(NSError *)error
{
    TRACE(@"%@",error);
}

// Log out successfully.
- (void)qqengineDidLogOut:(RenRenQQEngine *)engine
{
    TRACE(@"");
    [_qqEngine release];
    _qqEngine = nil;
}

// When you use the WBEngine's request methods,
// you may receive the following four callbacks.
- (void)qqengineNotAuthorized:(RenRenQQEngine *)engine
{
    TRACE(@"");
}

- (void)qqengineAuthorizeExpired:(RenRenQQEngine *)engine
{
    TRACE(@"");
}

- (void)qqengine:(RenRenQQEngine *)engine requestDidFailWithError:(NSError *)error
{
    TRACE(@"%@",error);
    [self sendDidFailWithError:nil];
}

- (void)qqengine:(RenRenQQEngine *)engine requestDidSucceedWithResult:(id)result
{
    TRACE(@"%@",result);
    [self sendDidFinish];
}

@end

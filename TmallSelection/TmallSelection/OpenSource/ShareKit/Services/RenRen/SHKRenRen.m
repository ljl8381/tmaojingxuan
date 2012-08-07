//
//  SHKFacebook.m
//  ShareKit
//
//  Created by Nathan Weiner on 6/18/10.

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

#import "SHKRenRen.h"
#import "Reachability.h"
#import "TSHeader.h"

@implementation SHKRenRen

- (id)init
{
	if ((self = [super init]))
	{

    }
    
    return self;
}

- (void)dealloc
{
	[super dealloc];
}

#pragma mark -
#pragma mark Configuration : Service Defination

+ (NSString *)sharerTitle
{
	return @"人人网";
}

- (NSString *)sharerTitle
{
	return @"人人网";
}

+ (BOOL)canShareURL
{
	return NO;
}

+ (BOOL)canShareText
{
	return YES;
}

+ (BOOL)canShareImage
{
	return YES;
}

+ (BOOL)canShareOffline
{
	return NO; // TODO - would love to make this work
}

#pragma mark -
#pragma mark Configuration : Dynamic Enable

- (BOOL)shouldAutoShare
{
	return NO;
}

#pragma mark -
#pragma mark Authentication

- (BOOL)isAuthorized
{
    return [[Renren sharedRenren] isSessionValid];
}

- (void)promptAuthorization
{
   if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
    {
        [super promptAuthorization];
        return;
    }
    [[Renren sharedRenren] authorizationInNavigationWithPermisson:nil andDelegate:self]; 
}

-(void)logout
{
    if ([SHKRenRen isAuthorized]) 
    {
        [[Renren sharedRenren] logout:self];
        
        [[SHKActivityIndicator currentIndicator] displayCompleted:SHKLocalizedString(@"Logout from %@", [self sharerTitle])];
    }
}

+ (void)logout
{
    if ([SHKRenRen isAuthorized]) 
    {
        [[Renren sharedRenren] logout:nil];
        
        [[SHKActivityIndicator currentIndicator] displayCompleted:SHKLocalizedString(@"Logout from %@", [self sharerTitle])];
    }
}

#pragma mark - RenrenDelegate
/**
 * 接口请求成功，第三方开发者实现这个方法
 * @param renren 传回代理服务器接口请求的Renren类型对象。
 * @param response 传回接口请求的响应。
 */
- (void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse*)response
{
    TRACE(@"%@",response.param);
    [self sendDidFinish];
}

/**
 * 接口请求失败，第三方开发者实现这个方法
 * @param renren 传回代理服务器接口请求的Renren类型对象。
 * @param response 传回接口请求的错误对象。
 */
- (void)renren:(Renren *)renren requestFailWithError:(ROError*)error
{
    TRACE(@"%@",error);
    [self sendDidFailWithError:error];
}

/**
 * renren取消Dialog时调用，第三方开发者实现这个方法
 * @param renren 传回代理授权登录接口请求的Renren类型对象。
 */
- (void)renrenDialogDidCancel:(Renren *)renren
{
    TRACE(@"");
}
/**
 * 授权登录成功时被调用，第三方开发者实现这个方法
 * @param renren 传回代理授权登录接口请求的Renren类型对象。
 */
- (void)renrenDidLogin:(Renren *)renren
{
    TRACE(@"");
    //注册通知，确保注册成功后reload view
    [[NSNotificationCenter defaultCenter] postNotificationName:WEIBO_NOTIFICATION  object:nil userInfo:nil];
    [self send];
}

/**
 * 用户登出成功后被调用 第三方开发者实现这个方法
 * @param renren 传回代理登出接口请求的Renren类型对象。
 */
- (void)renrenDidLogout:(Renren *)renren
{
    TRACE(@"");
}

/**
 * 授权登录失败时被调用，第三方开发者实现这个方法
 * @param renren 传回代理授权登录接口请求的Renren类型对象。
 */
- (void)renren:(Renren *)renren loginFailWithError:(ROError*)error;
{
    TRACE(@"%@",error);
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

- (void)sendStatus
{
    if(![[Renren sharedRenren] isSessionValid]){
        [[Renren sharedRenren] authorizationInNavigationWithPermisson:nil andDelegate:self];   
    }
    else
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"status.set", @"method",
                                       [item text], @"status", nil];
        [[Renren sharedRenren] requestWithParams:params andDelegate:self];
    }
}

- (void)sendImage
{
    if(![[Renren sharedRenren] isSessionValid]){
        [[Renren sharedRenren] authorizationInNavigationWithPermisson:nil andDelegate:self];   
    }
    else
    {
        /*
        NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"photos.upload", @"method",
                                     UIImagePNGRepresentation(item.image), @"upload",
                                     @"0", @"aid",
                                     [item text], @"caption", nil];
        [[Renren sharedRenren] requestWithParams:params andDelegate:self];
         */
        [[Renren sharedRenren] publishPhotoSimplyWithImage:item.image caption:item.text];
    }
}

- (BOOL)send
{	
	if (![self validate])
    {
		//[self show];
	}
	else
	{	
		if (item.shareType == SHKShareTypeImage) {
			[self sendImage];
		} else {
			[self sendStatus];
            [self sendDidStart];	
		}
		
		return YES;
	}
	
	return NO;
}

@end

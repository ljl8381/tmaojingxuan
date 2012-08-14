//
//  RenRenQQEngine.h
//  WeiboDemo
//
//  Created by liulin jiang on 12-7-12.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "RenRenOAuthViewController.h"

@class RenRenQQEngine;

@protocol RenRenQQEngineDelegate <NSObject>

@optional

- (void)qqengineAlreadyLoggedIn:(RenRenQQEngine *)engine;

// Log in successfully.
- (void)qqengineDidLogIn:(RenRenQQEngine *)engine;

// Failed to log in.
// Possible reasons are:
// 1) Either username or password is wrong;
// 2) Your app has not been authorized by Sina yet.
- (void)qqengine:(RenRenQQEngine *)engine didFailToLogInWithError:(NSError *)error;

// Log out successfully.
- (void)qqengineDidLogOut:(RenRenQQEngine *)engine;

// When you use the WBEngine's request methods,
// you may receive the following four callbacks.
- (void)qqengineNotAuthorized:(RenRenQQEngine *)engine;
- (void)qqengineAuthorizeExpired:(RenRenQQEngine *)engine;

- (void)qqengine:(RenRenQQEngine *)engine requestDidFailWithError:(NSError *)error;
- (void)qqengine:(RenRenQQEngine *)engine requestDidSucceedWithResult:(id)result;

@end
@interface RenRenQQEngine : NSObject<RenRenOAuthViewControllerDelegate>
{
    UIViewController *_rootVC;
    NSMutableDictionary *_oauthData;
    
    NSString        *appKey;
    NSString        *appSecret;
    
    NSString        *userID;
    NSString        *accessToken;
    NSTimeInterval  expireTime;
    NSTimeInterval  refreshTokenExpireTime;
    NSString        *refreshToken;
    NSString        *code;
    NSString        *openID;
    NSString        *openKey;
    
    NSString        *redirectURI;
     BOOL           isUserExclusive;
    id<RenRenQQEngineDelegate> delegate;
    
    //UIViewController *rootViewController;
}
@property(nonatomic,assign)UIViewController *rootVC;
@property (nonatomic, retain) NSString *appKey;
@property (nonatomic, retain) NSString *appSecret;
@property (nonatomic, retain) NSString *userID;
@property (nonatomic, retain) NSString *accessToken;
@property (nonatomic, retain) NSString *refreshToken;
@property (nonatomic, retain) NSString *code;
@property (nonatomic, retain) NSString *openID;
@property (nonatomic, retain) NSString *openKey;
@property (nonatomic, assign) NSTimeInterval expireTime;
@property (nonatomic, assign) NSTimeInterval refreshTokenExpireTime;
@property (nonatomic, retain) NSString *redirectURI;
@property (nonatomic, assign) BOOL isUserExclusive;
@property (nonatomic, assign) id<RenRenQQEngineDelegate> delegate;
//@property (nonatomic, assign) UIViewController *rootViewController;

// Initialize an instance with the AppKey and the AppSecret you have for your client.
- (id)initWithAppKey:(NSString *)theAppKey appSecret:(NSString *)theAppSecret andRedirectURI:(NSString *)redirecturi;

// Log in using OAuth Web authorization.
// If succeed, engineDidLogIn will be called.
- (void)logIn;

// Log out.
// If succeed, engineDidLogOut will be called.
- (void)logOut;

// Check if user has logged in, or the authorization is expired.
- (BOOL)isLoggedIn;

- (BOOL)isAuthorizeExpired;

//刷新令牌是否过期
- (BOOL)isRefreshTokenExpired;
/*
// @methodName: The interface you are trying to visit, exp, "statuses/public_timeline.json" for the newest timeline.
// See 
// http://open.weibo.com/wiki/API%E6%96%87%E6%A1%A3_V2
// for more details.
// @httpMethod: "GET" or "POST".
// @params: A dictionary that contains your request parameters.
// @postDataType: "GET" for kWBRequestPostDataTypeNone, "POST" for kWBRequestPostDataTypeNormal or kWBRequestPostDataTypeMultipart.
// @httpHeaderFields: A dictionary that contains HTTP header information.
- (void)loadRequestWithMethodName:(NSString *)methodName
                       httpMethod:(NSString *)httpMethod
                           params:(NSDictionary *)params
                     postDataType:(WBRequestPostDataType)postDataType
                 httpHeaderFields:(NSDictionary *)httpHeaderFields;
*/
// Send a Weibo, to which you can attach an image.
- (void)sendWeiBoWithText:(NSString *)text image:(UIImage *)image;

//-(void)authorize;
- (void)sendStatus:(NSString *)msgSend;

-(void)getAccessTokenFresh:(BOOL)refresh;

+(NSDictionary *)getParamsFromURL:(NSString *)url;
@end
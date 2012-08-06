//
//  RenRenQQEngine.m
//  WeiboDemo
//
//  Created by liulin jiang on 12-7-12.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "RenRenQQEngine.h"
#import "OAMutableURLRequest.h"
#import "OADataFetcher.h"
#import "OAAsynchronousDataFetcher.h"
#import "SFHFKeychainUtils.h"
#import "SHK.h"
#import "SHKTencent.h"

#define kQQURLSchemePrefix              @"TENCENT_"

#define kQQKeychainUserID               @"QQUserID"
#define kQQKeychainAccessToken          @"QQAccessToken"
#define kQQKeychainExpireTime           @"QQExpireTime"
#define kQQKeychainRefreshTokenExpireTime   @"QQRefreshTokenExpireTime"
#define kQQKeychainREFRESHTOKEN         @"QQREFRESHTOKEN"
#define kQQKeychainOPENID               @"QQOPENID"
#define kQQKeychainopenKey              @"QQopenKey"


@interface RenRenQQEngine()
- (NSString *)urlSchemeString;

- (void)saveAuthorizeDataToKeychain;
- (void)readAuthorizeDataFromKeychain;
- (void)deleteAuthorizeDataInKeychain;

@end

@implementation RenRenQQEngine
@synthesize rootVC=_rootVC;
@synthesize appKey;
@synthesize appSecret;
@synthesize userID;
@synthesize accessToken;
@synthesize expireTime;
@synthesize refreshTokenExpireTime;
@synthesize redirectURI;
@synthesize isUserExclusive;
@synthesize delegate;
@synthesize refreshToken;
@synthesize code;
@synthesize openID;
@synthesize openKey;
//@synthesize rootViewController;

#pragma mark - WBEngine Life Circle

- (id)initWithAppKey:(NSString *)theAppKey appSecret:(NSString *)theAppSecret andRedirectURI:(NSString *)redirecturi
{
    if (self = [super init])
    {
        self.appKey = theAppKey;
        self.appSecret = theAppSecret;
        self.redirectURI=redirecturi;
        isUserExclusive = NO;
        
        [self readAuthorizeDataFromKeychain];
    }
    
    return self;
}

- (void)dealloc
{
    if (_oauthData)
    {
        [_oauthData release];
        _oauthData=nil;
    }  
    [appKey release]; appKey = nil;
    [appSecret release]; appSecret = nil;
    
    [userID release]; userID = nil;
    [accessToken release]; accessToken = nil;
    [refreshToken release];refreshToken=nil;
    
    [redirectURI release]; redirectURI = nil;
    [code release]; code = nil;
    [openID release]; openID = nil;
    
    [openKey release]; openKey = nil;
    delegate = nil;
    
    [super dealloc];
}

-(void)getAccessTokenFresh:(BOOL)refresh
{
    NSURL *url=nil;
    if (!refresh)
    {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/access_token?client_id=%@&client_secret=%@&grant_type=%@&code=%@&redirect_uri=%@",kTencentWeiboAuthDomain ,kTENCENTWEIBOCONSUMERKEY,kTENCENTWEIBOCONSUMERSECRET,@"authorization_code",code,redirectURI]];
    }
    else
    {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/access_token?client_id=%@&client_secret=%@&grant_type=%@&refresh_token=%@",kTencentWeiboAuthDomain ,kTENCENTWEIBOCONSUMERKEY,kTENCENTWEIBOCONSUMERSECRET,@"refresh_token",refreshToken]];
    }
    if (url)
    {
        TRACE(@"token access url:%@",url);
        OAMutableURLRequest *oRequest = [[OAMutableURLRequest alloc] initWithURL:url]; // use the default method, HMAC-SHA1
        
        [oRequest setHTTPMethod:@"GET"];
        
        OADataFetcher *fetcher=[[OADataFetcher alloc] init];
        [fetcher fetchDataWithRequest:oRequest delegate:self didFinishSelector:@selector(tokenAccessTicket:didFinishWithData:) didFailSelector:@selector(tokenAccessTicket:didFailWithError:)];
        [fetcher autorelease];
        [oRequest release];
    }
}

+(NSDictionary *)getParamsFromURL:(NSString *)url
{
    if (url&&[url length])
    {
        NSMutableDictionary *queryParams = [NSMutableDictionary dictionaryWithCapacity:3];
        NSArray *vars = [url componentsSeparatedByString:@"&"];
        NSArray *parts;
        for(NSString *var in vars)
        {
            parts = [var componentsSeparatedByString:@"="];
            if (parts.count == 2)
                [queryParams setObject:[parts objectAtIndex:1] forKey:[parts objectAtIndex:0]];
        }
        return queryParams;
    }
    return nil;
}

#pragma mark - WBEngine Private Methods

- (NSString *)urlSchemeString
{
    return [NSString stringWithFormat:@"%@%@", kQQURLSchemePrefix, appKey];
}

- (void)saveAuthorizeDataToKeychain
{
    NSString *serviceName = [self urlSchemeString];
    [SFHFKeychainUtils storeUsername:kQQKeychainUserID andPassword:userID forServiceName:serviceName updateExisting:YES error:nil];
    [SFHFKeychainUtils storeUsername:kQQKeychainAccessToken andPassword:accessToken forServiceName:serviceName updateExisting:YES error:nil];
    [SFHFKeychainUtils storeUsername:kQQKeychainExpireTime andPassword:[NSString stringWithFormat:@"%lf", expireTime] forServiceName:serviceName updateExisting:YES error:nil];
    [SFHFKeychainUtils storeUsername:kQQKeychainRefreshTokenExpireTime andPassword:[NSString stringWithFormat:@"%lf", refreshTokenExpireTime] forServiceName:serviceName updateExisting:YES error:nil];
    [SFHFKeychainUtils storeUsername:kQQKeychainREFRESHTOKEN andPassword:refreshToken forServiceName:serviceName updateExisting:YES error:nil];
}
- (void)readAuthorizeDataFromKeychain
{
    NSString *serviceName = [self urlSchemeString];
    self.userID = [SFHFKeychainUtils getPasswordForUsername:kQQKeychainUserID andServiceName:serviceName error:nil];
    self.accessToken = [SFHFKeychainUtils getPasswordForUsername:kQQKeychainAccessToken andServiceName:serviceName error:nil];
    self.expireTime = [[SFHFKeychainUtils getPasswordForUsername:kQQKeychainExpireTime andServiceName:serviceName error:nil] doubleValue];
    self.refreshTokenExpireTime = [[SFHFKeychainUtils getPasswordForUsername:kQQKeychainRefreshTokenExpireTime andServiceName:serviceName error:nil] doubleValue];
    self.refreshToken = [SFHFKeychainUtils getPasswordForUsername:kQQKeychainREFRESHTOKEN andServiceName:serviceName error:nil];
    self.openID = [SFHFKeychainUtils getPasswordForUsername:kQQKeychainOPENID andServiceName:serviceName error:nil];
    self.openKey = [SFHFKeychainUtils getPasswordForUsername:kQQKeychainopenKey andServiceName:serviceName error:nil];
}

- (void)deleteAuthorizeDataInKeychain
{
    self.userID = nil;
    self.accessToken = nil;
    self.expireTime = 0;
    self.refreshTokenExpireTime=0;
    self.refreshToken=nil;
    self.openID=nil;
    self.openKey=nil;
    
    NSString *serviceName = [self urlSchemeString];
    [SFHFKeychainUtils deleteItemForUsername:kQQKeychainUserID andServiceName:serviceName error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kQQKeychainAccessToken andServiceName:serviceName error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kQQKeychainExpireTime andServiceName:serviceName error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kQQKeychainRefreshTokenExpireTime andServiceName:serviceName error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kQQKeychainREFRESHTOKEN andServiceName:serviceName error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kQQKeychainOPENID andServiceName:serviceName error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kQQKeychainopenKey andServiceName:serviceName error:nil];
}

#pragma mark - WBEngine Public Methods

#pragma mark Authorization

- (void)logIn
{
    if ([self isLoggedIn])
    {
        if (![self isAuthorizeExpired]) 
        {
            if ([delegate respondsToSelector:@selector(qqengineAlreadyLoggedIn:)])
            {
                [delegate qqengineAlreadyLoggedIn:self];
            }
            if (isUserExclusive)
            {
                return;
            }
        }
        else if(![self isRefreshTokenExpired])//刷新令牌有效,使用刷新令牌
        {
            [self getAccessTokenFresh:YES];
            return;
        }
    }
    /*
    if (!_rootVC)
    {
        if ([delegate respondsToSelector:@selector(qqengine:didFailToLogInWithError:)])
        {
            [delegate qqengine:self didFailToLogInWithError:[NSError errorWithDomain:@"参数错误" code:100 userInfo:[NSDictionary dictionaryWithObject:@"没有设置rootViewController" forKey:NSLocalizedDescriptionKey]]];
        }
        return;
    }
     */
    if ([redirectURI length]<=0)
    {
        if ([delegate respondsToSelector:@selector(qqengine:didFailToLogInWithError:)])
        {
            [delegate qqengine:self didFailToLogInWithError:[NSError errorWithDomain:@"参数错误" code:100 userInfo:[NSDictionary dictionaryWithObject:@"没有跳转地址" forKey:NSLocalizedDescriptionKey]]];
        }
        return;
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/authorize?client_id=%@&response_type=%@&redirect_uri=%@",kTencentWeiboAuthDomain ,appKey ,@"code",redirectURI]];
	
    RenRenOAuthViewController *auth = [[RenRenOAuthViewController alloc] initWithURL:url delegate:self];
    auth.navigationItem.title=[SHKTencent sharerTitle];
    [[SHK currentHelper] showViewController:auth];
	//[_rootVC presentModalViewController:auth animated:YES];
	[auth release];
}

- (void)logOut
{
    [self deleteAuthorizeDataInKeychain];
    
    if ([delegate respondsToSelector:@selector(qqengineDidLogOut:)])
    {
        [delegate qqengineDidLogOut:self];
    }
}

- (BOOL)isLoggedIn
{
    TRACE(@"start");
    //    return userID && accessToken && refreshToken;
    return userID && accessToken && (expireTime > 0);
}

- (BOOL)isAuthorizeExpired
{
    TRACE(@"");
    if ([[NSDate date] timeIntervalSince1970] > expireTime)
    {
        // force to log out
        //[self deleteAuthorizeDataInKeychain];
        return YES;
    }
    return NO;
}

- (BOOL)isRefreshTokenExpired
{
    TRACE(@"");
    if ([[NSDate date] timeIntervalSince1970] > refreshTokenExpireTime)
    {
        // force to log out
        //[self deleteAuthorizeDataInKeychain];
        return YES;
    }
    return NO;
}

#pragma mark - access token
- (void)tokenAccessTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data 
{
	if (ticket.didSucceed) 
	{
		NSString *responseBody = [[NSString alloc] initWithData:data
													   encoding:NSUTF8StringEncoding];
        TRACE(@"####response:%@",responseBody);
        NSDictionary *data=[RenRenQQEngine getParamsFromURL:responseBody];
		//self.accessToken = [[[OAToken alloc] initWithHTTPResponseBody:responseBody] autorelease];
		[responseBody release];
        
        self.accessToken = [data objectForKey:@"access_token"];
        self.userID = [data objectForKey:@"name"];
        self.expireTime = [[NSDate date] timeIntervalSince1970] + [[data objectForKey:@"expires_in"] intValue];
        //refresh token 3个月过期
        self.refreshTokenExpireTime = [[NSDate date] timeIntervalSince1970] + 3*29*24*60*60;
        self.refreshToken = [data objectForKey:@"refresh_token"];
        
        [self saveAuthorizeDataToKeychain];
        
        if ([delegate respondsToSelector:@selector(qqengineDidLogIn:)])
        {
            [delegate qqengineDidLogIn:self];
        }
	}
	else
    {
        if ([delegate respondsToSelector:@selector(qqengine:didFailToLogInWithError:)])
        {
            [delegate qqengine:self didFailToLogInWithError:nil];
        }
    }
}

- (void)tokenAccessTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error
{
	if ([delegate respondsToSelector:@selector(qqengine:didFailToLogInWithError:)])
    {
        [delegate qqengine:self didFailToLogInWithError:error];
    }
}

#pragma mark - RenRenOAuthViewControllerDelegate

- (void)tokenAuthorizeView:(RenRenOAuthViewController *)authView didFinishWithSuccess:(BOOL)success queryParams:(NSDictionary *)queryParams error:(NSError *)error
{
    [authView dismissModalViewControllerAnimated:YES];
    if (success&&queryParams)
    {
        NSString *_code=[queryParams objectForKey:@"code"];
        NSString *_openid=[queryParams objectForKey:@"openid"]; 
        NSString *_openkey=[queryParams objectForKey:@"openkey"];
        if ([_code length])
        {
            NSString *serviceName = [self urlSchemeString];
            self.openID=_openid;
            self.openKey=_openkey;
            self.code=_code;
            [SFHFKeychainUtils storeUsername:kQQKeychainOPENID andPassword:openID forServiceName:serviceName updateExisting:YES error:nil];
            [SFHFKeychainUtils storeUsername:kQQKeychainopenKey andPassword:openKey forServiceName:serviceName updateExisting:YES error:nil];
            [self getAccessTokenFresh:NO];
        }
    }
    else
    {
        if ([delegate respondsToSelector:@selector(qqengine:didFailToLogInWithError:)])
        {
            [delegate qqengine:self didFailToLogInWithError:nil];
        }   
    }
}

- (void)tokenAuthorizeCancelledView:(RenRenOAuthViewController *)authView
{
    if ([delegate respondsToSelector:@selector(qqengine:didFailToLogInWithError:)])
    {
        [delegate qqengine:self didFailToLogInWithError:nil];
    }
}

- (NSString *)authorizeCallbackURL
{
    return redirectURI;
}

- (void)sendWeiBoWithText:(NSString *)text image:(UIImage *)image
{
    if ([text length]<=0)
    {
        text=@"分享";
    }
    if (image)
    {
        OAMutableURLRequest *oRequest = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/t/add_pic", kTencentWeiboAPIDomain]] andAppSecret:appSecret];
        
        [oRequest setHTTPMethod:@"POST"];
        [oRequest addOAuthParam:[OARequestParameter requestParameterWithName:@"oauth_consumer_key" value:appKey]];
        [oRequest addOAuthParam:[OARequestParameter requestParameterWithName:@"access_token" value:accessToken]];
        [oRequest addOAuthParam:[OARequestParameter requestParameterWithName:@"openid" value:openID]];
        [oRequest addOAuthParam:[OARequestParameter requestParameterWithName:@"clientip" value:@"10.248.50.61"]];
        [oRequest addOAuthParam:[OARequestParameter requestParameterWithName:@"oauth_version" value:@"2.a"]];
        [oRequest addOAuthParam:[OARequestParameter requestParameterWithName:@"scope" value:@"all"]];
        
        [oRequest addOAuthParam:[OARequestParameter requestParameterWithName:@"content" value:text]];
        [oRequest addOAuthParam:[OARequestParameter requestParameterWithName:@"format" value:@"json"]];
        [oRequest addOAuthParam:[OARequestParameter requestParameterWithName:@"jing" value:@"0.0"]];
        [oRequest addOAuthParam:[OARequestParameter requestParameterWithName:@"wei" value:@"0.0"]];
       
        oRequest.fileData=UIImageJPEGRepresentation(image, .8);
        OAAsynchronousDataFetcher *fetcher = [OAAsynchronousDataFetcher asynchronousFetcherWithRequest:oRequest
                                                                                              delegate:self
                                                                                     didFinishSelector:@selector(sendStatusTicket:didFinishWithData:)
                                                                                       didFailSelector:@selector(sendStatusTicket:didFailWithError:)];	
        
        [fetcher start];
        [oRequest release];
    }
    else
    {
        [self sendStatus:text];
    }
}

- (void)sendStatus:(NSString *)msgSend
{	
    
    OAMutableURLRequest *oRequest = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/t/add", kTencentWeiboAPIDomain]] andAppSecret:appSecret];
    
	[oRequest setHTTPMethod:@"POST"];
    [oRequest addOAuthParam:[OARequestParameter requestParameterWithName:@"oauth_consumer_key" value:appKey]];
    [oRequest addOAuthParam:[OARequestParameter requestParameterWithName:@"access_token" value:accessToken]];
    [oRequest addOAuthParam:[OARequestParameter requestParameterWithName:@"openid" value:openID]];
    [oRequest addOAuthParam:[OARequestParameter requestParameterWithName:@"clientip" value:@"10.248.50.61"]];
    [oRequest addOAuthParam:[OARequestParameter requestParameterWithName:@"oauth_version" value:@"2.a"]];
    [oRequest addOAuthParam:[OARequestParameter requestParameterWithName:@"scope" value:@"all"]];
    
    [oRequest addOAuthParam:[OARequestParameter requestParameterWithName:@"content" value:msgSend]];
    [oRequest addOAuthParam:[OARequestParameter requestParameterWithName:@"format" value:@"json"]];
    [oRequest addOAuthParam:[OARequestParameter requestParameterWithName:@"jing" value:@"0.0"]];
    [oRequest addOAuthParam:[OARequestParameter requestParameterWithName:@"wei" value:@"0.0"]];
    
	OAAsynchronousDataFetcher *fetcher = [OAAsynchronousDataFetcher asynchronousFetcherWithRequest:oRequest
                                                                                          delegate:self
                                                                                 didFinishSelector:@selector(sendStatusTicket:didFinishWithData:)
                                                                                   didFailSelector:@selector(sendStatusTicket:didFailWithError:)];	
    
	[fetcher start];
	[oRequest release];
}

 
- (void)sendStatusTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data 
{	
    NSString *receivedData=[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    TRACE(@"%@",receivedData);
    if ([delegate respondsToSelector:@selector(qqengine:requestDidSucceedWithResult:)])
    {
        [delegate qqengine:self requestDidSucceedWithResult:receivedData];
    }
}

- (void)sendStatusTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error
{
    if ([delegate respondsToSelector:@selector(qqengine:requestDidFailWithError:)])
    {
        [delegate qqengine:self requestDidFailWithError:error];
    }
}

@end

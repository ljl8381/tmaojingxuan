//
//  FGHttpObject.m
//  FreeGames
//
//  Created by ljl on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

//#import "FGHttpObject.h"
#import "TSHttpHeader.h"
#import "CCString.h"
#import "FGPublicUUID.h"

@interface TSHttpObject (Private)

- (void)requestDidStart:(ASIFormDataRequest*)request;
- (void)requestDidFinished:(ASIFormDataRequest*)request;
- (void)requestDidFailed:(ASIFormDataRequest*)request;

- (void)imageDownloadDidFinished:(ASIFormDataRequest*)request;
- (void)imageDownloadDidFailed:(ASIFormDataRequest*)request;

@end

@implementation TSHttpObject

@synthesize gDelegate = _gDelegate;

- (id)init
{
    self = [super init];
    if (self)
    {
        if(_requestQueue == nil)
        {
            _requestQueue = [[ASINetworkQueue alloc] init];
            [_requestQueue setMaxConcurrentOperationCount:MAX_OPERATION_COUNT];
            [_requestQueue reset];
            [_requestQueue setDelegate:self];
            [_requestQueue setShouldCancelAllRequestsOnFailure:NO];
            [_requestQueue setRequestDidFinishSelector:@selector(requestDidFinished:)];
            [_requestQueue setRequestDidFailSelector:@selector(requestDidFailed:)];
            [_requestQueue setRequestDidStartSelector:@selector(requestDidStart:)];
            [_requestQueue go];
            
        }
        
        if (_imageDownloadQueue == nil)
        {
            _imageDownloadQueue = [[ASINetworkQueue alloc] init];
            [_imageDownloadQueue setMaxConcurrentOperationCount:MAX_OPERATION_COUNT];
            [_imageDownloadQueue reset];
            [_imageDownloadQueue setDelegate:self];
            [_imageDownloadQueue setShouldCancelAllRequestsOnFailure:NO];
            [_imageDownloadQueue setRequestDidFinishSelector:@selector(imageDownloadDidFinished:)];
            [_imageDownloadQueue setRequestDidFailSelector:@selector(imageDownloadDidFailed:)];
            //[_imageDownloadQueue setRequestDidStartSelector:@selector(requestDidStart:)];
            [_requestQueue go];
        }
         _cookieUUID = [[NSString alloc]initWithFormat:@"%@", [FGPublicUUID deviceUniqueString] ];
    }
   
    return self;
    
}

- (void)dealloc
{
    [_requestQueue release];
    [_imageDownloadQueue release];
    [_cookieUUID release];
	[super dealloc];
}


#pragma mark - 普通json下载队列返回
- (void)requestDidStart:(ASIFormDataRequest*)request
{
    TRACE(@"启动HTTP请求：%@",request.requestID);
}

- (void)requestDidFinished:(ASIFormDataRequest*) request
{
    NSString*url=[[request originalURL] absoluteString];
    NSError *error = [request error];
    TRACE(@"普通HTTP请求完成：%@,userInfo:%@", request.requestID,request.userInfo);
    
	if (!error) 
	{
		request_Type requestType = -1;
        
        for( int i = 0 ; i < sizeof(request_Array)/sizeof(request_Array[0]); i++ )
        {
            if( [url has_substring:request_Array[i].requestUrl] == YES )
            {
                requestType = i;			
                break;
            }
        }

        if (requestType >= 0)
        {
            id responseData = [request responseString];
            id jsonData = [responseData JSONValue];
            TRACE(@"\n responseData: %@\n jsonData :%@",responseData, jsonData);
            [self receiveDataWithRequestType:requestType andData:jsonData];
        }
        
	}
	else
	{
	    TRACE(@"Error: %@",error);	
	}
}

- (void)requestDidFailed:(ASIFormDataRequest*) request
{	
    NSString*url=[[request originalURL] absoluteString];
    NSError *error = [request error];
    TRACE(@"普通HTTP请求失败：%@,url:%@", error,url);
    
    request_Type requestType = -1;
    
    for( int i = 0 ; i < sizeof(request_Array)/sizeof(request_Array[0]); i++ )
    {
        if( [url has_substring:request_Array[i].requestUrl] == YES )
        {
            requestType = i;			
            break;
        }
    }
    
    [self receiveDataWithRequestType:requestType andData:nil];
}


#pragma mark - 图下载队列返回
- (void)imageDownloadDidFinished:(ASIFormDataRequest*)request
{
    //NSString*url=[[request originalURL] absoluteString];
    NSError *error = [request error];
    
    TRACE(@"图下载HTTP请求完成：%@,userInfo:%@", request.requestID,request.userInfo);
    
	if (!error) 
	{
		NSData *imgData = [request responseData];
        
        NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:request.userInfo,@"imgInfo",imgData,@"imgData", nil];
        
        if (_gDelegate)
        {
            [_gDelegate receiveDownloadImageInfo:infoDic];
        }
        
	}
	else
	{
	    TRACE(@"Error: %@",error);	
	}
}

- (void)imageDownloadDidFailed:(ASIFormDataRequest*)request
{	
    NSString*url=[[request originalURL] absoluteString];
    NSError *error = [request error];
    TRACE(@"图下载HTTP请求失败：%@,url:%@", error,url);
    
    NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:request.userInfo,@"imgInfo", nil];
    
    if (_gDelegate)
    {
        [_gDelegate receiveDownloadImageInfo:infoDic];
    }
    
}

#pragma mark -
#pragma mark add Request
- (void)AddHttpGetRequest:(NSDictionary *)infoData
{
    NSString* url = [infoData objectForKey:@"url"];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
	[request setRequestMethod:@"GET"];
	[request setTimeOutSeconds:MAX_TIMEOUT_SECONDS];
    
	for(id key in infoData)
	{
        request.shouldStreamPostDataFromDisk=YES;
        
        [request appendPostData:[infoData objectForKey:@"data"]];
	}
    
    [_requestQueue addOperation:request];
	[_requestQueue go];	
    
}


-(void)removeRequest:(request_Type)type
{
    NSString *url = nil;
    url = request_Array[type].requestUrl;
            TRACE(@"请求队列%@",[_requestQueue operations] );
    for ( ASIFormDataRequest *request in [_requestQueue operations] ) {
        
        if ([[request.url absoluteString] isEqualToString:url]) {
            [request clearDelegatesAndCancel];
            TRACE(@"取消请求,%@ %i", url,[request.requestID intValue]);
             }
    }

}
/*
 infoData包含三个字典，KEY说明：
 headerInfo（可选字典）:请求头参数字典
 userInfo（必选字典）:用户信息字典，至少包含url的KEY,请求返回时通过request.userInfo带回
 paraInfo（可选字典）:POST请求所需要的附加参数，如接口参数值为空，则相应的KEY也不用传
 
 */
- (void)AddHttpPostRequest:(NSDictionary *)infoData
{
    TRACE(@"普通下载队列增加任务：%@", infoData);
    
    NSDictionary *headerInfo = [infoData objectForKey:@"headerInfo"];
    NSDictionary *userInfo = [infoData objectForKey:@"userInfo"];
    NSDictionary *paraInfo = [infoData objectForKey:@"paraInfo"];
	NSString *url = [userInfo objectForKey:@"url"];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
	[request setRequestMethod:@"POST"];
	[request setTimeOutSeconds:MAX_TIMEOUT_SECONDS];
    [request setAllowCompressedResponse:NO];
    
    //设置标记信息，请求完成时带回
    [request setUserInfo:userInfo];
    
    //增加请求header
    if(headerInfo)
	{
	    for(id key in headerInfo)
		{
			[request addRequestHeader:key value:[headerInfo valueForKey:key]];
		}			
	}
	
    //增加cookie
    
    NSMutableDictionary  *properties = [[[NSMutableDictionary alloc] init] autorelease];
    [properties setValue:_cookieUUID forKey:NSHTTPCookieValue];
    [properties setValue:@"UUID" forKey:NSHTTPCookieName];
    TRACE(@"_cookieUUID = %@", _cookieUUID);
    [properties setValue:@"dev.fg.renren.com" forKey:NSHTTPCookieDomain];
    [properties setValue:@"/" forKey:NSHTTPCookiePath];
    NSHTTPCookie *cookieUUID = [[[NSHTTPCookie alloc] initWithProperties:properties] autorelease];
    [request setRequestCookies:[NSMutableArray arrayWithObjects:cookieUUID,nil]];


    //增加请求参数
	for(id key in paraInfo)
	{
        if([key isEqualToString: @"Filedata"])
        {
            [request setData:[paraInfo valueForKey:key] forKey:key];
        }
        else
            [request addPostValue:[paraInfo valueForKey:key] forKey:key];
        
	}
    [_requestQueue addOperation:request];
    [_requestQueue go];
}


@end


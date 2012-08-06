//
//  FGHttpObject.h
//  FreeGames
//
//  Created by ljl on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ASI/ASIHTTPRequest.h>
#import <ASI/ASINetworkQueue.h>
#import <ASI/ASIFormDataRequest.h>
#import "JSON.h"


@protocol TSHttpObjectDelegate;

@interface TSHttpObject : NSObject
{
    ASINetworkQueue             *_requestQueue;        //普通JSON请求队列
    ASINetworkQueue             *_imageDownloadQueue;  //图下载队列    
    id<TSHttpObjectDelegate>    _gDelegate;
    NSString                    *_cookieUUID;
}


@property (nonatomic, assign) id<TSHttpObjectDelegate> gDelegate;


- (void)AddHttpGetRequest:(NSDictionary *)infoData;
- (void)AddHttpPostRequest:(NSDictionary *)infoData;
-(void)removeRequest:(request_Type)type;
@end

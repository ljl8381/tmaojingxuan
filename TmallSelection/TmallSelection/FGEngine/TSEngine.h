//
//  FGEngine.h
//  FreeGames
//
//  Created by ljl on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TabController.h"
#import "TSHttpHeader.h"

typedef  enum
{
    error_key = -1,
    renren_net = 0,
    sina_webo,
    tencent_weibo,
    //....
    
}list_weibo;

@interface TSEngine : NSObject <TabVCDelegate,TabVCDataSource>

{
    TabController          *_tsTabController;    //UI层
    TSHttpObject           *_fgHttpObject;         //网络层
}

@property (nonatomic,copy)TabController    *tsTabController;

-(void)removeRequest:(request_Type)type;
-(void)reportEvent:(NSString *)event withParameters:(NSDictionary *)paraDic;
@end

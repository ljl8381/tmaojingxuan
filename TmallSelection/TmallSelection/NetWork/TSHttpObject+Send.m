//
//  TSHttpObject+Send.m
//  FreeGames
//
//  Created by ljl on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TSHttpHeader.h"

@implementation TSHttpObject (Send)


//根据页码请求首页数据
-(void)requestMainData:(int)pageNo  proType:(int)type
{
//    TRACE(@"根据页码请求首页数据  pageNo ＝%i" , pageNo);
//    NSString *requestUrl= request_Array[main_data_type].requestUrl;
//    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:requestUrl,@"url",nil];
//    NSMutableDictionary *paraInfo = [[NSMutableDictionary alloc] initWithCapacity:2];
//    [paraInfo setObject:[NSString stringWithFormat:@"%i",pageNo] forKey:@"currentPageIndex"];
//    [paraInfo setObject:[NSString stringWithFormat:@"%i",type] forKey:@"proType"];
//    NSDictionary *infoData = [NSDictionary dictionaryWithObjectsAndKeys:userInfo,@"userInfo",paraInfo,@"paraInfo",nil];
//    [paraInfo release];
//    [self AddHttpPostRequest:infoData];
}
@end

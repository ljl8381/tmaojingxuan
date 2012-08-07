//
//  TSHttpObject+Receive.m
//  FreeGames
//
//  Created by ljl on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TSHttpObject+Receive.h"
#import "TSHttpHeader.h"

@implementation TSHttpObject (Receive)


- (void)receiveDataWithRequestType:(int)requestType andData:(id)data
{
    TRACE(@"requestType：%d",requestType);
    
    switch (requestType) 
    {
        case main_data_type:
            [self receiveMainMsgWithInfo:data];
            break;
        default:
            break;
    }
    
}

//收到首页数据
- (void)receiveMainMsgWithInfo:(NSDictionary *)msgDic
{
//    TRACE(@"收到首页数据");
//    NSDictionary *listDic = nil;
//    NSMutableArray *focusArray ;//= nil;
//    NSMutableArray *cellArray = nil;
//    NSNumber *pageTotalNo = nil;
//    NSNumber *proType = nil;
//    if ([[msgDic objectForKey:@"result"] intValue] == 1)
//    {
//        proType = [NSNumber numberWithInt:[[[msgDic objectForKey:@"data"] objectForKey:@"proType"]intValue]];
//        focusArray = [[msgDic objectForKey:@"data"] objectForKey:@"subjectOrAppList"];
//        cellArray = [[msgDic objectForKey:@"data"] objectForKey:@"appList"];
//        pageTotalNo = [NSNumber numberWithInt:[[[msgDic objectForKey:@"data"] objectForKey:@"totalPageCount"] intValue]];
//        listDic = [[NSDictionary alloc] initWithObjectsAndKeys:cellArray,@"cellsArray",pageTotalNo,@"totalPageCount",proType,@"proType",focusArray,@"focusArray", nil];
//       // TRACE(@"获取成功%@", listDic);
//    }
//    else
//    {
//      //  TRACE(@"获取失败%@", msgDic);
//    }
//    NSString *textpath=  [[NSBundle mainBundle]pathForResource:@"players"ofType:@"txt"];
//    if ([[NSFileManager defaultManager]fileExistsAtPath:textpath]) {
//        
//        NSString *json = [NSString stringWithContentsOfFile:textpath encoding:NSUTF8StringEncoding error:nil];
//        json = [json JSONValue];
//        NSLog(@"文件路径%@,json串%@",textpath,json);
//    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:MAIN_DATA_NOTIFICATION object:nil userInfo:listDic];
//    
//    [listDic release];
}

@end

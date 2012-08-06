//
//  TSHttpObject+Receive.m
//  FreeGames
//
//  Created by ljl on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TSHttpObject+Receive.h"
#import "TSHttpHeader.h"
#import "FGDetialPageObject.h"

@implementation TSHttpObject (Receive)


- (void)receiveDataWithRequestType:(int)requestType andData:(id)data
{
    TRACE(@"requestType：%d",requestType);
    
    switch (requestType) 
    {
        case main_data_type:
            [self receiveMainMsgWithInfo:data];
            break;
        case hotwords_data_type:
            [self receiveHotWordsInfo:data];
            break;
        case suggest_data_type:
            [self receiveSuggestionResultInfo:data];
            break;
        case search_data_type:
        case search_more_type:
            [self receiveSearchResultInfo:data];
            break;
        case cate_data_type:
            [self receiveCateDateInfo:data];
            break;
        case category_data_type:
            [self receiveCategoryDataInfo:data];
            break;
        case more_feedback_type:
            [self receiveFeedBackInfo:data];
            break;
        case detial_data_type:
            [self receiveDetialPageMsgWithInfo:data];
            break;
        case free_data_type:
            [self receiveFreeMsgWithInfo:data];
            break;
        case album_data_type:
            [self receiveAlbumMsgWithInfo:data];
            break;
        case album_earlier_data_type:
            [self receiveEarlierAlbumMsgWithInfo:data];
            break;
        case album_detial_data_type:
            [self receiveAlbumDetialMsgWithInfo:data];
            break;
        case more_data_type:
            [self receiveMoreDataInfo:data];
            break;
        case evaluate_game_type:
            [self receiveEvaluateDateInfo:data];
        default:
            break;
    }
    
}

//收到首页数据
- (void)receiveMainMsgWithInfo:(NSDictionary *)msgDic
{
    TRACE(@"收到首页数据");
    NSDictionary *listDic = nil;
    NSMutableArray *focusArray ;//= nil;
    NSMutableArray *cellArray = nil;
    NSNumber *pageTotalNo = nil;
    NSNumber *proType = nil;
    if ([[msgDic objectForKey:@"result"] intValue] == 1)
    {
        proType = [NSNumber numberWithInt:[[[msgDic objectForKey:@"data"] objectForKey:@"proType"]intValue]];
        focusArray = [[msgDic objectForKey:@"data"] objectForKey:@"subjectOrAppList"];
        cellArray = [[msgDic objectForKey:@"data"] objectForKey:@"appList"];
        pageTotalNo = [NSNumber numberWithInt:[[[msgDic objectForKey:@"data"] objectForKey:@"totalPageCount"] intValue]];
        listDic = [[NSDictionary alloc] initWithObjectsAndKeys:cellArray,@"cellsArray",pageTotalNo,@"totalPageCount",proType,@"proType",focusArray,@"focusArray", nil];
       // TRACE(@"获取成功%@", listDic);
    }
    else
    {
      //  TRACE(@"获取失败%@", msgDic);
    }
    NSString *textpath=  [[NSBundle mainBundle]pathForResource:@"players"ofType:@"txt"];
    if ([[NSFileManager defaultManager]fileExistsAtPath:textpath]) {
        
        NSString *json = [NSString stringWithContentsOfFile:textpath encoding:NSUTF8StringEncoding error:nil];
        json = [json JSONValue];
        NSLog(@"文件路径%@,json串%@",textpath,json);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:MAIN_DATA_NOTIFICATION object:nil userInfo:listDic];
    
    [listDic release];
}



//收到热词
- (void)receiveHotWordsInfo:(NSDictionary *)msgDic
{
    TRACE(@"收到热词列表%@",msgDic);
    NSDictionary *listDic = nil;
    
    if ([[msgDic objectForKey:@"result"] intValue] == 1)
    {
        listDic = [msgDic objectForKey:@"data"];
        
      //  TRACE(@"获取成功%@", listDic);
    }
    else
    {
       // TRACE(@"获取失败%@", msgDic);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:SEARCH_HOTWORDS_NOTIFICATION object:nil userInfo:listDic];
    
}

//收到提示结果
- (void)receiveSuggestionResultInfo:(NSDictionary *)msgDic
{
    TRACE(@"收到提示信息数据");
    NSDictionary *listDic = nil;
    
    if ([[msgDic objectForKey:@"result"] boolValue])
    {
        NSArray *titleArray = [[msgDic objectForKey:@"data"]objectForKey:@"searchResult"];
        listDic = [[NSDictionary alloc] initWithObjectsAndKeys:titleArray,@"titleArray", nil];
        
        // TRACE(@"获取成功%@", listDic);
    }
    else
    {
        // TRACE(@"获取失败%@", msgDic);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:SUGGEST_DATA_NOTIFICATION object:nil userInfo:listDic];
    [listDic release];
}
//收到搜索结果
- (void)receiveSearchResultInfo:(NSDictionary *)msgDic
{
    TRACE(@"收到搜索结果");
    NSDictionary *listDic = nil;
    NSMutableArray *resultList= nil;
    NSNumber *pageTotalNo = nil;
    NSString *searchResultString = searchResultString = [msgDic objectForKey:@"msg"];;
    if ([[msgDic objectForKey:@"result"] boolValue])
    {
        resultList = [[msgDic objectForKey:@"data"] objectForKey:@"searchResult"];
        pageTotalNo = [NSNumber numberWithInt:[[[msgDic objectForKey:@"data"] objectForKey:@"totalPageCount"] intValue]];
        listDic = [[NSDictionary alloc] initWithObjectsAndKeys:resultList,@"resultList",pageTotalNo,@"totalPageCount",searchResultString,@"searchResult", nil];
        
      //  TRACE(@"获取成功%@", listDic);
        [[NSNotificationCenter defaultCenter] postNotificationName:SEARCH_DATA_NOTIFICATION object:nil userInfo:listDic];
         [listDic release];
    }
    else
    {
         TRACE(@"获取失败%@", msgDic);
        if ([[msgDic objectForKey:@"msg"] isEqualToString:@"对象不存在"]) {
            listDic = [[NSDictionary alloc] initWithObjectsAndKeys:searchResultString,@"searchResultString", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:SEARCH_DATA_NOTIFICATION object:nil userInfo:listDic];
            [listDic release];
        }
        else {
            [[NSNotificationCenter defaultCenter] postNotificationName:SEARCH_DATA_NOTIFICATION object:nil userInfo:listDic];
        }
    }
}

//收到反馈结果
- (void)receiveFeedBackInfo:(NSDictionary *)msgDic
{
    TRACE(@"收到反馈信息");
    NSDictionary *listDic = nil;
    
    if ([[msgDic objectForKey:@"result"] boolValue])
    {
        listDic = [msgDic objectForKey:@"data"];
        
        //   TRACE(@"获取成功%@", listDic);
    }
    else
    {
        //    TRACE(@"获取失败%@", msgDic);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FEEDBACK_DATA_NOTIFICATION object:nil userInfo:listDic];
    
}

- (void)receiveCateDateInfo:(NSDictionary *)msgDic
{
    TRACE(@"收到分类列表信息");
    NSDictionary *listDic = nil;
    NSMutableArray *cateList= nil;
    if ([[msgDic objectForKey:@"result"] boolValue])
    {
        cateList = [[msgDic objectForKey:@"data"] objectForKey:@"genreList"];
        listDic = [[NSDictionary alloc] initWithObjectsAndKeys:cateList,@"cateList", nil];
     //     TRACE(@"获取成功%@", listDic);
        [[NSNotificationCenter defaultCenter] postNotificationName:CATE_DATA_NOTIFICATION object:nil userInfo:listDic];
        [listDic release];
    }
    else
    {
    //    TRACE(@"获取失败%@", msgDic);
        [[NSNotificationCenter defaultCenter] postNotificationName:CATE_DATA_NOTIFICATION object:nil userInfo:listDic];
    }
}

//请求具体分类内容
-(void)receiveCategoryDataInfo:(NSDictionary *)msgDic
{
    TRACE(@"收到分类内容");
    NSDictionary *listDic = nil;
    NSDictionary *cateDetailList = nil;
    NSNumber *pageCount =nil;
    NSNumber *proType = nil;
    if ([[msgDic objectForKey:@"result"] intValue] == 1)
    {
        proType = [NSNumber numberWithInt:[[[msgDic objectForKey:@"data"] objectForKey:@"proType"]intValue]];
        cateDetailList = [[msgDic objectForKey:@"data"]objectForKey:@"rankAppList"];
        pageCount = [NSNumber numberWithInt:[[[msgDic objectForKey:@"data"] objectForKey:@"totalPageCount"] intValue]];
        listDic = [[NSDictionary alloc] initWithObjectsAndKeys:cateDetailList,@"rankAppList",pageCount,@"totalPageCount",proType,@"proType", nil];
         TRACE(@"分类详情listDic = %@",listDic);
     //   TRACE(@"获取成功%@", listDic);
        [[NSNotificationCenter defaultCenter] postNotificationName:CATEGORY_DATA_NOTIFICATION object:nil userInfo:listDic];
        [listDic release];
    }
    else
    {
     //   TRACE(@"获取失败%@", msgDic);
        [[NSNotificationCenter defaultCenter] postNotificationName:CATEGORY_DATA_NOTIFICATION object:nil userInfo:listDic];
    }
}

- (void)receiveDetialPageMsgWithInfo:(NSDictionary *)msgDic{
    
    TRACE(@"收到详情页数据");
    NSDictionary *listDic = nil;
    if ([[msgDic objectForKey:@"result"] intValue] == 1)
    {
        listDic = [msgDic objectForKey:@"data"];
   //     TRACE(@"收到详情页数据，%@ ",listDic);
    }
    else
    {
    //    TRACE(@"获取失败%@", msgDic);
    }    
    [[NSNotificationCenter defaultCenter] postNotificationName:DETIAL_PAGE_DATA_NOTIFICATION object:nil userInfo:listDic];
    
}

- (void)receiveFreeMsgWithInfo:(NSDictionary *)msgDic
{
    TRACE(@"收到限免数据");
    NSDictionary *listDic = nil;
    
    if ([[msgDic objectForKey:@"result"] intValue] == 1)
    {
        listDic = [msgDic objectForKey:@"data"];
        
    //    TRACE(@"获取成功%@", listDic);
    }
    else
    {
     //   TRACE(@"获取失败%@", msgDic);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:FREE_DATA_NOTIFICATION object:nil userInfo:listDic];
    
}
//收到专辑
- (void)receiveAlbumMsgWithInfo:(NSDictionary *)msgDic
{
    TRACE(@"收到专题");
    NSDictionary *listDic = nil;
    
    if ([[msgDic objectForKey:@"result"] intValue] == 1)
    {
        listDic = [msgDic objectForKey:@"data"];
        
    //    TRACE(@"获取成功%@", listDic);
    }
    else
    {
    //    TRACE(@"获取失败%@", msgDic);
    }
    TRACE(@"专题数据 %@",msgDic);
    [[NSNotificationCenter defaultCenter] postNotificationName:ALBUM_DATA_NOTIFICATION object:nil userInfo:listDic];
}
//收到更早专题
- (void)receiveEarlierAlbumMsgWithInfo:(NSDictionary *)msgDic
{
    TRACE(@"收到更早专题");
    NSDictionary *listDic = nil;
    
    if ([[msgDic objectForKey:@"result"] intValue] == 1)
    {
        listDic = [msgDic objectForKey:@"data"];
        
     //   TRACE(@"获取成功%@", listDic);
    }
    else
    {
    //    TRACE(@"获取失败%@", msgDic);
    }    
    [[NSNotificationCenter defaultCenter] postNotificationName:ALBUM_EARLIER_DATA_NOTIFICATION object:nil userInfo:listDic];
}


- (void)receiveAlbumDetialMsgWithInfo:(NSDictionary *)msgDic
{
    TRACE(@"收到具体专辑数据");
    NSDictionary *listDic = nil;
    
    if ([[msgDic objectForKey:@"result"] intValue] == 1)
    {
        listDic = [msgDic objectForKey:@"data"];
        
    //    TRACE(@"获取成功%@", listDic);
    }
    else
    {
     //   TRACE(@"获取失败%@", msgDic);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:ALBUM_DETIAL_DATA_NOTIFICATION object:nil userInfo:listDic];
}
- (void)receiveMoreDataInfo:(NSDictionary *)msgDic
{
    TRACE(@"收到更多页数据");
    NSDictionary *listDic = nil;
    
    if ([[msgDic objectForKey:@"result"] intValue] == 1)
    {
        listDic = [msgDic objectForKey:@"data"];
        
        //    TRACE(@"获取成功%@", listDic);
    }
    else
    {
        //   TRACE(@"获取失败%@", msgDic);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:MORE_DATA_NOTIFICATION object:nil userInfo:listDic];
}
- (void)receiveEvaluateDateInfo:(NSDictionary *)msgDic
{
    TRACE(@"收到评价结果");
    NSDictionary *listDic = nil;
    
    if ([msgDic objectForKey:@"result"] )
    {
        listDic = [msgDic objectForKey:@"data"];
           // TRACE(@"获取成功%@", listDic);
    }
    else
    {
          // TRACE(@"获取失败%@", msgDic);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:EVALUATE_DATA_NOTIFICATION object:nil userInfo:listDic];
}
@end

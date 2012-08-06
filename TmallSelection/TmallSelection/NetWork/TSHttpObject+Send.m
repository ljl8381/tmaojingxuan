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
    TRACE(@"根据页码请求首页数据  pageNo ＝%i" , pageNo);
    NSString *requestUrl= request_Array[main_data_type].requestUrl;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:requestUrl,@"url",nil];
    NSMutableDictionary *paraInfo = [[NSMutableDictionary alloc] initWithCapacity:2];
    [paraInfo setObject:[NSString stringWithFormat:@"%i",pageNo] forKey:@"currentPageIndex"];
    [paraInfo setObject:[NSString stringWithFormat:@"%i",type] forKey:@"proType"];
    NSDictionary *infoData = [NSDictionary dictionaryWithObjectsAndKeys:userInfo,@"userInfo",paraInfo,@"paraInfo",nil];
    [paraInfo release];
    [self AddHttpPostRequest:infoData];
}

//请求推荐热词
-(void)requestHotWords
{
    TRACE(@"发送请求推荐热词");
    NSString *requestUrl= request_Array[hotwords_data_type].requestUrl;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:requestUrl,@"url",nil];
    NSDictionary *infoData = [NSDictionary dictionaryWithObjectsAndKeys:userInfo,@"userInfo",nil];
    [self AddHttpPostRequest:infoData];
}
//请求提示信息
-(void)requestSuggestionData:(NSString *)suggestText
{
    TRACE(@"请求提示信息 text ＝%@" , suggestText);
    [self removeRequest:suggest_data_type];
    NSString *requestUrl=  [NSString stringWithFormat:request_Array[suggest_data_type].requestUrl, suggestText];
    // NSString *requestUrl= request_Array[suggest_data_type].requestUrl;    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:requestUrl,@"url",nil];
    NSMutableDictionary *paraInfo = [[NSMutableDictionary alloc] initWithCapacity:2];
    [paraInfo setObject:[NSString stringWithFormat:@"%@",suggestText] forKey:@"key"];
    NSDictionary *infoData = [NSDictionary dictionaryWithObjectsAndKeys:userInfo,@"userInfo",paraInfo,@"paraInfo",nil];
    [paraInfo release];
    [self AddHttpPostRequest:infoData];
}

//开始进行搜索
-(void)beginToSearch:(NSString *)searchText  andPageNo:(int)pageNo

{
    TRACE(@"请求搜索数据 text ＝%@" , searchText);
    NSString *requestUrl= request_Array[search_data_type].requestUrl;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:requestUrl,@"url",nil];
    NSMutableDictionary *paraInfo = [[NSMutableDictionary alloc] initWithCapacity:2];
    [paraInfo setObject:[NSString stringWithFormat:@"%@",searchText] forKey:@"key"];
    [paraInfo setObject:[NSString stringWithFormat:@"%i",pageNo] forKey:@"pageNo"];
    NSDictionary *infoData = [NSDictionary dictionaryWithObjectsAndKeys:userInfo,@"userInfo",paraInfo,@"paraInfo",nil];
    [paraInfo release];
    [self AddHttpPostRequest:infoData];
    
}

////根据页码请求搜索结果页数据
//-(void)requestMoreResult:(int)pageNo
//{
//    
//    TRACE(@"请求搜索更多数据 page ＝%d" , pageNo);
//    NSString *requestUrl= request_Array[search_more_type].requestUrl;
//    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:requestUrl,@"url",nil];
//    NSMutableDictionary *paraInfo = [[NSMutableDictionary alloc] initWithCapacity:2];
//    [paraInfo setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:@"pageNo"];
//    NSDictionary *infoData = [NSDictionary dictionaryWithObjectsAndKeys:userInfo,@"userInfo",paraInfo,@"paraInfo",nil];
//    [paraInfo release];
//    [self AddHttpPostRequest:infoData];
//    
//}
- (void)sendFeedBack:(NSString *)feedString andEmail:(NSString *)emailString
{
    TRACE(@"发送反馈信息");
    NSString *requestUrl= request_Array[more_feedback_type].requestUrl;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:requestUrl,@"url",nil];
    NSMutableDictionary *paraInfo = [[NSMutableDictionary alloc] initWithCapacity:2];
    [paraInfo setObject:feedString forKey:@"feedstring"];
    [paraInfo setObject:emailString forKey:@"emailString"];
    NSDictionary *infoData = [NSDictionary dictionaryWithObjectsAndKeys:userInfo,@"userInfo",paraInfo,@"paraInfo",nil];
    [paraInfo release];
    [self AddHttpPostRequest:infoData];
}
//根据游戏名称请求详情页 
-(void)requestDetialPageData:(NSString *)gameID
{
    if (gameID&&![gameID isEqualToString:@""]) {
        TRACE(@"根据游戏名称请求详情页 gameID = %@", gameID);
        
        NSString *requestUrl= request_Array[detial_data_type].requestUrl;
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:requestUrl,@"url",nil];
        NSMutableDictionary *paraInfo = [[NSMutableDictionary alloc] initWithCapacity:2];
        [paraInfo setObject:gameID forKey:@"appId"];
        NSDictionary *infoData = [NSDictionary dictionaryWithObjectsAndKeys:userInfo,@"userInfo",paraInfo,@"paraInfo",nil];
        [paraInfo release];
        [self AddHttpPostRequest:infoData];
    }
}

//根据种类和页码请求限时免费 
-(void)requestFreeData:(NSString *)currentType andPage:(int)pageNo
{
    TRACE(@"根据游戏名称请求详情页 currentType ＝ %@  pageNo ＝ %i", currentType, pageNo);
    
    NSString *requestUrl= request_Array[free_data_type].requestUrl;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:requestUrl,@"url",nil];
    
    NSMutableDictionary *paraInfo = [[NSMutableDictionary alloc] initWithCapacity:2];
    [paraInfo setObject:currentType forKey:@"proType"];
    [paraInfo setObject:[NSString stringWithFormat:@"%i", pageNo] forKey:@"currentPageIndex"];
    NSDictionary *infoData = [NSDictionary dictionaryWithObjectsAndKeys:userInfo,@"userInfo",paraInfo,@"paraInfo",nil];
    [paraInfo release];
    
    [self AddHttpPostRequest:infoData];
    
}

//请求分类数据
-(void)requestCateMainData
{
    TRACE(@"发送分类请求");
    NSString *requestUrl= request_Array[cate_data_type].requestUrl;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:requestUrl,@"url",nil];
    NSDictionary *infoData = [NSDictionary dictionaryWithObjectsAndKeys:userInfo,@"userInfo",nil];
    [self AddHttpPostRequest:infoData];
    
}

//请求具体分类内容
- (void)requestCategoryData:(NSInteger)index andCurrentType:(int )currentType withPageNo:(int)pageNo
{
    TRACE(@"发送具体分类请求 index ＝ %i,currentType = %i ,pageNo = %i",index,currentType,pageNo);
    
    NSString *requestUrl= request_Array[category_data_type].requestUrl;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:requestUrl,@"url",nil];
    
    NSMutableDictionary *paraInfo = [[NSMutableDictionary alloc] initWithCapacity:2];
    [paraInfo setObject:[NSString stringWithFormat:@"%i", index] forKey:@"genreId"];
    [paraInfo setObject:[NSString stringWithFormat:@"%i", pageNo] forKey:@"currentPageIndex"];
    [paraInfo setObject:[NSString stringWithFormat:@"%i", currentType] forKey:@"proType"];
    NSDictionary *infoData = [NSDictionary dictionaryWithObjectsAndKeys:userInfo,@"userInfo",paraInfo,@"paraInfo",nil];
    [paraInfo release];
    
    [self AddHttpPostRequest:infoData];
}
//专题栏目请求
- (void)requestAlbumData
{
    TRACE(@"专题栏目请求");
    
    NSString *requestUrl= request_Array[album_data_type].requestUrl;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:requestUrl,@"url",nil];
    
    NSMutableDictionary *paraInfo = [[NSMutableDictionary alloc] initWithCapacity:2];
    // [paraInfo setObject:@"Album" forKey:@"Album"];
    int i = 0;
    [paraInfo setObject:[NSString stringWithFormat:@"%i",i] forKey:@"currentPageIndex"];
    NSDictionary *infoData = [NSDictionary dictionaryWithObjectsAndKeys:userInfo,@"userInfo",paraInfo,@"paraInfo",nil];
    [paraInfo release];
    [self AddHttpPostRequest:infoData];
}

//请求更早专题
- (void)requestEarlierData:(int)PageNo
{
    TRACE(@"请求更早专题");
    
    NSString *requestUrl= request_Array[album_earlier_data_type].requestUrl;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:requestUrl,@"url",nil];
    
    NSMutableDictionary *paraInfo = [[NSMutableDictionary alloc] initWithCapacity:2];
    [paraInfo setObject:[NSString stringWithFormat:@"%i",PageNo] forKey:@"pageNo"];
    NSDictionary *infoData = [NSDictionary dictionaryWithObjectsAndKeys:userInfo,@"userInfo",paraInfo,@"paraInfo",nil];
    [paraInfo release];
    [self AddHttpPostRequest:infoData];
}

//专辑详细页请求
- (void)requestAlbumDetialData:(NSString *)albumID andPageNo:(int)pageNo
{
    TRACE(@"专题栏目详细页请求");
    
    NSString *requestUrl= request_Array[album_detial_data_type].requestUrl;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:requestUrl,@"url",nil];
    
    NSMutableDictionary *paraInfo = [[NSMutableDictionary alloc] initWithCapacity:2];
    [paraInfo setObject:albumID forKey:@"subjectId"];
    [paraInfo setObject:[NSString stringWithFormat:@"%i",pageNo] forKey:@"currentPageIndex"];
    NSDictionary *infoData = [NSDictionary dictionaryWithObjectsAndKeys:userInfo,@"userInfo",paraInfo,@"paraInfo",nil];
    [paraInfo release];
    [self AddHttpPostRequest:infoData];
}
//更多页请求
- (void)requestMoreData
{
    TRACE(@"专题栏目详细页请求");
    
    NSString *requestUrl= request_Array[more_data_type].requestUrl;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:requestUrl,@"url",nil];
    
    NSMutableDictionary *paraInfo = [[NSMutableDictionary alloc] initWithCapacity:2];
    //[paraInfo setObject:[@"467577200" intValue] forKey:@"subjectId"];
    //[paraInfo setObject:[NSString stringWithFormat:@"%i",0] forKey:@"currentPageIndex"];
    NSDictionary *infoData = [NSDictionary dictionaryWithObjectsAndKeys:userInfo,@"userInfo",paraInfo,@"paraInfo",nil];
    [paraInfo release];
    [self AddHttpPostRequest:infoData];

}
//报告下载信息
- (void)reportDownloadAction:(NSString *)gameId
{
    TRACE(@"报告下载信息");
    NSString *requestUrl= request_Array[report_download_type].requestUrl;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:requestUrl,@"url",nil];
    
    NSMutableDictionary *paraInfo = [[NSMutableDictionary alloc] initWithCapacity:1];
    [paraInfo setObject:gameId forKey:@"appId"];
    NSDictionary *infoData = [NSDictionary dictionaryWithObjectsAndKeys:userInfo,@"userInfo",paraInfo,@"paraInfo",nil];
    [paraInfo release];
    [self AddHttpPostRequest:infoData];

}
- (void)evaluateTheGame:(BOOL)goodOrBadEvalute withGameId:(NSString *)gameId
{
    TRACE(@"评价游戏");
    NSString *requestUrl= request_Array[evaluate_game_type].requestUrl;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:requestUrl,@"url",nil];
    
    NSMutableDictionary *paraInfo = [[NSMutableDictionary alloc] initWithCapacity:1];
    [paraInfo setObject:[NSString stringWithFormat:@"%i", goodOrBadEvalute+1] forKey:@"rate"];
    [paraInfo setObject:gameId forKey:@"appId"];
    NSDictionary *infoData = [NSDictionary dictionaryWithObjectsAndKeys:userInfo,@"userInfo",paraInfo,@"paraInfo",nil];
    [paraInfo release];
    [self AddHttpPostRequest:infoData];
 
}
@end

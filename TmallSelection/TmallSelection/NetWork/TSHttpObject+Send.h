//
//  TSHttpObject+Send.h
//  FreeGames
//
//  Created by ljl on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TSHttpObject.h"

@interface TSHttpObject (Send)

//根据页码请求首页数据
-(void)requestMainData:(int)pageNo  proType:(int)type;
//请求推荐热词
-(void)requestHotWords;
//请求提示信息
-(void)requestSuggestionData:(NSString *)suggestText;
//开始进行搜索
-(void)beginToSearch:(NSString *)searchText  andPageNo:(int)pageNo;
////根据页码请求搜索结果页数据
//-(void)requestMoreResult:(NSString *)searchText  andPageNo:(int)pageNo;
//发送反馈请求
- (void)sendFeedBack:(NSString *)feedString andEmail:(NSString *)emailString;
//根据游戏名称请求详情页 
- (void)requestFreeData:(NSString *)keyWords andPage:(int)pageNo;

//专题栏目请求
- (void)requestAlbumData;
//请求更早专题
- (void)requestEarlierData:(int)PageNo;
//专辑详细页请求
- (void)requestAlbumDetialData:(NSString *)albumID andPageNo:(int)pageNo;

//获取详细页数据
- (void)requestDetialPageData:(NSString *)gameID;
//请求分类数据
- (void)requestCateMainData;
//请求具体分类内容
- (void)requestCategoryData:(NSInteger)index andCurrentType:(int )currentType withPageNo:(int)pageNo;
//请求更多页数据
- (void)requestMoreData;
//报告下载信息
- (void)reportDownloadAction:(NSString *)gameId;
//评价游戏
- (void)evaluateTheGame:(BOOL)goodOrBadEvalute withGameId:(NSString *)gameId;
@end


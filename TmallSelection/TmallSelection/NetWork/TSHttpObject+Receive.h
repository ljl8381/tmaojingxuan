//
//  TSHttpObject+Receive.h
//  FreeGames
//
//  Created by ljl on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TSHttpObject.h"

@interface TSHttpObject (Receive)

- (void)receiveDataWithRequestType:(int)requestType andData:(id)data;


//收到反馈结果
- (void)receiveFeedBackInfo:(NSDictionary *)msgDic;
//收到首页数据
- (void)receiveMainMsgWithInfo:(NSDictionary *)msgDic;
//收到热词
- (void)receiveHotWordsInfo:(NSDictionary *)msgDic;
//收到提示结果
- (void)receiveSuggestionResultInfo:(NSDictionary *)msgDic;
//收到搜索结果
- (void)receiveSearchResultInfo:(NSDictionary *)msgDic;
//收到首页的详细页数据
- (void)receiveDetialPageMsgWithInfo:(NSDictionary *)msgDic;
//收到限时免费页面数据
- (void)receiveFreeMsgWithInfo:(NSDictionary *)msgDic;
//收到专题页面数据
- (void)receiveAlbumMsgWithInfo:(NSDictionary *)msgDic;
//收到专题详细页面数据
- (void)receiveAlbumDetialMsgWithInfo:(NSDictionary *)msgDic;
//收到分类数据
- (void)receiveCateDateInfo:(NSDictionary *)msgDic;
//请求具体分类内容
-(void)receiveCategoryDataInfo:(NSDictionary *)msgDic;
//收到更早专题
- (void)receiveEarlierAlbumMsgWithInfo:(NSDictionary *)msgDic;
//收到更多页数据
- (void)receiveMoreDataInfo:(NSDictionary *)msgDic;
//收到评价结果
- (void)receiveEvaluateDateInfo:(NSDictionary *)msgDic;
@end

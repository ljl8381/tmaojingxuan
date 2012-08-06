//
//  FGHttpDelegate.h
//  FreeGames
//
//  Created by ljl on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


@protocol TSHttpObjectDelegate <NSObject>

@optional

- (void)receiveMainMsgWithInfo:(NSDictionary *)msgDic;

//收到反馈结果
- (void)receiveFeedBackInfo:(NSDictionary *)msgDic;

//收到下载图数据
- (void)receiveDownloadImageInfo:(NSDictionary *)dataDic;

@end

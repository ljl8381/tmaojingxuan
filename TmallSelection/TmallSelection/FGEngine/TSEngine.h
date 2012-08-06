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
#import "MainViewController.h"
#import "MoreViewController.h"
#import "CategoryViewController.h"
#import "SearchViewController.h"
#import "AlbumViewController.h"
#import "GameDetailView.h"
#import "SearchResultViewController.h"
#import "ShareViewController.h"
#import "ZBarSDK.h"

typedef  enum
{
    error_key = -1,
    renren_net = 0,
    sina_webo,
    tencent_weibo,
    //....
    
}list_weibo;

@interface TSEngine : NSObject <TabVCDelegate,TabVCDataSource,MainVCDelegate,TSHttpObjectDelegate,MoreVCDelegate,CateVCDelegate,searchDelegate,AlbumVCDelegate,detialPageInf,ShareVCDelegate,ZBarReaderDelegate>

{
    TabController          *_fgTabController;    //UI层
    TSHttpObject           *_fgHttpObject;         //网络层
    MainViewController     *_mainController;
}

@property (nonatomic,copy)TabController    *fgTabController;

-(void)removeRequest:(request_Type)type;
-(void)reportEvent:(NSString *)event withParameters:(NSDictionary *)paraDic;
@end

//
//  TabController.h
//  FreeGames
//
//  Created by ljl on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

typedef enum 
{
	PAGE_MAIN   = 0,    //首页
	PAGE_ALBUM,         //专辑
	PAGE_FREE,          //限免
	PAGE_CATEGORY,      //分类
    PAGE_MORE,          //更多
    
}TAB_PAGE;

@protocol TabVCDelegate;
@protocol TabVCDataSource;

@interface TabController : UITabBarController
{
    id<TabVCDelegate>   _fgDelegate;
    id<TabVCDataSource> _fgDataSource;

    UIImageView		*_backgroundImageView;
    NSMutableArray	*_buttonsArray;
    NSArray         *array;

}

@property (nonatomic,retain)NSMutableArray	*buttonsArray;

@property (nonatomic, assign) id <TabVCDelegate>    fgDelegate;
@property (nonatomic, assign) id <TabVCDataSource>  fgDataSource;
@end


@protocol TabVCDataSource <NSObject>
@optional

- (void)creatTabButtonWithButtonArray:(NSMutableArray *)buttonsArray;
- (void)loadTabBarViewControllers:(NSMutableArray *)controllersArray;

@end

@protocol TabVCDelegate <NSObject>
@optional


@end
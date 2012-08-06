//
//  FGViewController.h
//  FreeGames
//
//  Created by ljl on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGBarButton.h"
@protocol searchButttonDelegate;
@interface FGViewController :UIViewController

{
    FGBarButton     *_backButton;
    UIButton        *_errorButton;
    UIImageView     *_backgroundImageView;
    
    id <searchButttonDelegate>  _srDelegate;
}

@property (nonatomic,retain)FGBarButton     *backButton;
@property (nonatomic,assign)id  srDelegate;

//重新请求数据
-(void)reloadNetwork;
- (NSString *) splitTitle:(NSString *)Word;

@end

@protocol searchButttonDelegate <NSObject>
@optional
//显示搜索页面
- (void)showSearchPage:(UIViewController *)aViewController;
@end



//
//  FGViewController.h
//  FreeGames
//
//  Created by ljl on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGBarButton.h"
#import "YIFullScreenScroll.h"
@interface TSViewController :UIViewController <UIScrollViewDelegate>

{
    FGBarButton     *_backButton;
    UIButton        *_errorButton;
    UIImageView     *_backgroundImageView;
    YIFullScreenScroll* _fullScreenDelegate;
    
}

@property (nonatomic,retain)FGBarButton     *backButton;
@property (nonatomic,assign)id  srDelegate;

//重新请求数据
-(void)reloadNetwork;
- (NSString *) splitTitle:(NSString *)Word;

@end




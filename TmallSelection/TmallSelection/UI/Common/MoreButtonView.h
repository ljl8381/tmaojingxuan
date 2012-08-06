//
//  MoreButtonView.h
// 
//
//  Created by ljl on 12-6-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreButtonView : UIView
{
    UIButton            *_moreBt;                         //底部更多按钮
    UILabel             *_backgroundLabel;                //没有数据时显示
    UIActivityIndicatorView *_indicator;
}

@property (nonatomic,retain) UIButton   *moreBt; 
@property (nonatomic,retain) UILabel    *backgroundLabel;
@property (nonatomic,retain) UIActivityIndicatorView *indicator; 
@end

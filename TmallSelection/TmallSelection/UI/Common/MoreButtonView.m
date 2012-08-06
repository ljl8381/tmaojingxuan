//
//  MoreButtonView.m
// 
//
//  Created by ljl on 12-6-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MoreButtonView.h"
#import "Color+Hex.h"

const unsigned int kFooterButtonHeight = 42;
const unsigned int kColorTableViewFooterFont = 0xFF303030;
const unsigned int kSizeTableViewFooterFont = 18;
#define kIndicatorFrame     CGRectMake(266, 20, 20, 20)
#define kBtnImageFile       @"image_button.png"
#define hTitleFont          [UIFont fontWithName:@"Helvetica-Bold" size:14]

@implementation MoreButtonView

@synthesize moreBt =_moreBt;
@synthesize backgroundLabel = _backgroundLabel;
@synthesize indicator =_indicator;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Calculate the frame.
        CGRect frame = CGRectMake(0.0, 0.0, 320, kFooterButtonHeight);
        frame.origin.y = floorf((70 - 54)/2.0);
        _backgroundLabel = [[UILabel alloc]initWithFrame:frame];
        _backgroundLabel.backgroundColor = [UIColor clearColor];
        _backgroundLabel.text = NSLocalizedString(@"MoreButtonNoMsg", nil);
        _backgroundLabel.textColor = [UIColor colorWithHex:0xFF666666];
        _backgroundLabel.font = hTitleFont;
        _backgroundLabel.shadowColor = [UIColor colorWithHex:0xFFFFFFFF];
        _backgroundLabel.shadowOffset = CGSizeMake(0, -1);
        _backgroundLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:_backgroundLabel];
        
        _moreBt = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [ _moreBt.titleLabel setFont:hTitleFont];
        [ _moreBt setTitleColor:[UIColor colorWithHex:0xFF666666] forState:UIControlStateNormal];
        [ _moreBt setTitle:NSLocalizedString(@"MoreButtonHaveMsg", nil) forState:UIControlStateNormal];
        [ _moreBt setTitleShadowColor:[UIColor colorWithHex:0xFFFFFFFF] forState:UIControlStateNormal];
        
        [ _moreBt setTitleColor:[UIColor colorWithHex:0xFFFFFFFF] forState:UIControlStateHighlighted];
        [ _moreBt setTitleShadowColor:[UIColor colorWithHex:0xFF000000] forState:UIControlStateHighlighted];
        //临时背景图片
        [ _moreBt setBackgroundImage:[UIImage imageNamed:MORE_BUTTON_IMG] forState:UIControlStateNormal];
        [ _moreBt setBackgroundImage:[UIImage imageNamed:MORE_BUTTON_IMG_PRESSED] forState:UIControlStateHighlighted];
        
        _moreBt.frame = CGRectMake(0, 0, [UIImage imageNamed:MORE_BUTTON_IMG].size.width, [UIImage imageNamed:MORE_BUTTON_IMG].size.height);
        _moreBt.titleLabel.tag = 0;
        [self addSubview:_moreBt];
        
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicator.frame = kIndicatorFrame;
        _indicator.hidesWhenStopped = YES;
        [self addSubview:_indicator];
    }
    return self;
}
- (void)dealloc
{
    [_indicator release];
    
    [super dealloc];
}

@end

//
//  ItemButton.m
//  TmallSelection
//
//  Created by ljl on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ItemButton.h"
#import "Color+Hex.h"
@implementation ItemButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _backgroundButton = [[UIButton alloc]initWithFrame:CGRectMake(4, 4, frame.size.width-8, frame.size.height-8)];
        [_backgroundButton addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_backgroundButton setBackgroundImage:[UIImage imageNamed: @"man_001.png"] forState:UIControlStateNormal];
        [self addSubview:_backgroundButton];
        _titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(4, 5, 30, 24)];
        _titleLabel.backgroundColor =[UIColor colorWithHex:0x80000000];
        [self addSubview:_titleLabel];
        _titleLabel.text = @"男装";
        _titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return self;
}
-(void)dealloc
{   
    if (_title) {
        [_title release];
    }
    if (_backgroundImage) {
        [_backgroundImage release];
    }
    
}
-(void)setInfoWithDic:(NSDictionary *)infoDic
{
    
    _title = [[infoDic objectForKey:@"title"] retain];
    _backgroundImage = [[infoDic objectForKey:@"image"] retain];
    [_backgroundButton setBackgroundImage:[UIImage imageNamed: @"man_001.png"] forState:UIControlStateNormal];
    _typeID = [[infoDic objectForKey:@"ID"]intValue];
    
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //self.backgroundColor = [UIColor blackColor];
    // Drawing code
    [super drawRect:rect];
    
    [[UIColor clearColor] set];
    UIRectFill(rect);
    UIImage *backgroundImage = nil;     
	backgroundImage = [UIImage imageNamed:@"pic_bg.png"];
	// Draw the background image
	[backgroundImage drawInRect:self.bounds];
    
}

-(void)buttonClicked
{
    TRACE(@"按钮按动");
}

@end

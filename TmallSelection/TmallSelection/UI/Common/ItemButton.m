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
@synthesize btnDelegate;
@synthesize title=_title;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _backgroundButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 4, frame.size.width-10, frame.size.height-10)];
        [_backgroundButton addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backgroundButton];
        _titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(4, 9, 30, 24)];
        _titleLabel.backgroundColor =[UIColor colorWithHex:0x80000000];
        _titleLabel.textColor=[UIColor colorWithHex:0xFFFFFFFF];
        _titleLabel.textAlignment=UITextAlignmentCenter;
        [self addSubview:_titleLabel];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
-(void)dealloc
{   
    [_titleLabel release];
    [_title release];
    if (_backgroundImage) {
        [_backgroundImage release];
    }
    
}
-(void)setInfoWithDic:(NSDictionary *)infoDic
{
    
    _titleLabel.text = [infoDic objectForKey:@"title"];
    CGSize labelSize = [self getSizeWithText:_titleLabel.text withFont:[UIFont systemFontOfSize:12]];
    _titleLabel.frame = CGRectMake(5, 9, labelSize.width+14, labelSize.height+8);
    _backgroundImage = [infoDic objectForKey:@"image"];
    [_backgroundButton setBackgroundImage:[UIImage imageNamed: [infoDic objectForKey:@"image"]] forState:UIControlStateNormal];
    _typeID = [[infoDic objectForKey:@"ID"]intValue];
    self.tag = [[infoDic objectForKey:@"ID"]intValue];
    self.title = [infoDic objectForKey:@"title"];
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
    if (btnDelegate) {
        [btnDelegate itemButtonClicked:self];
    }
}

-(CGSize)getSizeWithText:(NSString *) text withFont:(UIFont *)font
{
    CGSize size = CGSizeMake(320, CGFLOAT_MAX);
    CGSize resultSize = [text sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeTailTruncation];
    return resultSize;
}
@end

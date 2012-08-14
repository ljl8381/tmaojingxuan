//
//  TSListCell.m
//  TmallSelection
//
//  Created by ljl on 12-8-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TSListCell.h"
#import "Color+Hex.h"
//color
#define kFontBlueColor          [UIColor colorWithHex:0xFF022950]
#define kFontGrayColor          [UIColor colorWithHex:0xFF808080]
#define kColorBtnBg             [UIColor colorWithHex:0xFFF1F1F1]
#define kColorBtnTitle          [UIColor colorWithHex:0xFF858585]

@implementation TSListCell
@synthesize cellObject=_cellObject;
@synthesize iDelegate =_idelegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) 
    {
        
        _productImage = [[TSImageView alloc]initWithFrame:CGRectMake(4, 4, 252, 252)];
        _productImage.defaultFile = @"nopic.png";
        [_productImage sizeToFit];
        _productImage.center =CGPointMake(130, 130);

        self.backgroundColor = [UIColor clearColor];
        [self addSubview:_productImage];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Draw
+ (int)drawStruct:(CGPoint)point isDraw:(BOOL)draw withContent:(NSString*)content andWidth:(int)width andFont:(float)fontSize andColor:(UIColor *)color
{
    int height = 0;
    CGPoint drawPoint = CGPointMake(point.x, point.y);
    UIFont *defaultFont = [UIFont boldSystemFontOfSize:fontSize];
    if (draw) [color set];
    CGSize size;    
    // 重新计算高度
    height += size.height;    
    if (content) 
    {
        if (draw) 
        {
            size = [content drawInRect:CGRectMake(drawPoint.x, drawPoint.y, width, 32) withFont:defaultFont lineBreakMode:UILineBreakModeTailTruncation];
        }
        else
        {
            size = [content sizeWithFont:defaultFont constrainedToSize:CGSizeMake(width, 32) lineBreakMode:UILineBreakModeTailTruncation];
        }
    }
    
    if (height < size.height) height = size.height;
    
    return height;
}

- (void)drawRect:(CGRect)rect
{
    //    TRACE(@"%s --starts ",__FUNCTION__);
    [super drawRect:rect];    
    [[UIColor clearColor] set];
    UIRectFill(rect);    
    UIImage *backgroundImage = [UIImage imageNamed:@"pic_bg.png"];
    [backgroundImage drawInRect:rect];
    NSString *descriptionStr = [NSString stringWithFormat:@"这个不错的demo你看看行么不行再改啊真的可以再长点还可以再长点的谢谢...", _cellObject.description];
    // 绘画标题描述
   [[self class] drawStruct:CGPointMake(5, 260) isDraw:YES withContent:descriptionStr andWidth:252 andFont:10 andColor: [UIColor colorWithHex:0xFF4E4E4E]];
    //绘制直线
    CAShapeLayer *line =  [CAShapeLayer layer];
    CGPathRef   path = CGPathCreateWithRect(CGRectMake(5, 292, 252, 1),nil);
    line.lineWidth = 0.5f ;
    line.strokeColor = [UIColor colorWithHex:0xffd4d4d4].CGColor;
    line.fillColor = [UIColor clearColor].CGColor;
    line.path = path;
    line.lineDashPhase = 0;
    line.lineDashPattern = nil;
    CGPathRelease(path);
    [self.layer addSublayer:line];
    //绘制销量
    NSString *selloutStr = [NSString stringWithFormat:@"月销10000000件", _cellObject.sellOut];
    // 绘画标题描述
    [[self class] drawStruct:CGPointMake(5, 297) isDraw:YES withContent:selloutStr andWidth:120 andFont:12 andColor: [UIColor colorWithHex:0xFF8b8b8b]];

    //绘制价钱
    [[self class] drawStruct:CGPointMake(180, 297) isDraw:YES withContent:@"￥250" andWidth:80 andFont:10 andColor: [UIColor colorWithHex:0xFF8b8b8b]];
    CGSize size = [self getSizeWithText:@"￥250" withFont:[UIFont systemFontOfSize:10]];
    //绘制删除线
    CAShapeLayer *deletline =  [CAShapeLayer layer];
    CGPathRef   deletepath = CGPathCreateWithRect(CGRectMake(178, 303, size.width+4, 1),nil);
    deletline.lineWidth = 0.5f ;
    deletline.strokeColor = [UIColor colorWithHex:0xff8b8b8b].CGColor;
    deletline.fillColor = [UIColor clearColor].CGColor;
    deletline.path = deletepath;
    deletline.lineDashPhase = 0;
    deletline.lineDashPattern = nil;
    CGPathRelease(deletepath);
    [self.layer addSublayer:deletline];
    //绘制现价
        [[self class] drawStruct:CGPointMake(186+ size.width, 294) isDraw:YES withContent:@"￥500" andWidth:80 andFont:15 andColor: [UIColor colorWithHex:0xFF000000]];

}

-(void) cellObject:(TSCellObject *)object
{
    // TRACE(@"%s start", __FUNCTION__);
    if (_cellObject) {
        [_cellObject release];
    }
    _cellObject = [object retain];
    if (_cellObject == nil)
        return;
    _productImage.url = _cellObject.imgUrl;
    _productImage.iDelegate=self.iDelegate;
    
}
-(CGSize)getSizeWithText:(NSString *) text withFont:(UIFont *)font
{
    CGSize size = CGSizeMake(320, CGFLOAT_MAX);
    CGSize resultSize = [text sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeTailTruncation];
    return resultSize;
}

@end

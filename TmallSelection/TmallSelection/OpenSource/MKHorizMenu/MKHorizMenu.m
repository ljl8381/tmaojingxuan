//
//  MKHorizMenu.m
//  MKHorizMenuDemo
//  Created by Mugunth on 09/05/11.
//  Copyright 2011 Steinlogic. All rights reserved.
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above
//  Read my blog post at http://mk.sg/8h on how to use this code

//  As a side note on using this code, you might consider giving some credit to me by
//	1) linking my website from your app's website 
//	2) or crediting me inside the app's credits page 
//	3) or a tweet mentioning @mugunthkumar
//	4) A paypal donation to mugunth.kumar@gmail.com
//
//  A note on redistribution
//	While I'm ok with modifications to this source code, 
//	if you are re-publishing after editing, please retain the above copyright notices

#import "MKHorizMenu.h"
#import "Color+Hex.h"
#define kButtonBaseTag 10000
#define kLeftOffset -10 

@implementation MKHorizMenu

@synthesize titles = _titles;
@synthesize selectedImage = _selectedImage;

@synthesize itemSelectedDelegate;
@synthesize dataSource;
@synthesize itemCount = _itemCount;

     
-(id)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        _menuView = [[UIScrollView alloc]initWithFrame:CGRectMake(30, 0, frame.size.width-60, frame.size.height)];
        _menuView.delegate=self;
        _menuView.bounces = YES;
        _menuView.scrollEnabled = YES;
        _menuView.alwaysBounceHorizontal = YES;
        _menuView.alwaysBounceVertical = NO;
        _menuView.showsHorizontalScrollIndicator = NO;
        _menuView.showsVerticalScrollIndicator = NO;
    }
    return self;
}
-(void) reloadData
{
    self.itemCount = [dataSource numberOfItemsForMenu:self];
    self.backgroundColor = [dataSource backgroundColorForMenu:self];
    self.selectedImage = [dataSource selectedItemImageForMenu:self];
    [self addSubview:_menuView];
    UIFont *buttonFont = [UIFont systemFontOfSize:12];
    int buttonPadding = 25;
    int tag = kButtonBaseTag;    
    int xPos = kLeftOffset;
    _leftIndicator = [[UIImageView alloc]initWithFrame:CGRectMake(6, 0, 18, 31)];
    _leftIndicator.image = [UIImage imageNamed:@"nav2_icon_left.png"];
    [self addSubview:_leftIndicator];
    _leftIndicator.hidden=YES;
    _rightIndicator = [[UIImageView alloc]initWithFrame:CGRectMake(296, 0, 18, 31)];
    _rightIndicator.image = [UIImage imageNamed:@"nav2_icon_right.png"];
    [self addSubview:_rightIndicator];
    for(int i = 0 ; i < self.itemCount; i ++)
    {
        NSString *title = [dataSource horizMenu:self titleForItemAtIndex:i];
        UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [customButton setTitle:title forState:UIControlStateNormal];
        customButton.titleLabel.font = buttonFont;
        customButton.titleLabel.textAlignment = UITextAlignmentCenter;
        [customButton setTitleColor:[UIColor colorWithHex:0xffffffff] forState:UIControlStateNormal];
        [customButton setBackgroundImage:self.selectedImage forState:UIControlStateSelected];
        customButton.tag = tag++;
        [customButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        int buttonWidth = [title sizeWithFont:customButton.titleLabel.font
                            constrainedToSize:CGSizeMake(150, 28) 
                                lineBreakMode:UILineBreakModeClip].width;
        
        customButton.frame = CGRectMake(xPos, 0, buttonWidth + buttonPadding, 31);
        xPos += buttonWidth;
        xPos += buttonPadding;
        [_menuView addSubview:customButton];        
    }
    _menuView.contentSize = CGSizeMake(xPos, 31);  
    int selectIndex=0;
    switch (self.itemCount) {
        case 0:
            
            break;
        case 1:
            selectIndex=1;
            break;
        default:
            selectIndex=2;
            break;
    }
    [self setSelectedIndex:selectIndex animated:NO];
    [self layoutSubviews];  
}


-(void) setSelectedIndex:(int) index animated:(BOOL) animated
{
    UIButton *thisButton = (UIButton*) [self viewWithTag:index + kButtonBaseTag];    
    thisButton.selected = YES;
    [self buttonTapped:thisButton];
//    [_menuView setContentOffset:CGPointMake(thisButton.frame.origin.x - kLeftOffset, 0) animated:animated];
//    [self.itemSelectedDelegate horizMenu:self itemSelectedAtIndex:index];
}

-(void) buttonTapped:(id) sender
{
    UIButton *button = (UIButton*) sender;
    
    for(int i = 0; i < self.itemCount; i++)
    {
        UIButton *thisButton = (UIButton*) [_menuView viewWithTag:i + kButtonBaseTag];
        if(i + kButtonBaseTag == button.tag)
        {
            thisButton.selected = YES;
            thisButton.titleLabel.font=[UIFont systemFontOfSize:14];
        }
        else
        {
            thisButton.selected = NO;
            thisButton.titleLabel.font=[UIFont systemFontOfSize:12];
        }
    }
    
    [self.itemSelectedDelegate horizMenu:self itemSelectedAtIndex:button.tag - kButtonBaseTag];
}


- (void)dealloc
{
    [_selectedImage release];
    _selectedImage = nil;
    [_titles release];
    _titles = nil;
    
    [super dealloc];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    if (scrollView.contentOffset.x<=0) {
        _leftIndicator.hidden=YES;
    }
    else
        _leftIndicator.hidden=NO;
    TRACE(@"contentoffset.x=%f,contentsize.width =%f",scrollView.contentOffset.x,scrollView.contentSize.width );
    if (scrollView.contentOffset.x>=scrollView.contentSize.width-260) {
        _rightIndicator.hidden=YES;
    }
    else
        _rightIndicator.hidden=NO;

}
@end

//
//  FGTextView.m
//  FreeGames
//
//  Created by ljl on 12-5-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FGTextView.h"

@implementation FGTextView

@synthesize placeHolderLabel;
@synthesize placeholder;
@synthesize placeholderColor;
@synthesize backgroundImageString;

- (void)dealloc

{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];    
    [placeHolderLabel release]; 
    placeHolderLabel = nil;    
    [placeholderColor release]; 
    placeholderColor = nil;    
    [placeholder release]; 
    placeholder = nil;    
    [super dealloc];
    
}


- (void)awakeFromNib

{    
    [super awakeFromNib];    
    [self setPlaceholder:@""];    
    [self setPlaceholderColor:[UIColor lightGrayColor]];    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}


- (id)initWithFrame:(CGRect)frame

{    
    if( (self = [super initWithFrame:frame]) )
        
    {
        [self setPlaceholder:@""];        
        [self setPlaceholderColor:[UIColor lightGrayColor]];        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];        
    }
    return self;    
}


- (void)textChanged:(NSNotification *)notification

{
    if([[self placeholder] length] == 0)        
    {        
        return;    
    }
    
    if([[self text] length] == 0)        
    {        
        [[self viewWithTag:999] setAlpha:1];
    }
    
    else        
    {        
        [[self viewWithTag:999] setAlpha:0];        
    }
    
}


- (void)setText:(NSString *)text {
    
    [super setText:text];    
    [self textChanged:nil];    
}


- (void)drawRect:(CGRect)rect

{    
    if( [[self placeholder] length] > 0 )        
    {        
        if ( placeHolderLabel == nil )            
        {            
            placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,8,self.bounds.size.width - 16,0)];            
            placeHolderLabel.lineBreakMode = UILineBreakModeWordWrap;
            placeHolderLabel.numberOfLines = 0;            
            placeHolderLabel.font = self.font;            
            placeHolderLabel.backgroundColor = [UIColor clearColor];            
            placeHolderLabel.textColor = self.placeholderColor;            
            placeHolderLabel.alpha = 0;            
            placeHolderLabel.tag = 999;            
            [self addSubview:placeHolderLabel];            
        }
        placeHolderLabel.text = self.placeholder;        
        [placeHolderLabel sizeToFit];        
        [self sendSubviewToBack:placeHolderLabel];
    }   
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.bounds.size.width,self.bounds.size.height)];
    imageView.image = [UIImage imageNamed:backgroundImageString];//image_textfield_background.png
    [self insertSubview:imageView belowSubview:placeHolderLabel];
    [imageView release];
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 )        
    {
        [[self viewWithTag:999] setAlpha:1];        
    }
    [super drawRect:rect];
    
}


@end


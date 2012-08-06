//
//  FGBarButton.m
//  Created by ljl on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FGBarButton.h"
#import "Color+Hex.h"

// the default background color
#define kDefaultBackgroundColor			[UIColor clearColor]
// the disable color
#define kDisableColor                   [UIColor colorWithHex:0xFFAEAEAE]
// the counter text color
#define kCounterTextColor               [UIColor colorWithHex:0xFF377BC1]
#define kHighLightedTextColor           [UIColor colorWithHex:0xFF2D5A8F]

// the background image file
#define kDefaultImageFile				@""
// the selected background image file
#define kDefaultSelectedImageFile		@""
// the popup plugin view image filew
#define kPopupPluginViewImageFile       @""

// the popup plugin view center
#define kPupupPluginViewCenterOffsetX   -4
#define kPupupPluginViewCenterOffsetY   -25

#define kCounterViewOffsetX             0
#define kCounterViewOffsetY             -5

// the counter font size 
#define kCounterTextFontSize            15


@implementation FGBarButtonPluginView

#define kPluginTextFontSize         12

@synthesize textLabel = _textLabel;

// Create the text label
- (void)createTextLabel
{
    CGRect rect = self.frame;
    rect.origin.x = rect.origin.y = 0;
    if (!_textLabel)
    {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:kPluginTextFontSize];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:_textLabel];
    }
    _textLabel.frame = rect;
}

// Set text color
- (void)setTextColor:(UIColor*)color
{
    if (color && _textLabel)
    {
        _textLabel.textColor = color;
    }
}

// init with image
- (id)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self)
    {
        [self sizeToFit];
        [self createTextLabel];
    }
    return self;
}

// init with frame
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createTextLabel];
    }
    return self;
}

// init
- (id)init
{
    self = [super init];
    if (self)
    {
        [self createTextLabel];
    }
    return self;
}

// set the frame
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self createTextLabel];
}

- (void)dealloc
{
    [_textLabel release];
    [super dealloc];
}

@end


@implementation FGBarButton

/*
 * @synthesize
 */
@synthesize offsetX = _offsetX;
@synthesize offsetY = _offsetY;
@synthesize counterViewOffsetX = _counterViewOffsetX;
@synthesize counterViewOffsetY = _counterViewOffsetY;
@synthesize supportKeepPressed = _supportKeepPressed;
@synthesize disable = _disable;

@synthesize normalImage = _normalImage;
@synthesize highlightedImage = _highlightedImage;
@synthesize normalBackgroundImage = _normalBackgroundImage;
@synthesize highlightedBackgroundImage = _highlightedBackgroundImage;
@synthesize keepPressedBackgroundImage = _keepPressedBackgroundImage;

@synthesize normalStateColor = _normalStateColor;
@synthesize highlightedStateColor = _highlightedStateColor;


- (id)init
{
    self = [super init];
    if (self)
    {
        [self setFontSize:8 withBolded:YES];
        [self.titleLabel setShadowColor:[UIColor colorWithHex:0xAA000000]];
        [self.titleLabel setShadowOffset:CGSizeMake(0, 1)];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:kHighLightedTextColor forState:UIControlStateHighlighted];
        
    }
    return self;
}

/*
 * Response to button clicked
 */
- (void)buttonClicked
{
	if (_supportKeepPressed)
	{
		if (!_isKeepPressed)
		{
			if (_highlightedStateString)
			{
				[self setTitle:_highlightedStateString forState:UIControlStateNormal];
			}
			if (_highlightedImage)
			{
				[self setImage:_highlightedImage forState:UIControlStateNormal];
			}
            if (_keepPressedBackgroundImage)
            {
                [self setBackgroundImage:_keepPressedBackgroundImage forState:UIControlStateNormal];
            }
			else if (_highlightedBackgroundImage)
			{
				[self setBackgroundImage:_highlightedBackgroundImage forState:UIControlStateNormal];
			}
			if (_highlightedStateColor)
			{
				[self setTitleColor:_highlightedStateColor forState:UIControlStateNormal];
                if (_counterLabelView)
                {
                    [_counterLabelView setTextColor:_highlightedStateColor];
                }
			}
            
			_isKeepPressed = !_isKeepPressed;
		}
	}
	else if (_statusCount > 1)
	{
		NSUInteger index = _currentStatus * 2;
		if (index < [_statusStringArray count])
		{
			[self setTitle:[_statusStringArray objectAtIndex:index] forState:UIControlStateNormal];
		}
		index = _currentStatus * 2 + 1;
		if (index < [_statusStringArray count])
		{
			[self setTitle:[_statusStringArray objectAtIndex:index] forState:UIControlStateHighlighted];
		}
		_currentStatus++;
		_currentStatus = _currentStatus % _statusCount;
	}
}

/*
 * Reset the button pressed state
 */
- (void)resetPressedState
{
	if (_supportKeepPressed)
	{
		if (_isKeepPressed)
		{
			if (_normalStateString)
			{
				[self setTitle:_normalStateString forState:UIControlStateNormal];
			}
			if (_normalImage)
			{
				[self setImage:_normalImage forState:UIControlStateNormal];
			}
			if (_normalBackgroundImage)
			{
				[self setBackgroundImage:_normalBackgroundImage forState:UIControlStateNormal];
			}
			if (_normalStateColor)
			{
				[self setTitleColor:_normalStateColor forState:UIControlStateNormal];
			}
            if (_counterLabelView)
            {
                [_counterLabelView setTextColor:kCounterTextColor];
            }
			_isKeepPressed = !_isKeepPressed;
		}
	}
}

/*
 * Set the button pressed state
 */
- (void)setPressedState
{
	[self buttonClicked];
}


/*
 * Set normal string and highlighted string
 */
- (void)setNormalStateString:(NSString*)normalString withHighlightedStateString:(NSString*)highlightedString
{
	if (normalString)
	{
		_normalStateString = [[NSString alloc] initWithString:normalString];
		[self setTitle:_normalStateString forState:UIControlStateNormal];
	}
	if (highlightedString)
	{
		_highlightedStateString = [[NSString alloc] initWithString:highlightedString];
		[self setTitle:_highlightedStateString forState:UIControlStateHighlighted];
	}
}

/*
 * Init the class with normal string and highlighted string
 */
- (id)initWithNormalStateString:(NSString*)normalString withHighlightedStateString:(NSString*)highlightedString;
{
    self = [super init];
	if (self)
	{
		[self setNormalStateString:normalString withHighlightedStateString:highlightedString];
        //self.normalStateColor = [UIColor whiteColor];
		return self;
	}
	return nil;
}

/*
 * Init the button with status string array
 */
- (id)initWithStatusStringArray:(NSArray*)stringArray
{
    self = [super init];
	if (self)
	{
		if (stringArray)
		{
			_statusStringArray = [[NSMutableArray alloc] initWithArray:stringArray];
			_statusCount = [_statusStringArray count]/2 + [_statusStringArray count]%2;
			[self buttonClicked];
			[self addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
		}
		return self;
	}
	return nil;
}


/*
 * Set the images with normal image	and highlighted image
 */
- (void)setNormalStateImage:(UIImage*)normalStateImage withHighlightedStateImage:(UIImage*)highlightedStateImage
{
	if (normalStateImage)
	{
		[self setImage:normalStateImage forState:UIControlStateNormal];
		self.normalImage = normalStateImage;
	}
	if (highlightedStateImage)
	{
		[self setImage:highlightedStateImage forState:UIControlStateHighlighted];
		self.highlightedImage = highlightedStateImage;
	}
}

/*
 * Set the image files with normal image file and highlighted image file
 */
- (void)setNormalStateImageFile:(NSString*)normalImageFile withHighlightedStateImageFile:(NSString*)highlightedImageFile
{
	if (normalImageFile)
	{
		UIImage *normalStateImage = [[UIImage alloc] initWithContentsOfFile:[kDefaultSourcePath stringByAppendingPathComponent:normalImageFile]];
		[self setImage:normalStateImage forState:UIControlStateNormal];
		self.normalImage = normalStateImage;
		[normalStateImage release];
	}
	if (highlightedImageFile)
	{
		UIImage *highlightedStateImage = [[UIImage alloc] initWithContentsOfFile:[kDefaultSourcePath stringByAppendingPathComponent:normalImageFile]];
		[self setImage:highlightedStateImage forState:UIControlStateHighlighted];
		self.highlightedImage = highlightedStateImage;
		[highlightedStateImage release];
	}
}

/*
 * Set the background images with normal state background image	and highlighted state background image
 */
- (void)setNormalBackgroundImage:(UIImage*)normalStateBackgroundImage withHighlightedBackgroundImage:(UIImage*)highlightedStateBackgroundImage
{
	if (normalStateBackgroundImage)
	{
		[self setBackgroundImage:normalStateBackgroundImage forState:UIControlStateNormal];
		self.normalBackgroundImage = normalStateBackgroundImage;
	}
	if (highlightedStateBackgroundImage)
	{
		[self setBackgroundImage:highlightedStateBackgroundImage forState:UIControlStateHighlighted];
		self.highlightedBackgroundImage = highlightedStateBackgroundImage;
	}
	else
	{
		[self setBackgroundImage:self.normalBackgroundImage forState:UIControlStateHighlighted];
	}
    
	[self sizeToFit];
}

/*
 * Set the background images files with normal state background image file and highlighted state background image file
 */
- (void)setNormalBackgroundImageFile:(NSString*)normalBackgroundImageFile withHighlightedBackgroundImageFile:(NSString*)highlightedBackgroundImageFile
{
	if (normalBackgroundImageFile)
	{
		UIImage *normalBackgroundImageTmp = [[UIImage alloc] initWithContentsOfFile:[kDefaultSourcePath stringByAppendingPathComponent:normalBackgroundImageFile]];
		[self setBackgroundImage:normalBackgroundImageTmp forState:UIControlStateNormal];
		self.normalBackgroundImage = normalBackgroundImageTmp;
		[normalBackgroundImageTmp release];
	}
	if (highlightedBackgroundImageFile && [highlightedBackgroundImageFile length] > 1)
	{
		UIImage *highlightedBackgroundImageTmp = [[UIImage alloc] initWithContentsOfFile:[kDefaultSourcePath stringByAppendingPathComponent:highlightedBackgroundImageFile]];
		[self setBackgroundImage:highlightedBackgroundImageTmp forState:UIControlStateHighlighted];
		self.highlightedBackgroundImage = highlightedBackgroundImageTmp;
		[highlightedBackgroundImageTmp release];
	}
	else
	{
		//[self setBackgroundImage:self.normalBackgroundImage forState:UIControlStateHighlighted];
	}
	
	if (self.frame.size.width == 0 || self.frame.size.height == 0)
	{
		[self sizeToFit];
	}
}

/*
 * Set the background images with normal state background image	and highlighted state background image
 */
- (void)setFontSize:(NSUInteger)fontSize withBolded:(BOOL)supportBolded
{
	if (supportBolded)
	{
		[self.titleLabel setFont:[UIFont boldSystemFontOfSize:fontSize]];	
	}
	else
	{
		[self.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
	}
}

/*
 * Relayout the subviews
 */
- (void)layoutSubviews
{
	[super layoutSubviews];
	if (_offsetX != 0 || _offsetY != 0)
	{
		self.titleLabel.center =  CGPointMake(self.titleLabel.center.x + _offsetX, self.titleLabel.center.y + _offsetY);
	}
}

/*
 * Set whether support keep pressed(default is not support)
 */
- (void)setSupportKeepPressed:(BOOL)isSupport
{
	_supportKeepPressed = isSupport;
	if (_supportKeepPressed)
	{
		[self addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
	}
}

// Set the normal state text color and highlighted state text color
- (void)setNormalTextColor:(UIColor*)normalColor highlightedTextColor:(UIColor*)highlightedColor
{
	if (normalColor)
	{
		self.normalStateColor = normalColor;
		[self setTitleColor:normalColor forState:UIControlStateNormal];
	}
    
	if (highlightedColor)
	{
		self.highlightedStateColor = highlightedColor;
		[self setTitleColor:highlightedColor forState:UIControlStateHighlighted];
	}
    else if ( normalColor )
    {
        self.highlightedStateColor = normalColor;
        [self setTitleColor:highlightedColor forState:UIControlStateHighlighted];
    }
}

- (void)setDisable:(BOOL)disable
{
    _disable = disable;
    if (_disable)
    {
        [self setTitleColor:kDisableColor forState:UIControlStateNormal];
        self.userInteractionEnabled = NO;
    }
    else
    {
        if (_normalStateColor)
        {
            [self setTitleColor:_normalStateColor forState:UIControlStateNormal];
        }
        self.userInteractionEnabled = YES;
    }
}

// Set counter label text
- (void)setCounterLabelText:(NSString*)text
{
    if (text)
    {
        if (!_counterLabelView)
        {
            CGRect rect = self.bounds;
            rect.origin.x = _counterViewOffsetX-1;
            rect.origin.y = _counterViewOffsetY+3;
            rect.size.height = floorf(rect.size.height / 2);
            _counterLabelView = [[FGBarButtonPluginView alloc] initWithFrame:rect];
            [_counterLabelView setTextColor:kCounterTextColor];
            _counterLabelView.textLabel.font = [UIFont boldSystemFontOfSize:kCounterTextFontSize];
            [self addSubview:_counterLabelView];
        }
        _counterLabelView.textLabel.text = text;
        
    }
    else
    {
        [_counterLabelView removeFromSuperview];
        [_counterLabelView release];
        _counterLabelView = nil;
    }
}

// Set popup label text
- (void)setPopUpLabelText:(NSString*)text
{
    if (text==nil || [text length]==0) {
        if (_popupLabelView) 
        {
            [_popupLabelView removeFromSuperview];
            [_popupLabelView release];
            _popupLabelView = nil;
        }
        return;
    }
    if (_popupLabelView==nil)
    {
        _popupLabelView = [[FGBarButtonPluginView alloc] initWithImage:[UIImage imageNamed:kPopupPluginViewImageFile]];
        _popupLabelView.center = CGPointMake(self.frame.size.width + kPupupPluginViewCenterOffsetX , kPupupPluginViewCenterOffsetY);
        [_popupLabelView setTextColor:[UIColor whiteColor]];
        [self addSubview:_popupLabelView];
    }
    _popupLabelView.textLabel.text = text;
}

- (void)dealloc
{	
	[_normalImage release];
	[_highlightedImage release];
	[_normalBackgroundImage release];
	[_highlightedBackgroundImage release];
    [_keepPressedBackgroundImage release];
	
	[_statusStringArray release];
	[_normalStateString release];
	[_highlightedStateString release];
	
	[_normalStateColor release];
	[_highlightedStateColor release];
    
    [_popupLabelView release];
    [_counterLabelView release];
	
	[super dealloc];
}

@end

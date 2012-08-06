//
//  FGBarButton.h
//  My
//

#import <Foundation/Foundation.h>

/*
 * @interface FGBarButtonPluginView
 * The class PluginView for FGBarButton
 *
 */
@interface FGBarButtonPluginView : UIImageView
{
    // The text Label
    UILabel *_textLabel;
}

@property (nonatomic, readonly) UILabel *textLabel;

- (void)setTextColor:(UIColor*)color;

@end


/*
 * @interface FGBarButton
 * The class FG  button
 * Can relayout subviews
 */
@interface FGBarButton : UIButton
{
	// set the text label offset
	NSInteger _offsetX;
	NSInteger _offsetY;
	
	// set the text label string
	NSString *_normalStateString;
	NSString *_highlightedStateString;
	
	// whether support keep pressed mode(default is NO)
	BOOL _supportKeepPressed;
	BOOL _isKeepPressed;
	
	// the images of the button
	UIImage *_normalImage;
	UIImage *_highlightedImage;
	UIImage *_normalBackgroundImage;
	UIImage *_highlightedBackgroundImage;
    UIImage *_keepPressedBackgroundImage;
	
	// status count
	NSUInteger _statusCount;
	NSUInteger _currentStatus;
	// should add all the state string 
	/*
	 * Just like : [NSArray arrayWithObjects:@"status 1 normal string",
	 *										 @"status 1 highlighted string"
	 *										 @"status 2 normal string",
	 *										 @"status 2 highlighted string",
	 *										 nil]
	 */
	NSMutableArray *_statusStringArray;
	
	// Hold the normal color and the highlighted color
	UIColor *_normalStateColor;
	UIColor *_highlightedStateColor;
    
    // Disable 
    BOOL _disable;
    
    // counter Label
    FGBarButtonPluginView *_counterLabelView;
    
    // plugin view
    FGBarButtonPluginView *_popupLabelView;
    
    // Counter View offset
    NSInteger _counterViewOffsetX;
    NSInteger _counterViewOffsetY;
}

@property (nonatomic) NSInteger offsetX;
@property (nonatomic) NSInteger offsetY;
@property (nonatomic) NSInteger counterViewOffsetX;
@property (nonatomic) NSInteger counterViewOffsetY;
@property (nonatomic) BOOL supportKeepPressed;
@property (nonatomic) BOOL disable;

@property (nonatomic, retain) UIImage *normalImage;
@property (nonatomic, retain) UIImage *highlightedImage;
@property (nonatomic, retain) UIImage *normalBackgroundImage;
@property (nonatomic, retain) UIImage *highlightedBackgroundImage;
@property (nonatomic, retain) UIImage *keepPressedBackgroundImage;

@property (nonatomic, retain) UIColor *normalStateColor;
@property (nonatomic, retain) UIColor *highlightedStateColor;

// Init the button with normal string and highlighted string
- (id)initWithNormalStateString:(NSString*)normalString withHighlightedStateString:(NSString*)highlightedString;

// Init the button with status string array
- (id)initWithStatusStringArray:(NSArray*)stringArray;

// Set the images with normal image	and highlighted image
- (void)setNormalStateImage:(UIImage*)normalStateImage withHighlightedStateImage:(UIImage*)highlightedStateImage;

// Set the image files with normal image file and highlighted image file
- (void)setNormalStateImageFile:(NSString*)normalImageFile withHighlightedStateImageFile:(NSString*)highlightedImageFile;

// Set the background images with normal state background image	and highlighted state background image
- (void)setNormalBackgroundImage:(UIImage*)normalStateBackgroundImage withHighlightedBackgroundImage:(UIImage*)highlightedStateBackgroundImage;

// Set the background images files with normal state background image file and highlighted state background image file
- (void)setNormalBackgroundImageFile:(NSString*)normalBackgroundImageFile withHighlightedBackgroundImageFile:(NSString*)highlightedBackgroundImageFile;

// Reset the button pressed state
- (void)resetPressedState;

// Set the button pressed state
- (void)setPressedState;

// Set the background images with normal state background image	and highlighted state background image
- (void)setFontSize:(NSUInteger)fontSize withBolded:(BOOL)supportBolded;

// Set the normal state text color and highlighted state text color
- (void)setNormalTextColor:(UIColor*)normalColor highlightedTextColor:(UIColor*)highlightedColor;

// Set normal string and highlighted string
- (void)setNormalStateString:(NSString*)normalString withHighlightedStateString:(NSString*)highlightedString;

// Set counter label text
- (void)setCounterLabelText:(NSString*)text;

// Set Popup label text
- (void)setPopUpLabelText:(NSString*)text;

@end

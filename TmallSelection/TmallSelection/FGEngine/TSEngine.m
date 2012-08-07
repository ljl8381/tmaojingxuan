//
//  FGEngine.m
//  FreeGames
//
//  Created by ljl on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TSEngine.h"
#import "FGBarButton.h"
#import "Color+Hex.h"
#import "TmallSelectionViewController.h"
#import "BeautySelectionViewController.h"
#import "MyCollectionViewController.h"
#import "BrandViewController.h"

#define kTabButtonFontSize				8
#define kTabButtonTitleOffsetY			18
#define kTabButtonOffsetX				0
#define kTabButtonOffsetY				-10
#define kTabButtonFontColor				0xFF828282
#define kTabButtonFontHighlightColor	0xFFFFFFFF

#define kTabBarVCenter					20
#define kDefaultTabBarheight			60
#define kDefaultNaviBarheight			60
#define kDefaultApplicationScreenheight 460


@implementation TSEngine


@synthesize tsTabController = _tsTabController;

- (id)init
{
    self = [super init];
    if (self)
    {
        _tsTabController = [[TabController alloc]init];
        _tsTabController.fgDataSource=self;
        _tsTabController.fgDelegate =self;
        _fgHttpObject = [[TSHttpObject alloc]init];
        _fgHttpObject.gDelegate = self;
    }
    
    return self;
    
}


- (void)dealloc
{
	[super dealloc];
}

#pragma mark - TabVCDataSource

/*
 * Create the tab bar button array
 */
- (void)creatTabButtonWithButtonArray:(NSMutableArray *)buttonsArray

{   
    NSArray *imageArray = [NSArray arrayWithObjects:
                           NSLocalizedString(@"TabbarSuggestionButtonImage", nil),
                           NSLocalizedString(@"TabbarSuggestionButtonImageHilight", nil),
                           NSLocalizedString(@"TabbarAlbumButtonImage", nil), 
                           NSLocalizedString(@"TabbarAlbumButtonImageHilight", nil), 
                           NSLocalizedString(@"TabbarFreeButtonImage", nil),
                           NSLocalizedString(@"TabbarFreeButtonImageHilight", nil), 
                           NSLocalizedString(@"TabbarCategoryButtonImage", nil),
                           NSLocalizedString(@"TabbarCategoryButtonImageHilight", nil),
                           nil];
    NSArray *array = [[NSArray alloc] initWithObjects:NSLocalizedString(@"Suggestion", nil),NSLocalizedString(@"Album", nil), NSLocalizedString(@"Free", nil), NSLocalizedString(@"Category", nil), nil];    
    NSUInteger arrayCount = [imageArray count]/2 + [imageArray count]%2;
    
    for (int i = 0; i < arrayCount; ++i)
    {
        // Create the tab bar button (with title)
        FGBarButton *tabButton = [[[FGBarButton alloc] 
                                   initWithNormalStateString: [array objectAtIndex:i] withHighlightedStateString:nil] autorelease];		
        // Set the title string color
        tabButton.offsetY = kTabButtonTitleOffsetY;
        [tabButton setNormalTextColor:[UIColor  colorWithHex:kTabButtonFontColor] highlightedTextColor:[UIColor  colorWithHex:kTabButtonFontHighlightColor] ];
        [tabButton setTitleShadowColor:[UIColor colorWithHex:0x80808] forState:UIControlStateNormal];
        // Set the title string and font size
        [tabButton setFontSize:kTabButtonFontSize withBolded:YES];
        
        // Set the tag to separate the buttons
        tabButton.tag = i;
        
        // Set the keep pressed mode
        tabButton.supportKeepPressed = YES;
        
        // Set the background images 
        NSString *normalBackgroundImageFile = nil;
        NSString *highlightedBackgroundImageFile = nil;
        
        // Get the normal state backgournd image file 
        NSUInteger index = i*2;
        if (index < [imageArray count])
        {
            normalBackgroundImageFile = [imageArray objectAtIndex:index];
        }
        
        // Get the highlighted background image file
        index = i*2+1;
        if (i*2+1 < [imageArray count])
        {
            highlightedBackgroundImageFile = [imageArray objectAtIndex:index];
        }
        
        // Set the background images
        [tabButton setNormalBackgroundImageFile:normalBackgroundImageFile withHighlightedBackgroundImageFile:highlightedBackgroundImageFile];
        
        // Get the button width
        NSUInteger buttonWidth = 80;
        
        
        // Reset the button frame
        CGRect rect = tabButton.frame;
        rect.origin.x = i*buttonWidth;
        tabButton.frame = rect;
        
        CGPoint btnCenterPoint = tabButton.center;
        btnCenterPoint.y = kTabBarVCenter;
        tabButton.center = btnCenterPoint;
        
        [buttonsArray addObject:tabButton];
    }
    [array release];
}

- (void)loadTabBarViewControllers:(NSMutableArray *)controllersArray
{
    TRACE(@"begin");
    //品牌特卖
	BrandViewController *brandViewController=[[BrandViewController alloc] init];
//    mainViewController.gDelegate = self;
//    mainViewController.srDelegate = self;
    [controllersArray addObject:brandViewController];
    [brandViewController release];
    
    TmallSelectionViewController *tmallSelectionViewController=[[TmallSelectionViewController alloc] init];
    //    mainViewController.gDelegate = self;
    //    mainViewController.srDelegate = self;
    [controllersArray addObject:tmallSelectionViewController];
    [tmallSelectionViewController release];

    BeautySelectionViewController *beautySelectionViewController=[[BeautySelectionViewController alloc] init];
    //    mainViewController.gDelegate = self;
    //    mainViewController.srDelegate = self;
    [controllersArray addObject:beautySelectionViewController];
    [beautySelectionViewController release];

    MyCollectionViewController *myCollectionViewController=[[MyCollectionViewController alloc] init];
    //    mainViewController.gDelegate = self;
    //    mainViewController.srDelegate = self;
    [controllersArray addObject:myCollectionViewController];
    [myCollectionViewController release];


    
}
//取消之前请求
-(void)removeRequest:(request_Type)type
{
    [_fgHttpObject removeRequest:type];
}


@end

//
//  FGEngine.m
//  FreeGames
//
//  Created by ljl on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TSEngine.h"
#import "AlbumViewController.h"
#import "CategoryViewController.h"
#import "FreeViewController.h"
#import "GameDetailView.h"
#import "FGBarButton.h"
#import "Color+Hex.h"
#import "ShareViewController.h"
#import "SHKItem.h"
#import "SHKRenRen.h"
#import "SHKSina.h"
#import "SHKTencent.h"
#import "Flurry.h"


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

@synthesize fgTabController = _fgTabController;

- (id)init
{
    self = [super init];
    if (self)
    {
        _fgTabController = [[TabController alloc]init];
        _fgTabController.fgDataSource=self;
        _fgTabController.fgDelegate =self;
        _fgHttpObject = [[TSHttpObject alloc]init];
        _fgHttpObject.gDelegate = self;
    }
    
    return self;
    
}


- (void)dealloc
{
    [_mainController release];
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
                           NSLocalizedString(@"TabbarMoreButtonImage", nil),
                           NSLocalizedString(@"TabbarMoreButtonImageHilight", nil), 
                           nil];
    NSArray *array = [[NSArray alloc] initWithObjects:NSLocalizedString(@"Suggestion", nil),NSLocalizedString(@"Album", nil), NSLocalizedString(@"Free", nil), NSLocalizedString(@"Category", nil), NSLocalizedString(@"More", nil), nil];    
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
        NSUInteger buttonWidth = tabButton.frame.size.width;
        
        
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
    //首页
	MainViewController *mainViewController=[[MainViewController alloc] init];
    mainViewController.gDelegate = self;
    mainViewController.srDelegate = self;
    [controllersArray addObject:mainViewController];
    _mainController =[mainViewController retain];
    [mainViewController release];
  
    
    //专辑
	AlbumViewController *albumViewController=[[AlbumViewController alloc] init];
    albumViewController.alDelegate = self;
    albumViewController.srDelegate = self;
    [controllersArray addObject:albumViewController];
    [albumViewController release];
    
    
    //热门限免
    FreeViewController *freeViewController=[[FreeViewController alloc] init];
    freeViewController.fDelegate = self;
    freeViewController.srDelegate = self;
    [controllersArray addObject:freeViewController];
    [freeViewController release];
    
    //个人主页
    CategoryViewController *categoryViewController=[[CategoryViewController alloc] init];
    categoryViewController.gDelegate = self;
    categoryViewController.srDelegate = self;
    [controllersArray addObject:categoryViewController];
    [categoryViewController release];
    
    //更多
    MoreViewController *moreViewController=[[MoreViewController alloc] init];
    moreViewController.gDelegate = self;
    [controllersArray addObject:moreViewController];
    [moreViewController release];
    
}
//跳转到搜索页面
- (void)showSearchPage:(UIViewController *)aViewController{
    
    TRACE(@"跳转到搜索页面");
    [self reportEvent:@"首跳转到搜索页" withParameters:nil];
    SearchViewController *_searchPageController  = [[SearchViewController alloc]init];
    _searchPageController.sDelegate = self;
    [aViewController.navigationController  pushViewController:_searchPageController animated:YES]; 
    [_searchPageController release];
}

//跳转到详细页面
- (void)showDetialPage:(UIViewController *)supperViewController WithObjc:(FGCellObject *)clObjc
{

    TRACE(@"跳转到详细页面,supperViewcontroller=%@",[supperViewController class]);
    [self reportEvent:[NSString stringWithFormat:@"%@页跳转到详情",[supperViewController class]] withParameters:nil];
    GameDetailView *_gameDetialView = [[GameDetailView alloc]init];
    _gameDetialView.clObjc = clObjc;
    TRACE(@"==========下载地址%@",clObjc.gameUrl);
    _gameDetialView.navigationItem.hidesBackButton = NO;
    _gameDetialView.dDelegate = self;
    [supperViewController.navigationController pushViewController:_gameDetialView animated:YES];
    [_gameDetialView release];
    //请求详细页数据  
     TRACE(@"clObjc.gameID=%i", clObjc.gameID);
    [_fgHttpObject requestDetialPageData:[NSString stringWithFormat:@"%i", clObjc.gameID]];
}
//分享到不同微博
- (void)shareGame:(UIViewController *)supperViewController andIndex:(NSInteger)buttonIndex gameObject:(FGDetialPageObject *)dtlDataObjc
{
    ShareViewController *shareView = [[ShareViewController alloc]init];
    shareView.gDelegate = self;
    shareView.index = buttonIndex;
    shareView.gameUrl = dtlDataObjc.dtlGameDownLoadURL;
    shareView.gameName = dtlDataObjc.dtlGameName;
    [supperViewController.navigationController pushViewController:shareView animated:YES];
    [shareView release];

}

 -(void)shareGame:(NSInteger)index andText:(NSString *)text
{
    SHKItem *item =  [SHKItem text:text];
    switch (index)
    {
        case renren_net:
        {
            [SHKRenRen shareItem:item];
        }
            break;
        case sina_webo:
        {
            [SHKSina shareItem:item];
        }
            break;
        case tencent_weibo:
        {
            [SHKTencent shareItem:item];
        }
            break;
        default:
            break;
    }

}

//跳转到iTunes下载页面并报告下载事件
- (void)ToDownLoadPage:(NSString *)urlString withID:(NSString *)gameID
{
    TRACE(@"跳转到iTunes下载页面%@",urlString);
    if(urlString)
    {
        
        NSURL *downloadUrl =[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        if(downloadUrl && [[UIApplication sharedApplication] canOpenURL:downloadUrl])
        {
            [[UIApplication sharedApplication] openURL:downloadUrl];
            TRACE(@"跳转到iTunes下载页面");

        }
    }
    if (gameID) {
        TRACE(@"报告下载事件");
        [self reportEvent:@"跳转到itunes" withParameters:nil];
        [_fgHttpObject reportDownloadAction:gameID];
    }
}
//回退到主页面
- (void)BackToHomePage:(UIViewController *)viewController
{
    [self reportEvent:[NSString stringWithFormat:@"%@页跳回到主页",[viewController class]] withParameters:nil];
    [viewController.navigationController popToRootViewControllerAnimated:YES];
    
}

//评价游戏
- (void)evaluateTheGame:(BOOL)goodOrBadEvalute withGameId:(NSString *)gameId
{
    
    [_fgHttpObject evaluateTheGame:goodOrBadEvalute withGameId:gameId];
}

//取消之前请求
-(void)removeRequest:(request_Type)type
{
    [_fgHttpObject removeRequest:type];
}

-(void)reportEvent:(NSString *)event withParameters:(NSDictionary *)paraDic
{
#ifdef DATA_ANALYZE_OPEN
    [Flurry logEvent:event withParameters:paraDic];
#endif
}

@end

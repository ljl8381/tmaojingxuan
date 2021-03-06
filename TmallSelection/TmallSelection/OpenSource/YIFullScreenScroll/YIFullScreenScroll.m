//
//  YIFullScreenScroll.m
//  YIFullScreenScroll
//
//  Created by Yasuhiro Inami on 12/06/03.
//  Copyright (c) 2012 Yasuhiro Inami. All rights reserved.
//

#import "YIFullScreenScroll.h"
#import "UIView+YIFullScreenScroll.h"

#define IS_PORTRAIT         UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)
#define STATUS_BAR_HEIGHT   (IS_PORTRAIT ? [UIApplication sharedApplication].statusBarFrame.size.height : [UIApplication sharedApplication].statusBarFrame.size.width)

#define MIN_SCROLL_DISTANCE_FOR_FULLSCREEN  44

@implementation YIFullScreenScroll

@synthesize viewController = _viewController;
@synthesize enabled = _enabled;
@synthesize shouldShowUIBarsOnScrollUp = _shouldShowUIBarsOnScrollUp;

- (id)initWithViewController:(UIViewController*)viewController
{
    self = [super init];
    if (self) {
        self.enabled = YES;
        self.shouldShowUIBarsOnScrollUp = YES;
       // viewController.navigationController.navigationBar.translucent = YES;
        viewController.navigationController.toolbar.translucent = YES;
        _viewController = viewController;
    }
    return self;
}

- (void)_layoutWithScrollView:(UIScrollView*)scrollView deltaY:(CGFloat)deltaY
{
    TRACE(@"deltaY=%f", deltaY);
//    if (deltaY>0) {
//        _viewController.navigationController.navigationBar.translucent = YES;
//    }
//    else if (deltaY<-40)
//    {
//        _viewController.navigationController.navigationBar.translucent = NO;
//    }
   // _viewController.navigationController.navigationBar.translucent = YES;
    
    if (!self.enabled) 
        return;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    // navbar
    UINavigationBar* navBar = _viewController.navigationController.navigationBar;
    BOOL isNavBarExisting = navBar && navBar.superview && !navBar.hidden;
    if (isNavBarExisting) {
        float i= MIN(MAX(navBar.top-deltaY, STATUS_BAR_HEIGHT-navBar.height), STATUS_BAR_HEIGHT);
       // NSLog(@"navi=%f",i);
        i=1;
//        if (deltaY<=0) {
//            navBar.top = 20;
//             _viewController.navigationController.navigationBar.translucent = NO;
//        }
//        else
//        {
//            navBar.top = -25;
//            _viewController.navigationController.navigationBar.translucent = YES;
//        }
       // NSLog(@"navi=%f",navBar.top);
    }
    
    // toolbar
    UIToolbar* toolbar = _viewController.navigationController.toolbar;
    BOOL isToolbarExisting = toolbar && toolbar.superview && !toolbar.hidden;
    CGFloat toolbarSuperviewHeight = 0;
    if (isToolbarExisting) {
        // NOTE: if navC.view.superview == window, navC.view won't change its frame and only rotate-transform
        if ([toolbar.superview.superview isKindOfClass:[UIWindow class]]) {
            toolbarSuperviewHeight = IS_PORTRAIT ? toolbar.superview.height : toolbar.superview.width;
        }
        else {
            toolbarSuperviewHeight = toolbar.superview.height;
        }
        toolbar.top = MIN(MAX(toolbar.top+deltaY, toolbarSuperviewHeight-toolbar.height), toolbarSuperviewHeight);
    }
    
    // tabBar
    UITabBar* tabBar = _viewController.tabBarController.tabBar;
    BOOL isTabBarExisting = tabBar && tabBar.superview && !tabBar.hidden && (tabBar.left == 0);
    CGFloat tabBarSuperviewHeight = 0;
    if (isTabBarExisting) {
        if ([tabBar.superview.superview isKindOfClass:[UIWindow class]]) {
            tabBarSuperviewHeight = IS_PORTRAIT ? tabBar.superview.height : tabBar.superview.width;
        }
        else {
            tabBarSuperviewHeight = tabBar.superview.height;
        }
        tabBar.top = MIN(MAX(tabBar.top+deltaY, tabBarSuperviewHeight-tabBar.height), tabBarSuperviewHeight);
    }
    UITabBarController *tabcontroller =  _viewController.tabBarController;
    if (tabcontroller&&isNavBarExisting) {
        UIView *tab =  [tabcontroller.view viewWithTag:1001];
        if (deltaY<=0) {
            navBar.top = 20;
            _viewController.navigationController.navigationBar.translucent = NO;
            tab.top=373;
        }
        else
        {
            navBar.top = -25;
            tab.top=480;
            _viewController.navigationController.navigationBar.translucent = YES;
        }

        
    }
    
    
    [UIView commitAnimations];
    // scrollIndicatorInsets
//    UIEdgeInsets insets = scrollView.scrollIndicatorInsets;
//    if (isNavBarExisting) {
//        insets.top = navBar.bottom-STATUS_BAR_HEIGHT;
//    }
//    insets.bottom = 0;
//    if (isToolbarExisting) {
//        insets.bottom += toolbarSuperviewHeight-toolbar.top;
//    }
//    if (tabcontroller) {
//        insets.bottom += tabBarSuperviewHeight-tabView.top;
//    }
//    scrollView.scrollIndicatorInsets = insets;
}

#pragma mark -

- (void)layoutTabBarController
{
    if (_viewController.tabBarController) {
        UIView* tabBarTransitionView = [_viewController.tabBarController.view.subviews objectAtIndex:0];
        tabBarTransitionView.frame = _viewController.tabBarController.view.bounds;
    }
}

- (void)showUIBarsWithScrollView:(UIScrollView*)scrollView animated:(BOOL)animated
{
    [UIView animateWithDuration:(animated ? 0.1 : 0) animations:^{
        [self _layoutWithScrollView:scrollView deltaY:-46];
    }];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _prevContentOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.dragging || _isScrollingTop) {
        CGFloat deltaY = scrollView.contentOffset.y-_prevContentOffsetY;
        _prevContentOffsetY = MAX(scrollView.contentOffset.y, -scrollView.contentInset.top);
        
        if (!self.shouldShowUIBarsOnScrollUp && deltaY < 0 && scrollView.contentOffset.y > 0 && !_isScrollingTop) {
            deltaY = abs(deltaY);
        }
        
        [self _layoutWithScrollView:scrollView deltaY:deltaY];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    _prevContentOffsetY = scrollView.contentOffset.y;
    _isScrollingTop = YES;
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    _isScrollingTop = NO;
}

@end

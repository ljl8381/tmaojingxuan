//
//  TSRViewController.m
//  TmallSelection
//
//  Created by ljl on 12-8-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TSRViewController.h"
#import "UIView+YIFullScreenScroll.h"

@implementation TSRViewController

// Hide the original navi return button
- (void)hideOriNaviReturnBtn
{
	// Hide the return btn
	UIView *tmpView = [[UIView alloc] initWithFrame:CGRectZero];
	UIBarButtonItem *backItem = [[[UIBarButtonItem alloc] initWithCustomView:tmpView] autorelease];
	self.navigationItem.leftBarButtonItem = backItem;
	[tmpView release];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// This method should be invoke when the view will appear
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideOriNaviReturnBtn];
    if (self.toolbarItems.count == 0) {
        [self.navigationController setToolbarHidden:YES animated:animated];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.toolbarItems.count > 0) {
        [self.navigationController setToolbarHidden:NO animated:animated];
    }
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];

    self.navigationController.title = @"nimei";
    // viewController.navigationController.navigationBar.translucent = YES;
    self.navigationController.toolbar.translucent = YES;
}


/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 }
 */
-(void)dealloc
{

    [super dealloc];
    
}

// This method should be invoke when the view will disappear
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)backButtonClicked
{
	[self.navigationController popViewControllerAnimated:YES];
}


- (NSString *) splitTitle:(NSString *)Word

{
    
    NSMutableString *Temp = [[[NSMutableString alloc] init] autorelease];
    
    [Temp appendFormat:[Word substringWithRange:NSMakeRange(10, 1)]];        
    [Temp appendFormat:@"\n"];    
    return Temp;
    
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{ 
    TRACE("contentoffset=%f,contentinset=%f", scrollView.contentOffset.y,scrollView.contentInset.top);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    UINavigationBar* navBar = self.navigationController.navigationBar;
    BOOL isNavBarExisting = navBar && navBar.superview && !navBar.hidden;
    if (isNavBarExisting) {
        if (scrollView.dragging&&scrollView.contentOffset.y>0) {
            self.navigationController.navigationBar.translucent = YES;
            navBar.top = -25;
        }
        else if (scrollView.dragging)
        {
            self.navigationController.navigationBar.translucent = NO;
            navBar.top=20;
        }
    }
    UITabBarController *tabcontroller =  self.tabBarController;
    if (tabcontroller) {
        UIView *tab =  [tabcontroller.view viewWithTag:1001];
        if (scrollView.dragging&&scrollView.contentOffset.y>0) {
            tab.top = 480;
        }
        else
            tab.top = 373;
        }
    [UIView commitAnimations];
}

@end

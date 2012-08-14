//
//  TSDetailViewController.m
//  TmallSelection
//
//  Created by ljl on 12-8-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TSDetailViewController.h"

@implementation TSDetailViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // self.navigationItem.title = @"品牌特卖";
    }
    return self;
}

-(void)loadView
{
    
    [super loadView];
    self.navigationItem.title = @"";
    _imgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 41, 272, 322)];
    _imgScrollView.pagingEnabled = YES;
    _imgScrollView.clipsToBounds = NO;
    _imgScrollView.contentSize = CGSizeMake(_imgScrollView.frame.size.width * 20, _imgScrollView.frame.size.height);
    _imgScrollView.showsHorizontalScrollIndicator = NO;
    _imgScrollView.showsVerticalScrollIndicator = NO;
    _imgScrollView.scrollsToTop = NO;
    _imgScrollView.delegate =self;
    [self.view addSubview:_imgScrollView];
    [_imgScrollView setContentOffset:CGPointMake(0, 0)];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _backButton.hidden =NO;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _fullScreenDelegate.enabled =NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark Scorllview delegate 
- (void)loadScrollViewWithPage:(int)page {
	int kNumberOfPages = 20;
	
    if (page < 0) {
        return;
    }
    if (page >= kNumberOfPages) {
        return;
    }
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView 

{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (page < 0 || page >= 5) {
        return;
    }
    _listControl.currentPage = page;
    if (pageControlUsed) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _listControl.currentPage = page;
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    currentPage = page;
    pageControlUsed = NO;
}

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view 
{ 
    return YES; 
} 
- (BOOL)touchesShouldCancelInContentView:(UIView *)view 
{ 
    
    return NO; 
} 

#pragma mark imageClick delegate 
-(void)imageSingleTap:(TSImageView *)sender
{
    
    
}

@end

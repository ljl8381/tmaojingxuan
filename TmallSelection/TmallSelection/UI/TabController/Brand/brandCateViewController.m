//
//  brandCateViewController.m
//  TmallSelection
//
//  Created by ljl on 12-8-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "brandCateViewController.h"
#import "TSListCell.h"
#import "TSDetailViewController.h"

@implementation brandCateViewController
@synthesize title;
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
    self.navigationItem.title = title;
    _horizMenu = [[MKHorizMenu alloc]initWithFrame:CGRectMake(0, 0, 320, 31)];
    _horizMenu.itemSelectedDelegate = self;
    _horizMenu.dataSource=self;
    [_horizMenu reloadData];
    [self.view addSubview:_horizMenu];
    _listView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 41, 272, 322)];
    _listView.pagingEnabled = YES;
    _listView.clipsToBounds = NO;
    _listView.contentSize = CGSizeMake(_listView.frame.size.width * 20, _listView.frame.size.height);
    _listView.showsHorizontalScrollIndicator = NO;
    _listView.showsVerticalScrollIndicator = NO;
    _listView.scrollsToTop = NO;
    _listView.delegate =self;
    for (int i=0; i<20; i++) {
    TSListCell *testcell = [[TSListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    testcell.iDelegate=self;
    testcell.frame = CGRectMake(32+272*i, 0, 262, 322);
    [_listView addSubview:testcell];
    [testcell release];
    }
    _listControl.numberOfPages = 20;
    _listControl.currentPage = 0;
    _listControl.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_listView];
    [_listView setContentOffset:CGPointMake(0, 0)];
    _collectionButton = [[UIButton alloc]initWithFrame:CGRectMake(80, 373, 161, 34)];
    [_collectionButton setTitle:@"收藏宝贝" forState:UIControlStateNormal];
    [_collectionButton setBackgroundImage:[[UIImage imageNamed:@"yellow_button.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [_collectionButton setBackgroundImage:[[UIImage imageNamed:@"yellow_button_press.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateHighlighted];
    [_collectionButton addTarget:self action:@selector(collectionButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_collectionButton];
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

#pragma mark -
#pragma mark HorizMenu Data Source
- (UIImage*) selectedItemImageForMenu:(MKHorizMenu*) tabMenu
{
    return [[UIImage imageNamed:@"ButtonSelected"] stretchableImageWithLeftCapWidth:16 topCapHeight:0];
}

- (UIColor*) backgroundColorForMenu:(MKHorizMenu *)tabView
{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav2_bg.png"]];
}

- (int) numberOfItemsForMenu:(MKHorizMenu *)tabView
{
    return 12;//[subCateArray count];
}

- (NSString*) horizMenu:(MKHorizMenu *)horizMenu titleForItemAtIndex:(NSUInteger)index
{
    return @"aa"; //[subCateArray objectAtIndex:index];
}

#pragma mark -
#pragma mark HorizMenu Delegate
-(void) horizMenu:(MKHorizMenu *)horizMenu itemSelectedAtIndex:(NSUInteger)index
{        
    //self.selectionItemLabel.text = [self.items objectAtIndex:index];
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
    TSDetailViewController *detailView = [[TSDetailViewController alloc]init];
    [self.navigationController pushViewController:detailView animated:YES];
    [detailView release];

}


-(void)collectionButtonClicked
{


}
@end

//
//  BrandViewController.m
//  TmallSelection
//
//  Created by ljl on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BrandViewController.h"

@interface BrandViewController ()

@end

@implementation BrandViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"品牌特卖";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UITableView  *set = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    set.delegate=self;
    set.dataSource = self;
    if (!_refreshHeaderView ) 
    {  
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0-set.bounds.size.height, self.view.frame.size.width, set.bounds.size.height)];  
        _refreshHeaderView.delegate = self;  
        _refreshHeaderView.backgroundColor = [UIColor clearColor];

    }  
    [_refreshHeaderView refreshLastUpdatedDate];  
    [set addSubview:_refreshHeaderView];
    self.view = set;
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

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] init] autorelease];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }

    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"%d-%d (%d)",indexPath.section,indexPath.row,arc4random()];
    
    return cell;
}
#pragma mark -  
#pragma mark Data Source Loading / Reloading Methods  

- (void)reloadTableViewDataSource{  
    _reloading = YES;  
}  

- (void)doneLoadingTableViewData{  
    
    //  model should call this when its done loading  
    _reloading = NO;  
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.view];  
}  

#pragma mark -  
#pragma mark UIScrollViewDelegate Methods  

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{  
    [super scrollViewDidScroll:scrollView];
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView]; 
}  

#pragma mark -  
#pragma mark EGORefreshTableHeaderDelegate Methods  

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{  
    
    [self reloadTableViewDataSource];
    //[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];  
}  

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{  
    
    return _reloading; // should return if data source model is reloading  
    
}  

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{  
    
    return [NSDate date]; // should return date data source was last changed  
    
}  

@end

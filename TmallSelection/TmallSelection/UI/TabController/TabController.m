//
//  TabController.m
//  Gmob
//
//  Created by jinglei li on 12-5-14.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "TabController.h"
#import "FGBarButton.h"
#import "Color+Hex.h"


#define kDefaultTabBarheight			60

@implementation TabController
@synthesize fgDelegate = _fgDelegate;
@synthesize fgDataSource = _fgDataSource;
@synthesize buttonsArray =_buttonsArray;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _buttonsArray =  [[NSMutableArray alloc] initWithCapacity:5];
        self.tabBar.hidden = YES;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [_buttonsArray release];
    [_backgroundImageView release];
	[super dealloc];
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    self.view.frame = FULL_SIZE;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    TRACE(@"%d", [self.viewControllers count]);
    //保证只加载一次
    if ([self.viewControllers count]) 
    {
        return;
    }
    
    NSMutableArray *controllersArray = [[NSMutableArray alloc] initWithCapacity:4];
    
    
    // Create the background image view
    _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 366, SCREEN_WIDTH, 46)];
    _backgroundImageView.backgroundColor = [UIColor clearColor];
	_backgroundImageView.userInteractionEnabled = YES;
    _backgroundImageView.tag = 1001;
	// Add the background view to window
	[self.view addSubview:_backgroundImageView];
    
	if (_fgDataSource)
    {
        [_fgDataSource creatTabButtonWithButtonArray:_buttonsArray];
        [_fgDataSource loadTabBarViewControllers:controllersArray];
    }
    self.viewControllers = controllersArray;
    self.selectedIndex = PAGE_MAIN;	
	[controllersArray release];
    
    for (int i=0; i<[_buttonsArray count]; i++) {
        
        [[_buttonsArray objectAtIndex:i] addTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_backgroundImageView addSubview:[_buttonsArray objectAtIndex:i] ];
    }
    [[_buttonsArray objectAtIndex:0]setPressedState];
    
}

- (void)setSelectedIndex:(NSUInteger)value
{
    int numVCS=[self.viewControllers count];
    if (value<numVCS)
    {
        super.selectedIndex = value;
        //将当前子视图的导航栏各项设置到选项卡视图导航栏
        UIViewController *vcSelected = [self.viewControllers objectAtIndex:value];
        [self performSelector:@selector(tabBarController:didSelectViewController:) withObject:self withObject:vcSelected]; 
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



/*
 * Tab button clicked
 */
- (void)tabButtonClicked:(id)sender
{
    
    FGBarButton *selectedButton = (FGBarButton*)sender;
	for ( int i = 0; i < [_buttonsArray count]; i++)
	{
		if (i != selectedButton.tag)
		{
			FGBarButton *button = [_buttonsArray objectAtIndex:i];
			[button resetPressedState];
		}
	}	
    self.selectedIndex = selectedButton.tag;
    
}
#pragma mark -
#pragma mark UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
	self.navigationItem.title = viewController.navigationItem.title;
	self.navigationItem.titleView = viewController.navigationItem.titleView;
    //	self.navigationItem.leftBarButtonItem = viewController.navigationItem.leftBarButtonItem;
	self.navigationItem.rightBarButtonItem = viewController.navigationItem.rightBarButtonItem; 
    //    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"image_bot_n4_cur.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.backBarButtonItem =  viewController.navigationItem.backBarButtonItem;
}

@end
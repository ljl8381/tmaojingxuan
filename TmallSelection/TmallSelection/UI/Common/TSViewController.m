//
//  FGViewController.m
//  FreeGames
//
//  Created by ljl on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import "TSViewController.h"
#import "Color+Hex.h"
@implementation TSViewController

@synthesize backButton=_backButton;

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
    [self.navigationController.navigationBar addSubview:_backButton];

}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    if(!_backButton)
    {
        _backButton = [FGBarButton buttonWithType:UIButtonTypeCustom];
        [_backButton setFrame:CGRectMake(0, 0,50, 44)];
        [_backButton setNormalBackgroundImage: [UIImage imageNamed:@"images_icon_back.png"]withHighlightedBackgroundImage:[UIImage imageNamed:@"images_icon_back_pressed.png"]];
        [_backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_backButton retain];
        _backButton.hidden = YES;
        //[self.navigationController.navigationBar addSubview:_backButton];
    }
    _errorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _errorButton.frame = CGRectMake(0, 60, self.view.bounds.size.width, self.view.bounds.size.height);
    _errorButton.backgroundColor = [UIColor clearColor];
     UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 90, 150, 80)];
    titleLabel.numberOfLines = 0;
    titleLabel.text =  @"同学，你的网络不给力 请点击屏幕重新加载~";
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithHex:0xff666666];
    titleLabel.font =[UIFont boldSystemFontOfSize:14];
    titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    titleLabel.shadowColor = [UIColor colorWithHex:0xffffffff];
    titleLabel.shadowOffset =CGSizeMake(0, 1);
    titleLabel.userInteractionEnabled=NO;
    titleLabel.tag = 900;
    titleLabel.backgroundColor = [UIColor clearColor];
    [_errorButton addSubview:titleLabel];
    [titleLabel release];
    [_errorButton addTarget:self action:@selector(reloadNetwork) forControlEvents:UIControlEventTouchUpInside];
    [_errorButton retain];
    _errorButton.hidden = YES;
    UIImageView  *backgroundImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backgroundImageView.image = [UIImage imageNamed:@"images_body_background.png"];
    [self.view addSubview:backgroundImageView];
    [backgroundImageView release];
    
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
     [_errorButton release];
     [_backButton release];
     [super dealloc];
     
 }

// This method should be invoke when the view will disappear
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_backButton removeFromSuperview];
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
    
    _fullScreenDelegate = [[YIFullScreenScroll alloc] initWithViewController:self];
    _fullScreenDelegate.shouldShowUIBarsOnScrollUp = YES;
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

-(void)reloadNetwork

{
    _errorButton.hidden = YES;
}

- (NSString *) splitTitle:(NSString *)Word

{
    
    NSMutableString *Temp = [[[NSMutableString alloc] init] autorelease];
        
    [Temp appendFormat:[Word substringWithRange:NSMakeRange(10, 1)]];        
    [Temp appendFormat:@"\n"];    
    return Temp;
    
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_fullScreenDelegate scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [_fullScreenDelegate scrollViewDidScroll:scrollView];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    return [_fullScreenDelegate scrollViewShouldScrollToTop:scrollView];;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    [_fullScreenDelegate scrollViewDidScrollToTop:scrollView];
}

@end

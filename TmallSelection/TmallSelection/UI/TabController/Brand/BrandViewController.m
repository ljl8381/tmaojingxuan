//
//  BrandViewController.m
//  ;
//
//  Created by ljl on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BrandViewController.h"
#import "NSString+SBJSON.h"
#import "ItemButton.h"
#import "SVSegmentedControl.h"
#import "brandCateViewController.h"
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

-(void)loadView
{

    [super loadView];
    NSString *manPath = [[NSBundle mainBundle]pathForResource:@"man" ofType:@"json"];
    NSDictionary  *manArray;
    if ([[NSFileManager defaultManager]fileExistsAtPath:manPath]) {
        NSString *temp = [NSString stringWithContentsOfFile:manPath encoding:NSUTF8StringEncoding error:nil];
        manArray = [temp JSONValue];
        TRACE(@"manArray = %@", [manArray objectForKey:@"info"]);
    }
    NSString *womanPath = [[NSBundle mainBundle]pathForResource:@"woman" ofType:@"json"];
    NSDictionary  *womanArray;
    if ([[NSFileManager defaultManager]fileExistsAtPath:womanPath]) {
        NSString *temp = [NSString stringWithContentsOfFile:womanPath encoding:NSUTF8StringEncoding error:nil];
        womanArray = [temp JSONValue];
    }
    _manView = [[customBrandView alloc]initWithType:1 andDic:[manArray objectForKey:@"info"]];
    _manView.frame = CGRectMake(0, 0, 320, 480);
    _manView.contentSize = CGSizeMake(320, 560);
    _manView.btnDelegate = self; 
    [self.view addSubview:_manView];
    _manView.hidden = YES;
    _womanView = [[customBrandView alloc]initWithType:2 andDic:[womanArray objectForKey:@"info"]];
    _womanView.frame = CGRectMake(0, 0, 320, 480);
    _womanView.contentSize = CGSizeMake(320, 780);
    _womanView.btnDelegate = self; 
    [self.view addSubview:_womanView];
    self.view.backgroundColor = [UIColor clearColor];
    SVSegmentedControl *navSC = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"", @"", nil]];
    navSC.frame = CGRectMake(258, 9, 52, 28);
    navSC.backgroundImage= [UIImage imageNamed:@"male_bg.png"];
    navSC.thumb.frame = CGRectMake(0, 0, 26, 28);
    navSC.thumb.backgroundImage = [UIImage imageNamed:@"male_button.png"];
    navSC.thumb.highlightedBackgroundImage = [UIImage imageNamed:@"male_button.png"];
    navSC.delegate=self;
    // navSC.thumb.frame = CGRectMake(0, 0, 26, 20);
    
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc]initWithCustomView:navSC];
    self.navigationItem.rightBarButtonItem = searchBtn;
    [searchBtn release];

    
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


#pragma mark --SVSegmentedControlDelegate

-(void)segmentedControl:(SVSegmentedControl *)segmentedControl didSelectIndex:(NSUInteger)index
{
    
    if (index==0) {
        _manView.hidden =YES;
        _womanView.hidden =NO;
        _womanView.alpha=0;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        _womanView.alpha=1;
        [UIView commitAnimations];
        
    }
    else
    {
        _manView.hidden=NO;
        _womanView.hidden =YES;
        _manView.alpha=0;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        _manView.alpha=1;
        [UIView commitAnimations];
    }

}
#pragma mark --itemButtonDelegate
-(void)itemButtonClicked:(id)sender
{
    brandCateViewController *cateView =  [[brandCateViewController alloc]init];
    ItemButton *button = (ItemButton *)sender;
    cateView.title = button.title;
    [self.navigationController pushViewController:cateView animated:YES];
    [cateView release];
}

@end

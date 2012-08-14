//
//  TmallSelectionViewController.m
//  TmallSelection
//
//  Created by ljl on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TmallSelectionViewController.h"
#import "ItemButton.h"
@interface TmallSelectionViewController ()

@end

@implementation TmallSelectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"天猫精选";
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    ItemButton *button1 = [[ItemButton alloc]initWithFrame:CGRectMake(50, 50, 101, 102)];
    [self.view addSubview:button1];
    self.view.backgroundColor = [UIColor blueColor];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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

@end

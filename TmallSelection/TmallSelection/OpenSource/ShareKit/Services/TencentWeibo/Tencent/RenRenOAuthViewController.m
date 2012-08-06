//
//  RenRenOAuthViewController.m
//  WeiboDemo
//
//  Created by liulin jiang on 12-7-12.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "RenRenOAuthViewController.h"
#import "RegexKitLite.h"
#import "RenRenQQEngine.h"
#import "SHK.h"

@interface RenRenOAuthViewController ()
- (NSString *)valueForKey:(NSString *)key ofQuery:(NSString*)query;
@end

@implementation RenRenOAuthViewController
@synthesize webView, delegate, spinner;

- (void)dealloc
{
	[webView release];
	[delegate release];
	[spinner release];
	[super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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





- (id)initWithURL:(NSURL *)authorizeURL delegate:(id)d
{
    if ((self = [super initWithNibName:nil bundle:nil])) 
	{
        UIButton *backButtonItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButtonItem setImage:[UIImage imageNamed:@"images_icon_back.png"] forState:UIControlStateNormal];
        [backButtonItem setImage:[UIImage imageNamed:@"images_icon_back_pressed.png"] forState:UIControlStateHighlighted];
        [backButtonItem addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        backButtonItem.frame = CGRectMake(276, 10, 50, 44);
        
        UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc]initWithCustomView:backButtonItem];
        self.navigationItem.leftBarButtonItem = searchBtn;
        [searchBtn release];
        
        
		self.delegate = d;
		
		self.webView = [[[UIWebView alloc] initWithFrame:CGRectZero] autorelease];
		webView.delegate = self;
		webView.scalesPageToFit = YES;
		webView.dataDetectorTypes = UIDataDetectorTypeNone;
		//[webView release];
		
		[webView loadRequest:[NSURLRequest requestWithURL:authorizeURL]];		
		
    }
    return self;
}

- (void)loadView 
{ 	
	self.view = webView;
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    [[SHK currentHelper] viewWasDismissed];
}


- (BOOL)webView:(UIWebView *)_webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{		
    NSString *absoluteurl=request.URL.absoluteString;
    if (absoluteurl&&[absoluteurl length])
    {
        TRACE(@"####%@",absoluteurl);
        NSArray *array=[absoluteurl componentsSeparatedByString:@"?"];
        if (array&&[array count]==2)
        {
            NSString *baseurl=[array objectAtIndex:0];
            NSString *query=[array objectAtIndex:1];
            NSString *redirect=[delegate authorizeCallbackURL];
            //TRACE(@"####baseurl:%@ \nquery:%@ redirect:%@",baseurl,query,redirect);
            if (baseurl&&[baseurl rangeOfString:redirect].location != NSNotFound)
            {
                
                if ([query length]) 
                {
                    NSDictionary *data=[RenRenQQEngine getParamsFromURL:query];
                    if (data&&[data objectForKey:@"code"])
                    {
                        //TRACE(@"####authorize:%@",data);
                        [delegate tokenAuthorizeView:self didFinishWithSuccess:YES queryParams:data error:nil];
                        self.delegate = nil;
                        return NO;
                    }
                }
            }
        }
    }
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[self startSpinner];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{	
	[self stopSpinner];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{	
	if ([error code] != NSURLErrorCancelled && [error code] != 102 && [error code] != NSURLErrorFileDoesNotExist)
	{
        TRACE(@"####error");
		[self stopSpinner];
		[delegate tokenAuthorizeView:self didFinishWithSuccess:NO queryParams:nil error:error];
	}
}

- (void)startSpinner
{
	if (spinner == nil)
	{
		self.spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
		[self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithCustomView:spinner] autorelease] animated:NO];
		spinner.hidesWhenStopped = YES;
		//[spinner release];
	}
	
	[spinner startAnimating];
}

- (void)stopSpinner
{
	[spinner stopAnimating];	
}

#pragma mark - private

- (NSString *)valueForKey:(NSString *)key ofQuery:(NSString*)query
{
	NSArray *pairs = [query componentsSeparatedByString:@"&"];
	for(NSString *aPair in pairs){
		NSArray *keyAndValue = [aPair componentsSeparatedByString:@"="];
		if([keyAndValue count] != 2) continue;
		if([[keyAndValue objectAtIndex:0] isEqualToString:key]){
			return [keyAndValue objectAtIndex:1];
		}
	}
	return nil;
}

- (void)cancel
{
	[delegate tokenAuthorizeCancelledView:self];
    [self dismissModalViewControllerAnimated:YES];
}

@end
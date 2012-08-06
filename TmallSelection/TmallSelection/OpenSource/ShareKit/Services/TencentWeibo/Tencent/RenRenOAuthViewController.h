//
//  RenRenOAuthViewController.h
//  WeiboDemo
//
//  Created by liulin jiang on 12-7-12.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RenRenOAuthViewController;
@protocol RenRenOAuthViewControllerDelegate<NSObject>

- (void)tokenAuthorizeView:(RenRenOAuthViewController *)authView didFinishWithSuccess:(BOOL)success queryParams:(NSDictionary *)queryParams error:(NSError *)error;
- (void)tokenAuthorizeCancelledView:(RenRenOAuthViewController *)authView;
- (NSString *)authorizeCallbackURL;

@end

@interface RenRenOAuthViewController : UIViewController<UIWebViewDelegate>
{
	UIWebView *webView;
	id delegate;
	UIActivityIndicatorView *spinner;
}
@property (nonatomic, retain) UIWebView *webView;
@property (retain) id<RenRenOAuthViewControllerDelegate> delegate;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;

- (id)initWithURL:(NSURL *)authorizeURL delegate:(id)d;

- (void)startSpinner;
- (void)stopSpinner;
@end

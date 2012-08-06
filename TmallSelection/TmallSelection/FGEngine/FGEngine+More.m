//
//  FGEngine+More.m
//  FreeGames
//
//  Created by ljl on 12-5-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FGEngine+More.h"
#import "feedbackViewController.h"
#import "aboutViewController.h"


@implementation TSEngine (More)
#define kItunesUrl			@"http://itunes.apple.com/cn/app/id316709252?mt=8"
#define kWeiboUrl           @"http://weibo.com/renren?topnav=1&wvr=3.6&topsug=1"
//请求更多页信息
- (void)requestMoreData
{
    TRACE(@"请求更多页信息");
    [_fgHttpObject requestMoreData];   
}
//跳转到反馈页面
-(void)feedBack:(MoreViewController *)viewController 
{
    [self reportEvent:@"跳转到反馈页面" withParameters:nil];
    feedbackViewController *feedbackVC= [[feedbackViewController alloc]init];
    [viewController.navigationController pushViewController:feedbackVC animated:YES];
    feedbackVC.gDelegate = viewController.self;
    [feedbackVC release];
}

//去itunes 评分
-(void)score 
{
    [self reportEvent:@"跳转到itunes评分" withParameters:nil];
    NSString *newUrlStr = kItunesUrl;
    if(newUrlStr)
    {
        NSURL *newUrl =[NSURL URLWithString:[newUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        if(newUrl && [[UIApplication sharedApplication] canOpenURL:newUrl])
        {
            [[UIApplication sharedApplication] openURL:newUrl];
        }
    }
    
}

//跳转到官方微博
-(void)weibo
{
    [self reportEvent:@"跳转到官方微博" withParameters:nil];
    NSString *newUrlStr = kWeiboUrl;
    if(newUrlStr)
    {
        NSURL *newUrl =[NSURL URLWithString:[newUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        if(newUrl && [[UIApplication sharedApplication] canOpenURL:newUrl])
        {
            [[UIApplication sharedApplication] openURL:newUrl];
        }
    }
}

//跳转到关于页面
-(void)about:(MoreViewController *)viewController  
{
    [self reportEvent:@"跳转到关于页面" withParameters:nil];
    AboutViewController *aboutVC= [[AboutViewController alloc]init];
    [viewController.navigationController pushViewController:aboutVC animated:YES]; 
    [aboutVC release];
}

- (void) showReaderView:(MoreViewController *)viewController 
{
    // ADD: present a barcode reader that scans from the camera feed
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    // present and release the controller
    [viewController.navigationController presentModalViewController: reader
                            animated: YES];
    [reader release];
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
//    
//    // EXAMPLE: do something useful with the barcode data
//    resultText.text = symbol.data;
//    
//    // EXAMPLE: do something useful with the barcode image
//    resultImage.image =
    [info objectForKey: UIImagePickerControllerOriginalImage];
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    //*************测试阶段临时组装信息*******************************************
    NSNumber *id = [NSNumber numberWithInt:543820635];
    NSArray *valueArray = [NSArray arrayWithObjects:id,@"Check Cool Vibes",@"/up/2012/07/24/09/Normal_de55952a-f1ca-400a-8e7d-2152120bc513.png",@"8.5",@"免费", @"http://itunes.apple.com/cn/app/check-cool-vibes/id543820635?mt=8&uo=4",nil];
    NSArray  *keyArray = [NSArray arrayWithObjects:@"applicationId",@"title",@"iconUrl",@"fileSize",@"costStr",@"viewUrl", nil];
    NSDictionary *cellDic = [NSDictionary dictionaryWithObjects:valueArray forKeys:keyArray];
    [reader dismissModalViewControllerAnimated: NO];
    [self showDetialPage:_mainController WithObjc:[FGCellObject getFGCellObjectWithDic:cellDic]];
    //*************测试阶段临时组装信息*******************************************
    //[reader dismissModalViewControllerAnimated: NO];
}

//点击cell
- (void)cellSelected:(NSInteger)index viewController:(MoreViewController *)viewController

{
    switch (index) 
    {
            //        case question_feedback_type:
            //            [self feedBack:viewController];
            //            break;
        case score_type:
            [self score];
            break;
            //        case recommend_type:
            //            [self recommend:viewController];
            //            break;
            //        case weibo_type:
            //            [self weibo];
            //            break;
        case about_type:
            [self about:viewController];
            break;
        case zbar_type:
            [self showReaderView:viewController];
            break;
        default:
            break;
    }
    
}

- (void)sendFeedBack:(NSString *)feedString andEmail:(NSString *)emailString;
{
    TRACE(@"发送反馈信息");
    [_fgHttpObject sendFeedBack:feedString andEmail:emailString];
    
}
@end

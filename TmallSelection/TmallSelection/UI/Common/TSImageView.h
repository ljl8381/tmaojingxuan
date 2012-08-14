//
//  ZDImageView.h
//  zhidao-iphone
//
//  Created by Zhicheng Wei on 5/19/11.
//  Copyright 2011 FZXY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIProgressBar.h"

@class ASIHTTPRequest;
@protocol imageClickDelegate;
@protocol ShowGameImageDelegate;

@interface TSImageView : UIImageView 
{
    NSString            *_url;
    ASIHTTPRequest      *_request;
    // 圆角
    float               _cornerRadius;
    // 设置默认图片
    NSString            * _defaultFile;
    id<imageClickDelegate> _iDelegate;
    id<ShowGameImageDelegate> _sDelegate;
    NSInteger           _imageId;
    UIProgressBar  *_progress;
}

@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) ASIHTTPRequest *request;
@property (nonatomic, retain) NSString *defaultFile;
@property (nonatomic, assign)  id<imageClickDelegate> iDelegate;
@property (nonatomic, assign)  id<ShowGameImageDelegate> sDelegate;
@property (nonatomic, assign)  NSInteger imageId;

-(void)imageForUrl:url;
- (void)setCornerRadiusForImage:(float)cornerRadius;
- (void) downloadImage:(NSString *)imageURL;
- (void) cancelDownload;
@end

@protocol imageClickDelegate <NSObject>

@optional
-(void)imageSingleTap:(TSImageView *)sender;

@end

@protocol ShowGameImageDelegate <NSObject>
- (void)showGameImages:(TSImageView *)touchImg;
@end
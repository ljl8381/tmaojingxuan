//
//  ZDImageView.m
//  zhidao-iphone
//
//  Created by Zhicheng Wei on 5/19/11.
//  Copyright 2011 FZXY. All rights reserved.
//

#import "FGImageView.h"

#import <ASI/ASIHTTPRequest.h>
#import <ASI/ASINetworkQueue.h>
#import <ASI/ASIDownloadCache.h>
#import <QuartzCore/QuartzCore.h>
#import "FullyLoaded.h"

@implementation FGImageView

@synthesize url = _url;
@synthesize request = _request;
@synthesize defaultFile = _defaultFile;
@synthesize iDelegate = _iDelegate;
@synthesize sDelegate = _sDelegate;
@synthesize imageId=_imageId;
- (id)init
{
    self = [super init];
    if (self) {
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageSingleTap:)];
        
        [self addGestureRecognizer:singleTap];
        [singleTap release];
        
    }
    return self;
}

// init with frame
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageSingleTap:)];
        
        [self addGestureRecognizer:singleTap];
        [singleTap release];
        self.userInteractionEnabled = YES;
        
    }
    return self;
}


- (void)setCornerRadiusForImage:(float)cornerRadius
{
    if (cornerRadius > 0.0001) {
        _cornerRadius = cornerRadius;
        
        [self.layer setCornerRadius:_cornerRadius];
        [self.layer setMasksToBounds:YES];
    }
}

- (void)setUrl:(NSString *)url
{
    if (_url != url) {
        // TRACE(@"重新赋值uuuurl");
        [_url release];
        _url = [url retain];
        if (_url)
        {
            self.request.delegate = nil;
            UIImage *image = [[FullyLoaded sharedFullyLoaded] imageForURL:_url];
                if (image) 
                {
                    if (self.frame.size.width>50)
                    {
                        if ((image.size.width>image.size.height)&&(self.frame.size.width<self.frame.size.height))
                        {
                            self.image =  [UIImage imageWithCGImage:image.CGImage scale:1 orientation:UIImageOrientationRight];
                            return;
                        }
                    }
                    
                    self.image = image;
                }
                else
                    [self downloadImage:_url];
        }
    }
}
-(void)loadImage :(NSString *)url
{
    
}
-(void )imageForUrl:url
{  
   // TRACE(@"取消下载url = %@",url);
    [self cancelDownload];
    UIImage *image = [[FullyLoaded sharedFullyLoaded] imageForURL:url];
    if (image) {
        self.image = image;
    }
    else {
        if (self.defaultFile) {
            [self setDefaultFile:self.defaultFile];
        }
    }
    
}
- (void)dealloc
{
    if (_progress) {
        [_progress release];
    }
    [self.request clearDelegatesAndCancel];
    self.request = nil;
    self.url = nil;
    [super dealloc];
}

- (void)setDefaultFile:(NSString *)defaultFile
{
    //    if ([self.defaultFile isEqualToString:defaultFile]) {
    //        return;
    //    }
    //   
    if (_defaultFile) {
        [_defaultFile release];
    }
    
    _defaultFile = [[NSString alloc] initWithString:defaultFile];
    self.image = [UIImage imageNamed:defaultFile];
}
-(void)imageSingleTap:(FGImageView *)sender

{
    //
    if (_iDelegate&& [_iDelegate respondsToSelector:@selector(imageSingleTap:)]) {
        
        [_iDelegate imageSingleTap:self];
    }
    if (_sDelegate&& [_sDelegate respondsToSelector:@selector(showGameImages:)]) {
        
        [_sDelegate showGameImages:self];
    }
}

- (void) cancelDownload {
    [self.request clearDelegatesAndCancel];
    self.request = nil;
}

#pragma mark - 
#pragma mark private downloads

- (void) downloadImage:(NSString *)imageURL {
    [self cancelDownload];
    if (self.bounds.size.width>300) {
        if (!_progress) {
             _progress = [[UIProgressBar alloc] initWithFrame:CGRectMake(60, 330, 200, 16)];
        }
        _progress.currentValue = 0.0;	
        [_progress setProgressRemainingColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"images_progress_bar_background.png"]]];
        [self addSubview:_progress];
    }
    self.request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:imageURL]];
    [[ASIDownloadCache sharedCache] setShouldRespectCacheControlHeaders:NO];
    [self.request setCacheStoragePolicy:ASICacheForSessionDurationCacheStoragePolicy];
    [self.request setDownloadDestinationPath:[[FullyLoaded sharedFullyLoaded] pathForImageURL:imageURL]];
    __block unsigned long long totalBytesReceived = 0;
    [self.request setCompletionBlock:^(void){
        self.request.delegate = nil;
        TRACE(@"async image download done");
        if (_progress) {
            [_progress removeFromSuperview];
        }
        NSString * imageURL = [[self.request.originalURL absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        self.request = nil;
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            UIImage *image = [[FullyLoaded sharedFullyLoaded] imageForURL:imageURL];
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (self.frame.size.width>50)
                {
                    if ((image.size.width>image.size.height)&&(self.frame.size.width<self.frame.size.height))
                    {
                        self.image =  [UIImage imageWithCGImage:image.CGImage scale:1 orientation:UIImageOrientationRight];
                        return;
                    }
                }
                self.image = image;
            });
        });}];
    [self.request setFailedBlock:^(void){
        if (_progress) {
            [_progress removeFromSuperview];
        }
        [self.request cancel];
        self.request.delegate = nil;
        self.request = nil;
        
        TRACE(@"async image download failed");
    }];
    [self.request setBytesReceivedBlock:^(unsigned long long length, unsigned long long total) 
     {
         totalBytesReceived += length;

         if (_progress) {
             _progress.currentValue = ((float )totalBytesReceived)/((float )total);
         }
         
     }];
    [self.request startAsynchronous];

}

@end

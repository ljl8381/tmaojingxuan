//
//  FGtableView.h
//  FreeGames
//
//  Created by ljl on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol lazyLoadingDelegate <NSObject>

- (NSString*)lazyImageURLForIndexPath:(NSIndexPath*)indexPath;


@end


@interface FGtableView : UITableView <UIScrollViewDelegate>

{
    id <lazyLoadingDelegate> _lDelegate;

}
- (void)loadImagesForOnscreenRows;
- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate;
- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView;
- (void)addLazyImageForCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath*)indexPath;
@property (nonatomic,assign) id<lazyLoadingDelegate> lDelegate;
@end

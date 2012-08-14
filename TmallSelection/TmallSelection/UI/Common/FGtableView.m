//
//  FGtableView.m
//  FreeGames
//
//  Created by ljl on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FGtableView.h"
#import "TSImageView.h"
#import "UITableView+LazyLoading.h"
#import "FGTableCell.h"

@implementation FGtableView


@synthesize lDelegate = _lDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *background = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"images_body_background.png"]];
        self.backgroundView = background;
        [background release];
    }
    return self;
}

- (void)addLazyImageForCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath*)indexPath
{
	NSString* url = [_lDelegate lazyImageURLForIndexPath:indexPath];
    if ([cell isKindOfClass:[FGTableCell class]]) 
    {
        [((FGTableCell *)cell).gameIcon imageForUrl:url];
        if (self.dragging == NO && self.decelerating == NO)
        {
            ((FGTableCell *)cell).gameIcon.url = url; 
        }
    }
    else
    {
        for (int i = 0; i < [cell.subviews count]; i++) 
        {           
            id subview = [cell.subviews objectAtIndex:i];     
            if( [subview isKindOfClass:TSImageView.class])
            {   
                [((TSImageView *)subview) imageForUrl:url];
                if (self.dragging == NO && self.decelerating == NO)
                    
                    ((TSImageView *)subview).url = url; 
                
            }
        }
    }
}

- (void)loadImagesForOnscreenRows
{
    NSArray* visiblePaths = [self indexPathsForVisibleRows];
	for (NSIndexPath* indexPath in visiblePaths)
	{
        UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
        if ([cell isKindOfClass:[FGTableCell class]]) 
        {
            if (_lDelegate) {
                ((FGTableCell *)cell).gameIcon.url = [_lDelegate lazyImageURLForIndexPath:indexPath];
            }
        }
        else
        {
            for (int i = 0; i < [cell.subviews count]; i++) 
            {           
                id subview = [cell.subviews objectAtIndex:i];     
                if( [subview isKindOfClass:TSImageView.class])
                {   
                    if (_lDelegate) {
                        ((TSImageView *)subview).url = [_lDelegate lazyImageURLForIndexPath:indexPath];
                    }
                }
            }
        }
        /*
         UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
         for (int i = 0; i < [cell.subviews count]; i++) 
         {           
         id subview = [cell.subviews objectAtIndex:i];     
         if( [subview isKindOfClass:FGImageView.class])
         {   
         if (_lDelegate) {
         ((FGImageView *)subview).url = [_lDelegate lazyImageURLForIndexPath:indexPath];
         }
         }
         }
         */
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate
{
	// Load images for all on-screen rows when scrolling is finished
    TRACE("加载可见图片icon");
	if (!decelerate)
		[self loadImagesForOnscreenRows];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    TRACE("加载可见");
	[self loadImagesForOnscreenRows];
}
@end

//
//  UITableView+LazyLoading.m
//  FreeGames
//
//  Created by ljl on 12-6-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TSImageView.h"
#import "UITableView+LazyLoading.h"

@implementation UITableViewCell (LazyLoading)


- (void)didLoadLazyImage:(UIImage*)theImage
{
	if (theImage != nil)
		self.imageView.image = theImage;
}
@end

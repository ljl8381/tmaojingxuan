//
//  UITableView+LazyLoading.h
//  FreeGames
//
//  Created by ljl on 12-6-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (LazyLoading)
- (void)didLoadLazyImage:(UIImage*)theImage;

@end

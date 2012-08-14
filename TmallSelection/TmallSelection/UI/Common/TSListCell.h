//
//  TSListCell.h
//  TmallSelection
//
//  Created by ljl on 12-8-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSCellObject.h"
#import "TSImageView.h"

@interface TSListCell : UITableViewCell
{
    TSCellObject    *_cellObject;
    TSImageView     *_productImage;
    id<imageClickDelegate>      _idelegate;
}

-(CGSize)getSizeWithText:(NSString *) text withFont:(UIFont *)font;

@property (nonatomic,retain)    TSCellObject    *cellObject;
@property (nonatomic, assign)  id<imageClickDelegate> iDelegate;
@end

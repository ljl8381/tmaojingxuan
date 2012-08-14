//
//  BrandViewController.h
//  TmallSelection
//
//  Created by ljl on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TSViewController.h"
#import "customBrandView.h"
#import "SVSegmentedControl.h"
#import "ItemButton.h"
#import "TSCateObject.h"
@interface BrandViewController : TSViewController<SVSegmentedControlDelegate,itemButtonClickDelegate>
{

    customBrandView              *_manView;
    customBrandView              *_womanView;
    TSCateObject                 *_cateObj;
}


@end

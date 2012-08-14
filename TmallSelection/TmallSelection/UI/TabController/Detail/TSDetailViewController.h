//
//  TSDetailViewController.h
//  TmallSelection
//
//  Created by ljl on 12-8-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TSViewController.h"
#import "TSImageView.h"

@interface TSDetailViewController : TSViewController <UIScrollViewDelegate,imageClickDelegate>

{
    UIScrollView        *_imgScrollView;
    UIPageControl   *_listControl;
    int             currentPage;
    BOOL            pageControlUsed;

}

@end

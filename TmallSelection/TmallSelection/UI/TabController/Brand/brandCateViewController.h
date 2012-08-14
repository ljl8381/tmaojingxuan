//
//  brandCateViewController.h
//  TmallSelection
//
//  Created by ljl on 12-8-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TSViewController.h"
#import "MKHorizMenu.h"
#import "TSImageView.h"
@interface brandCateViewController : TSViewController<MKHorizMenuDataSource, MKHorizMenuDelegate,UIScrollViewDelegate,imageClickDelegate>
{
    MKHorizMenu     *_horizMenu;
    NSArray         *subCateArray;
    UIScrollView    *_listView;
    UIPageControl   *_listControl;
    int             currentPage;
    BOOL            pageControlUsed;
    NSString        *title;
    UIButton        *_collectionButton;
    
}
@property (nonatomic,copy) NSString *title;

@end

//
//  BrandViewController.h
//  TmallSelection
//
//  Created by ljl on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TSViewController.h"
#import "EGORefreshTableHeaderView.h"
@interface BrandViewController : TSViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>

{
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL                        _reloading;

}
@end

//
//  TSAppDelegate.h
//  TmallSelection
//
//  Created by ljl on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSEngine.h"
@interface TSAppDelegate : UIResponder <UIApplicationDelegate>
{

    TSEngine        *_tsEngine;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) TSEngine *tsEngine;
@end

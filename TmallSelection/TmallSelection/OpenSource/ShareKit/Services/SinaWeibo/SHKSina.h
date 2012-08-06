//
//  SHKSina.h
//  ShareKit
//
//  Created by liulin jiang on 12-5-14.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "SHKSharer.h"
#import "WBEngine.h"

@interface SHKSina : SHKSharer<WBEngineDelegate>
{
     WBEngine   *_sinaEngine;
}

@end

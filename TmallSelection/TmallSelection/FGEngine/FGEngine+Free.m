//
//  FGEngine+Free.m
//  FreeGames
//
//  Created by 济泽 韩 on 12-5-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FGEngine+Free.h"
@implementation TSEngine (Free)
//请求热门限免页面数据
- (void)requestFreeData:(NSString *)currentType andPage:(int)pageNo;
{
    TRACE(@"请求热门限免页面数据");
    [_fgHttpObject requestFreeData:currentType andPage:pageNo];   
}

@end

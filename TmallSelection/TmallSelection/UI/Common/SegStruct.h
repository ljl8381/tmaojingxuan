//
//  SegStruct.h
//  FreeGames
//
//  Created by 济泽 韩 on 12-6-8.
//  Copyright (c) 2012年 renrengame. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SegStruct : NSObject
{
    NSMutableArray *array;
    int             page;
    int             totalPage;
    NSString       *segName;
}
@property (nonatomic, retain)  NSMutableArray *array;
@property (nonatomic, retain)  NSString       *segName;
@property (nonatomic, assign)  int             page;
@property (nonatomic, assign)  int             totalPage;
@end

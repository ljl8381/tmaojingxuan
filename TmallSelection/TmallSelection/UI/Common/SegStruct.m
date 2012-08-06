//
//  SegStruct.m
//  FreeGames
//
//  Created by 济泽 韩 on 12-6-8.
//  Copyright (c) 2012年 renrengame. All rights reserved.
//

#import "SegStruct.h"

@implementation SegStruct
@synthesize array;
@synthesize page;
@synthesize segName;
@synthesize totalPage;

-(void)dealloc
{
    [array release];
    [segName release];
    [super dealloc];
}
-(id)init
{
    self =[super init];
    if (self) 
    {
    array =     [[NSMutableArray alloc]initWithCapacity:5];
    segName =   [[NSString alloc]init];
    }
     return self;
}
@end

//
//  TSCellObject.m
//  TmallSelection
//
//  Created by ljl on 12-8-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TSCellObject.h"

@implementation TSCellObject
@synthesize description = _description;
@synthesize sellOut = _sellOut;
@synthesize oldPrice =_oldPrice;
@synthesize curPrice=_curPrice;
@synthesize cellID =_cellID;
@synthesize imgUrl=_imgUrl;

-(void)dealloc
{
    [_description release];
    [_sellOut release];
    [_oldPrice release];
    [_curPrice release];
    [_cellID release];
    [_imgUrl release];
    [super dealloc];
}
- (id)init 
{
    self =[super init];
    if (self) 
    {
    }
    return self;
}

+(TSCellObject *)getFGCellObjectWithDic:(NSDictionary *)cellDic
{
    if(!cellDic||![cellDic count])
    {
        return nil;
    }
    TSCellObject *cellObjc = [[TSCellObject alloc] init];
    cellObjc.description = [cellDic objectForKey:@"iconUrl"];
    cellObjc.sellOut = [cellDic objectForKey:@"genreListStr"];
    cellObjc.oldPrice = [cellDic objectForKey:@"title"];
    cellObjc.curPrice = [cellDic objectForKey:@"recommendedIndex"];
    cellObjc.imgUrl = [cellDic objectForKey:@"costStr"];
    return [cellObjc autorelease];
}


@end

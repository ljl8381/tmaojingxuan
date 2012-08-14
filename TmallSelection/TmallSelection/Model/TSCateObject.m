//
//  TSCateObject.m
//  TmallSelection
//
//  Created by ljl on 12-8-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TSCateObject.h"

@implementation TSCateObject
@synthesize title = _title;
@synthesize cateID =_cellID;
@synthesize imgUrl=_imgUrl;

-(void)dealloc
{
    [_title release];
    [_cateID release];
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


@end

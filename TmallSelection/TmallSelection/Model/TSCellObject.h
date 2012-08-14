//
//  TSCellObject.h
//  TmallSelection
//
//  Created by ljl on 12-8-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSCellObject : NSObject
{
    NSString        *_description;
    NSString        *_sellOut;
    NSString        *_curPrice;
    NSString        *_oldPrice;
    NSString        *_imgUrl;
    NSString        *_cellID;

}

@property (nonatomic,copy) NSString     *description;
@property (nonatomic,copy) NSString     *sellOut;
@property (nonatomic,copy) NSString     *curPrice;
@property (nonatomic,copy) NSString     *oldPrice;
@property (nonatomic,copy) NSString     *imgUrl;
@property (nonatomic,copy) NSString     *cellID;

+(TSCellObject *)getFGCellObjectWithDic:(NSDictionary *)cellDic;

@end

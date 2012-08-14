//
//  TSCateObject.h
//  TmallSelection
//
//  Created by ljl on 12-8-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSCateObject : NSObject
{
    NSString        *_title;
    NSString        *_imgUrl;
    NSString        *_cateID;
    
}

@property (nonatomic,copy) NSString     *title;
@property (nonatomic,copy) NSString     *imgUrl;
@property (nonatomic,copy) NSString     *cateID;

@end

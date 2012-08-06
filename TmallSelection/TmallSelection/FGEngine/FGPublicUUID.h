//
//  PublicUUID.h
//  UUID
//
//  Created by liulin jiang on 12-3-29.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FGPublicUUID : NSObject

//get secure UUID
//32位小写字母或数字
+(NSString *)deviceUniqueString;

//get mac address md5
//32位小写字母或数字
+(NSString *)macAddressMD5;
@end

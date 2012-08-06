//
//  AderSHA1MD5.m
//  GAds-SDK
//
//  Created by liulin jiang on 12-5-7.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "FGSHA1MD5.h"
#include <CommonCrypto/CommonDigest.h>

@implementation FGSHA1MD5

static inline char aderHexChar(unsigned char c) {
    return c < 10 ? '0' + c : 'a' + c - 10;
}

static inline void AderHexString(unsigned char *from, char *to, NSUInteger length) {
    for (NSUInteger i = 0; i < length; ++i) {
        unsigned char c = from[i];
        unsigned char cHigh = c >> 4;
        unsigned char cLow = c & 0xf;
        to[2 * i] = aderHexChar(cHigh);
        to[2 * i + 1] = aderHexChar(cLow);
    }
    to[2 * length] = '\0';
}

+(NSString *)fgmd5:(NSString *)string
{
    const char *digest=[string UTF8String];
    static const NSUInteger LENGTH = CC_MD5_DIGEST_LENGTH;
    unsigned char result[LENGTH];
    CC_MD5(digest, (CC_LONG)strlen(digest), result);
    
    char hexResult[2 * LENGTH + 1];
    AderHexString(result, hexResult, LENGTH);
    
    return [NSString stringWithUTF8String:hexResult];
}

+(NSString *)fgsha1:(NSString *)string {
    const char *digest=[string UTF8String];
    static const NSUInteger LENGTH = CC_SHA1_DIGEST_LENGTH;
    unsigned char result[LENGTH];
    CC_SHA1(digest, (CC_LONG)strlen(digest), result);
    
    char hexResult[2 * LENGTH + 1];
    AderHexString(result, hexResult, LENGTH);
    
    return [NSString stringWithUTF8String:hexResult];
}
@end

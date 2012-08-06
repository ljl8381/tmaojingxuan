//
//  PublicUUID.m
//  UUID
//
//  Created by liulin jiang on 12-3-29.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "FGPublicUUID.h"
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>
#import <CommonCrypto/CommonDigest.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "FGSHA1MD5.h"

#define DEFAULT_DOMAIN    @"com.renren.game.UUID"
#define DEFAULT_SOLT      @"renren_game_pakistan_korea"
#define SECURE_UUID_MAX_PASTEBOARD_ENTRIES (100)

static NSString *const SUUID_DICT_NAME  = DEFAULT_DOMAIN;
static NSString *const SUUIDOwnerKey            = @"SUUIDOwnerKey";
static NSString *const SUUIDTimeStampKey        = @"SUUIDTimeStampKey";

static NSData *cryptorToData(CCOperation operation, NSData *value, NSData *key);
static NSString *cryptorToString(CCOperation operation, NSData *value, NSData *key);
static UIPasteboard *pasteboardForEncryptedDomain(NSData *encryptedDomain);

@interface FGPublicUUID()
+ (NSString *)UUIDForDomain:(NSString *)domain salt:(NSString *)salt;
+ (NSString *)pasteboardNameForNumber:(NSInteger)number;
@end

@implementation FGPublicUUID
#pragma mark - public
+(NSString *)deviceUniqueString
{
    return [FGPublicUUID UUIDForDomain:DEFAULT_DOMAIN salt:DEFAULT_SOLT];
}

+(NSString *)macAddressMD5
{
    NSString *retValue=nil;
    struct if_nameindex * ifn_list ,* ifnp;
    
    if ((ifn_list = if_nameindex()) == NULL) 
    {
        TRACE(@"Error: if_nameindex failed\n");
        return retValue;
    }
    unsigned int idx; 
    for (ifnp = ifn_list; ifnp->if_name != NULL; ifnp++)
    {
        char *ifname=ifnp->if_name;
        TRACE(@"ifname:%s",ifname);
        if (strncmp(ifname, "en", 2)==0) 
        {
            idx=ifnp->if_index;
            TRACE(@"got the en ifname with index:%d",idx);
            break;
        }
    }
    if_freenameindex(ifn_list);
    if (idx==0)
    {
        TRACE(@"Error: if_index failed\n");
        return retValue;
    }
    int    mib[6];
	size_t len;
	char *buf;
	unsigned char *ptr;
	struct if_msghdr *ifm;
	struct sockaddr_dl *sdl;
	
	mib[0] = CTL_NET;
	mib[1] = AF_ROUTE;
	mib[2] = 0;
	mib[3] = AF_LINK;
	mib[4] = NET_RT_IFLIST;
	
    mib[5]=idx;
	
	if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
		TRACE(@"Error: sysctl, take 1\n");
		return retValue;
	}
	
	if ((buf = malloc(len)) == NULL) {
		TRACE(@"Could not allocate memory. error!\n");
		return retValue;
	}
	
	if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
		TRACE(@"Error: sysctl, take 2");
        free(buf);
		return retValue;
	}
	
	ifm = (struct if_msghdr *)buf;
	sdl = (struct sockaddr_dl *)(ifm + 1);
	ptr = (unsigned char *)LLADDR(sdl);
	NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
	free(buf);
    retValue=[[FGSHA1MD5 fgmd5:[outstring uppercaseString]] lowercaseString];
    TRACE(@"MAC:%@ MD5:%@", outstring,retValue);
    return retValue;
}

#pragma mark - private
/*
 Returns a unique id for the device, sandboxed to the domain and salt provided.
 
 Example usage:
 #import "SecureUUID.h"
 
 NSString *UUID = [SecureUUID UUIDForDomain:@"com.example.myapp" salt:@"superSecretCodeHere!@##%#$#%$^"];
 
 */
+ (NSString *)UUIDForDomain:(NSString *)domain salt:(NSString *)salt {
    // Salt the domain to make the crypt keys affectively unguessable.
    NSData *domainAndSalt = [[NSString stringWithFormat:@"%@%@", domain, salt] dataUsingEncoding:NSUTF8StringEncoding];
    
    // Compute a SHA1 of the salted domain to standardize its length for AES-128
    uint8_t digest[CC_MD5_DIGEST_LENGTH] = {0};
    CC_MD5(domainAndSalt.bytes, domainAndSalt.length, digest);
    NSData *key = [NSData dataWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
    
    // Encrypt the salted domain key and load the pasteboard on which to store data
    NSData *encryptedDomain = cryptorToData(kCCEncrypt, [domain dataUsingEncoding:NSUTF8StringEncoding], key);
    UIPasteboard *pasteboard = pasteboardForEncryptedDomain(encryptedDomain);
    
    // Read the storage dictionary out of the pasteboard data, or create a new one
    NSMutableDictionary *secureUUIDDictionary = nil;
    id pasteboardData = [pasteboard dataForPasteboardType:SUUID_DICT_NAME];
    if (pasteboardData) {
        pasteboardData = [NSKeyedUnarchiver unarchiveObjectWithData:pasteboardData];
        secureUUIDDictionary = [NSMutableDictionary dictionaryWithDictionary:pasteboardData];
    } else {
        secureUUIDDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    
    // If a UUID has already been generated for this salted domain, read it now
    NSData *valueFromPasteboard = [secureUUIDDictionary objectForKey:encryptedDomain];
    if (valueFromPasteboard) {
        NSString *retuuid=cryptorToString(kCCDecrypt, valueFromPasteboard, key);
        retuuid=[[retuuid stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
        return retuuid;
    }
    
    // Otherwise, create a new RFC-4122 Version 4 UUID
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef uuidStr = CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    NSString *nsuuid=[(NSString *)uuidStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(uuidStr);
    nsuuid=[nsuuid lowercaseString];
    // Encrypt it for storage.
    NSData *data = cryptorToData(kCCEncrypt, [nsuuid dataUsingEncoding:NSUTF8StringEncoding], key);
    
    // And store it in the pasteboard for later, along with the owner of this pasteboard
    // And a timestamp noting its updated date.
    [secureUUIDDictionary setObject:data            forKey:encryptedDomain];
    [secureUUIDDictionary setObject:[NSDate date]   forKey:SUUIDTimeStampKey];
    [secureUUIDDictionary setObject:encryptedDomain forKey:SUUIDOwnerKey];
    
    [pasteboard setData:[NSKeyedArchiver archivedDataWithRootObject:secureUUIDDictionary]
      forPasteboardType:SUUID_DICT_NAME];
    
    return nsuuid;
}

/*
 Applies the operation (encrypt or decrypt) to the NSData value with the provided NSData key
 and returns the value as NSData.
 */
NSData *cryptorToData(CCOperation operation, NSData *value, NSData *key) {
    NSMutableData *output = [NSMutableData dataWithLength:value.length + kCCBlockSizeAES128];
    
    size_t numBytes = 0;
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          [key bytes],
                                          kCCKeySizeAES128,
                                          NULL,
                                          value.bytes,
                                          value.length,
                                          output.mutableBytes,
                                          output.length,
                                          &numBytes);
    
    if (cryptStatus == kCCSuccess) {
        return [[[NSData alloc] initWithBytes:output.bytes length:numBytes] autorelease];
    }
    
    return nil;
}

/*
 Applies the operation (encrypt or decrypt) to the NSData value with the provided NSData key
 and returns the value as an NSString.
 */
NSString *cryptorToString(CCOperation operation, NSData *value, NSData *key) {
    return [[[NSString alloc] initWithData:cryptorToData(operation, value, key) encoding:NSUTF8StringEncoding] autorelease];
}

/*
 Returns an NSString formatted with the supplied number.
 */
+(NSString *)pasteboardNameForNumber:(NSInteger)number
{
    return [[[NSString alloc] initWithFormat:@"%@_%d",SUUID_DICT_NAME, number] autorelease];
}

/*
 SecureUUID leverages UIPasteboards to persistently store its data.
 UIPasteboards marked as 'persistent' have the following attributes:
 - They persist across application relaunches, device reboots, and OS upgrades.
 - They are destroyed when the application that created them is deleted from the device.
 
 To protect against the latter case, SecureUUID leverages multiple pasteboards (up to
 SECURE_UUID_MAX_PASTEBOARD_ENTRIES), creating one for each distinct domain/app that
 leverages the system. The permanence of SecureUUIDs increases exponentially with the
 number of apps that use it.
 
 Returns a pasteboard for the encrypted domain. If a pasteboard for the domain is not found a new one is created.
 */
UIPasteboard *pasteboardForEncryptedDomain(NSData *encryptedDomain) {
    UIPasteboard*        usablePasteboard;
    NSInteger            lowestUnusedIndex;
    NSInteger            ownerIndex;
    NSDate*              mostRecentDate;
    NSMutableDictionary* mostRecentDictionary;
    
    usablePasteboard     = nil;
    lowestUnusedIndex    = -1;//INTMAX_MAX;
    mostRecentDate       = [NSDate distantPast];
    mostRecentDictionary = nil;
    ownerIndex           = -1;
    
    // The array of SecureUUID pasteboards can be sparse, since any number of
    // apps may have been deleted. To find a pasteboard owned by the the current
    // domain, iterate all of them.
    for (NSInteger i = 0; i < (SECURE_UUID_MAX_PASTEBOARD_ENTRIES-1); ++i) {
        UIPasteboard* pasteboard;
        NSDate*       modifiedDate;
        NSDictionary* dictionary;
        NSData*       pasteboardData;
        
        // If the pasteboard could not be found, notate that this is the first unused index.
        pasteboard = [UIPasteboard pasteboardWithName:[FGPublicUUID pasteboardNameForNumber:i] create:YES];
        if (!pasteboard) {
            if (lowestUnusedIndex == -1) {
                lowestUnusedIndex = i;
            }
            
            continue;
        }
        
        // If it was found, load and validate its payload
        pasteboardData = [pasteboard valueForPasteboardType:SUUID_DICT_NAME];
        if (!pasteboardData) {
            // corrupted slot
            if (lowestUnusedIndex == -1) {
                lowestUnusedIndex = i;
            }
            
            continue;
        }
        
        // Check the 'modified' timestamp of this pasteboard
        dictionary   = [NSKeyedUnarchiver unarchiveObjectWithData:pasteboardData];
        modifiedDate = [dictionary valueForKey:SUUIDTimeStampKey];
        
        // Hold a copy of the data if this is the newest we've found so far.
        if ([modifiedDate compare:mostRecentDate] == NSOrderedDescending) {
            mostRecentDate       = modifiedDate;
            mostRecentDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
            usablePasteboard     = pasteboard;
        }
        
        // Finally, notate if this is the pasteboard owned by the requesting domain.
        if ([[dictionary objectForKey:SUUIDOwnerKey] isEqual:encryptedDomain]) {
            ownerIndex = i;
        }
    }
    
    // If no pasteboard is owned by this domain, establish a new one to increase the
    // likelihood of permanence.
    if (ownerIndex == -1) {
        // Unless there are no available slots
        if ((lowestUnusedIndex < 0) || (lowestUnusedIndex >= SECURE_UUID_MAX_PASTEBOARD_ENTRIES)) {
            //return nil;
            //如果slots都用完了，就用最后一个
            lowestUnusedIndex=SECURE_UUID_MAX_PASTEBOARD_ENTRIES-1;
        }
        
        // Copy the most recent data over if possible
        if (!mostRecentDictionary) {
            mostRecentDictionary = [NSMutableDictionary dictionary];
        }
        
        // Set ownership and the created timestamp.
        [mostRecentDictionary setObject:encryptedDomain forKey:SUUIDOwnerKey];
        [mostRecentDictionary setObject:[NSDate date]   forKey:SUUIDTimeStampKey];
        
        // Create and save the pasteboard.
        usablePasteboard = [UIPasteboard pasteboardWithName:[FGPublicUUID pasteboardNameForNumber:lowestUnusedIndex] create:YES];
        usablePasteboard.persistent = YES;
        
        [usablePasteboard setData:[NSKeyedArchiver archivedDataWithRootObject:mostRecentDictionary]
                forPasteboardType:SUUID_DICT_NAME];
    }
    
    assert(usablePasteboard);
    
    return usablePasteboard;
}
@end
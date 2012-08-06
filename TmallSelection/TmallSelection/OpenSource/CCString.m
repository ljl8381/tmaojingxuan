#import "CCString.h"
#import "RegexKitLite.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (CCString)

#pragma mark UI

- (void)show_alert_title:(NSString*)title message:(NSString*)msg
{
	[self show_alert_title:title message:msg delegate:nil];
}

- (void)show_alert_title:(NSString*)title message:(NSString*)msg delegate:(id)an_obj
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title 
													message:msg 
												   delegate:an_obj 
										  cancelButtonTitle:@"确定"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)show_alert_message:(NSString*)msg
{
	[self show_alert_title:self message:msg];
}

- (void)show_alert_title:(NSString*)title
{
	[self show_alert_title:title message:self];
}

- (void)show_alert_message:(NSString*)msg delegate:(id)an_obj
{
	[self show_alert_title:self message:msg delegate:an_obj];
}

- (void)show_alert_title:(NSString*)title delegate:(id)an_obj
{
	[self show_alert_title:title message:self delegate:an_obj];
}

#pragma mark Application

- (BOOL)go_url
{
	NSString* s = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:s]];
}

- (BOOL)can_go_url
{
	NSString* s = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:s]];
}

#pragma mark File

- (NSString*)filename_document
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) 
			 objectAtIndex:0] stringByAppendingPathComponent:self];
}

- (NSString*)filename_bundle
{
    return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:self];
}

- (BOOL)is_directory
{
	BOOL	b;
	
    NSFileManager *file_manager = [NSFileManager defaultManager];
	[file_manager fileExistsAtPath:[self filename_document] isDirectory:&b];
	
	return b;
}

- (BOOL)file_exists
{
    NSFileManager *file_manager = [NSFileManager defaultManager];
    return [file_manager fileExistsAtPath:[self filename_document]];
}

- (BOOL)file_exists_bundle
{
    NSFileManager *file_manager = [NSFileManager defaultManager];
    return [file_manager fileExistsAtPath:[self filename_bundle]];
}

- (BOOL)create_dir
{
	NSFileManager*	manager = [NSFileManager defaultManager];
	return [manager createDirectoryAtPath:[self filename_document] withIntermediateDirectories:YES attributes:nil error:nil];
}

- (BOOL)file_backup
{
	NSError* error;
	
	if ([[self filename_document] file_exists])
		return NO;
	else
	{
		[[NSFileManager defaultManager] 
		 //linkItemAtPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:name]
		 copyItemAtPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self]
		 toPath:[self filename_document]
		 error:&error];
		//handler:nil];
		if (error != nil)
		{
			NSLog(@"ERROR backup: %@", error.localizedDescription);
			return NO;
		}
		else
			return YES;
	}
	
	return NO;
}

- (BOOL)file_backup_to:(NSString*)dest
{
	return [[NSString stringWithFormat:@"%@/%@", dest, self] file_backup];
}

#pragma mark URL

- (NSString*)url_to_filename
{
	NSString*	s = self;
	
	s = [s stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
	s = [s stringByReplacingOccurrencesOfString:@":" withString:@"_"];
	s = [s stringByReplacingOccurrencesOfString:@"\\" withString:@"_"];
	
	return s;
}

- (NSString*)to_url
{
	return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark String

- (BOOL)has_substring:(NSString*)sub
{
	NSRange range = [self rangeOfString:sub];
	if ((range.location == NSNotFound) && (range.length == 0))
		return NO;
	
	return YES;
}

- (NSDictionary*)string_head_tail:(NSString*)strsub
{
	NSDictionary *result = nil;
	
	NSRange strsubpos = [self rangeOfString:strsub];
	NSRange rangehead;
	NSRange rangeend;
	
	if (strsubpos.location == NSNotFound)
		return result;
	
	rangehead.location = 0;
	rangehead.length = strsubpos.location;
	NSString *headstring = [self substringWithRange:rangehead];
	
	rangeend.location = strsubpos.location+1;
	rangeend.length = self.length - (strsubpos.location+1);
	
	NSString *endstring = [self substringWithRange:rangeend];
	
	result = [NSDictionary dictionaryWithObjectsAndKeys:headstring , @"head", endstring , @"end" ,nil];
	
	return result;
}

- (NSString*)string_without:(NSString*)head to:(NSString*)tail
{
	return [self string_without:head to:tail except:[NSArray arrayWithObjects:nil]];
}

- (NSString*)string_without:(NSString*)head to:(NSString*)tail except:(NSArray*)exceptions
{
	int			i;
	BOOL		finding_head = YES;
	NSRange		range_source, range_dest;
	NSString*	s = [NSString stringWithString:self];
	NSString*	sub = @"";
	
	while (sub != nil)
	{
		sub = nil; 
		for (i = 0; i < s.length; i++)
		{
			range_source.location = i;
			if (finding_head)
			{
				range_source.length = head.length;
				if (range_source.length + i > s.length)
					break;
				if ([[s substringWithRange:range_source] isEqualToString:head])
				{
					//	NSLog(@"found head at: %i", i);
					range_dest.location = i;
					finding_head = NO;
				}
			}
			else
			{
				range_source.length = tail.length;
				if (range_source.length + i > s.length)
					break;
				if ([[s substringWithRange:range_source] isEqualToString:tail])
				{
					//	NSLog(@"found tail at: %i", i);
					range_dest.length = i - range_dest.location + tail.length;
					sub = [s substringWithRange:range_dest];
					finding_head = YES;
					if ([exceptions containsObject:sub] == NO)
						break;
					//	else
					//	NSLog(@"skipping %@", sub);
				}
			}
		}
		if (sub != nil)
		{
			if ([exceptions containsObject:sub])
				break;
			//	NSLog(@"found sub: %@", sub);
			s = [s stringByReplacingOccurrencesOfString:sub withString:@""];
		}
	}
	
	return s;
}

- (NSString*)string_between:(NSString*)head and:(NSString*)tail
{
	NSRange range_head = [self rangeOfString:head];
	NSRange range_tail = [self rangeOfString:tail];
	NSRange range;
	
	if (range_head.location == NSNotFound)
		return nil;
	if (range_tail.location == NSNotFound)
		return nil;
	
	range.location = range_head.location + range_head.length;
	range.length = range_tail.location - range.location;
	
	return [self substringWithRange:range];
}

- (NSString*)string_tail:(NSString*)head
{
	NSRange range_head = [self rangeOfString:head];
	NSRange range;
	
	if( range_head.location == NSNotFound )
		return nil;
	
	range.location = range_head.location;
	range.length   =  [self length] - range.location;
	
	return [self substringWithRange:range];
	
}

- (NSString*)string_replace:(NSString*)findstr to:(NSString*)replacestring
{
	if( ![self has_substring:findstr] )
		return self;
	
	NSString* rstr =nil;
	NSString* s = [NSString stringWithString:self];
	
	NSMutableString* okstring = [[NSMutableString alloc]init];
	NSRange range_find = [s rangeOfString:findstr];
	
	while( range_find.location != NSNotFound )
	{
		[okstring appendString:[s substringWithRange:NSMakeRange(0 , range_find.location)]];
		if( replacestring != nil )
			[okstring appendString:replacestring];
		
		NSRange range;
		range.location = range_find.location+1;
		range.length = [s length] - range.location;
		
		s = [s substringWithRange:range];
		range_find = [s rangeOfString:findstr];
		if( range_find.location == NSNotFound )
		{
			[okstring appendString:s];
			rstr = [NSString stringWithString:okstring];
			break;
		}
		
	}
	
	[okstring release];
	return rstr;
	
}
- (NSString*)trimNONumberString
{
	NSString *result = nil;
	NSString *noNumberRegex =@"[^0-9]";
	result = [self stringByReplacingOccurrencesOfRegex:noNumberRegex withString:@""];
	
	return result;
}

+ (NSString *)replaceUnicode:(NSString *)unicodeStr {  
	
	NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];  
	NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];  
	NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];  
	NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];  
	NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData  
														   mutabilityOption:NSPropertyListImmutable   
																	 format:NULL  
														   errorDescription:NULL];  
	
	//NSLog(@"Output = %@", returnStr);  
	
	return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];  
}  

#pragma mark Time & Date

- (NSString*)convert_date_from:(NSString*)format_old to:(NSString*)format_new
{
	NSString* dateStr = self;
	
	//	Convert string to date object
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:format_old];
	NSDate *date = [dateFormat dateFromString:dateStr];  
	
	//	Convert date object to desired output format
	[dateFormat setDateFormat:format_new];
	dateStr = [dateFormat stringFromDate:date];  
	[dateFormat release];
	
	return dateStr;
}

- (time_t)convert_date_string_to_unix
{
	// Convert timestamp string to UNIX time
    //
	NSString* format_old = self;
	
	time_t createdAt;
	
    struct tm created;
    time_t now;
    time(&now);
	
	
	if (format_old) {
		if (strptime([format_old UTF8String], "%a %b %d %H:%M:%S %z %Y", &created) == NULL) {
			strptime([format_old UTF8String], "%a, %d %b %Y %H:%M:%S %z", &created);
		}
		createdAt = mktime(&created);
	}
	
	return createdAt;
}


//英文2个算1个字符，中文1个算1个字符）计算字符数
-(int)count_charNum
{
	NSString *str=[self stringByReplacingOccurrencesOfRegex:@"[\u4e00-\u9fa5]" withString:@"xx"];

	return str.length/2;
}

- (BOOL)isExitsFace
{
	
	BOOL bret = NO;
	NSString *t = self;
	
	for( int i = 0 ; i < t.length ; i++ )
	{
		unichar _o = [t characterAtIndex:i];
		if( (_o >= 0xe000) && (_o<=0xefff) )
		{
			bret = YES;
			break;
		}
	}
	
	return bret;
}


- (int)calc_charsetNum
{
	unsigned result = 0;
	const char *tchar=[self UTF8String];
	if (NULL == tchar) {
		return result;
	}
	
	result = strlen(tchar);
	
	
	return result;
	
}
- (NSString*)trimUnichar
{
	NSString *result = nil;
	int halfspacechar = 8198;
	NSString *t1 = self;
	NSMutableString *resultstring = [[NSMutableString alloc]init];
	for( int i = 0 ; i < t1.length ; i++ )
	{
		unichar _cl = [t1 characterAtIndex:i];
		if( _cl == halfspacechar )
			continue;
		[resultstring appendFormat:@"%C",_cl];
		
	}
	result = [NSString stringWithString:resultstring];
	[resultstring release];
	
	return result;
}

+ (time_t)genTimeTWithYear:(int)y moth:(int)m day:(int)d  hour:(int)h 
{
	if( y < 1900 )
		return 0;
	if( m < 1 )
		return 0;
	
	time_t result_time = time(NULL);
	
	struct tm *curmon_timeinfo = localtime ( &result_time );			//转为当地时间，输出 tm  结构
	
	curmon_timeinfo->tm_sec = 0;
	curmon_timeinfo->tm_min = 0;
	curmon_timeinfo->tm_hour = h;
	curmon_timeinfo->tm_mday = d;
	curmon_timeinfo->tm_mon  = m-1;
	curmon_timeinfo->tm_year = y-1900;
	
	result_time = mktime(curmon_timeinfo);
	
	
	return result_time;
}

+ (NSString*)genmd5:(NSString*)str
{
	const char *cStr = [str UTF8String];
	unsigned char result[16];
	CC_MD5( cStr, strlen(cStr), result );
	return [NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3], 
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]];
}

- (NSString*)trimWhiteSpaceInTwoEnds
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
@end

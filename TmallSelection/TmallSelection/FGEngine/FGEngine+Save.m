//
//  FGEngine+Save.m
//  FreeGames
//
//  Created by ljl on 12-5-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FGEngine+Save.h"

@implementation TSEngine (Save)

-(NSString *)getSearchRecordsListFile
{	
	return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
			 objectAtIndex:0] stringByAppendingPathComponent:kSearchRecordsFileName];
}

//从文件中加载搜索历史
-(NSMutableArray *)loadSearchRecordsFromFile 
{
	NSString *path = [self getSearchRecordsListFile];
	NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
	NSMutableArray * searchArray = [NSMutableArray array];
	for (int i=0; i<[dict count]; i++)
	{
		NSArray *array = [dict objectForKey:[NSString stringWithFormat:@"%d",i]];
		if (array)
		{
			if (searchArray == nil)
				searchArray = [[[NSMutableArray alloc] init] autorelease];
			[searchArray addObject:[array objectAtIndex:0]];
		}
	} 
    [dict release];
    return searchArray; 
}

//将搜索历史写入文件中
-(void)saveSearchRecordsToFileWithArray:(NSArray *)array
{
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
	for (int i = 0; i<[array count]; i++) 
	{
		NSArray *object = [[NSArray alloc] initWithObjects:[array objectAtIndex:i], nil];
		[dict setObject:object forKey:[NSString stringWithFormat:@"%d",i]];
		[object release];
	}
	
	[dict writeToFile:[self getSearchRecordsListFile] atomically:YES];
	[dict release];
}

//添加搜索历史
- (void)addSearchRecord:(NSString*)string type:(NSMutableArray *)searchArray
{
    TRACE("添加搜索历史 string = %@ ,searchArray= %@",string,searchArray);
	BOOL result = NO;
	for (NSString *record in searchArray)
	{
		result = [string caseInsensitiveCompare:record] == NSOrderedSame;
		if (result)
		{
			[searchArray removeObject:record];
			[searchArray insertObject:string atIndex:0 ];
			break;
		}
	}
	if (!result)
	{
		[searchArray insertObject:string atIndex:0];
	}
	
	[self saveSearchRecordsToFileWithArray:searchArray];
}
@end

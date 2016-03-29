/*
 *****************************************************************************
 * Copyright (C) 2005-2015 UC Mobile Limited. All Rights Reserved
 * File			: UCFileManager.m
 *
 * Description	: UCFileManager
 *
 * Author		: zengkui.wzk@alibaba-inc.com
 *
 * History		: Creation, 16/3/10, zengkui.wzk@alibaba-inc.com, Create the file
 ******************************************************************************
 **/

#import "UCFileManager.h"

@implementation UCFileManager

+ (NSString *)documentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSArray *)contentsOfDirectoryAtPath:(NSString *)path
{
    if (!path)
    {
        path = [self documentPath];
    }
    
    NSFileManager *manager = [[[NSFileManager alloc] init] autorelease];
    NSArray *items = [manager contentsOfDirectoryAtPath:path error:nil];
    
    NSMutableArray *contents = [[NSMutableArray new] autorelease];
    
    for (NSString *item in items)
    {
        BOOL isDir = YES;
        [manager fileExistsAtPath:[path stringByAppendingPathComponent:item] isDirectory:&isDir];
        NSDictionary *itemDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @(isDir),kIsDirectoryKey,
                                  [item lastPathComponent], kPathKey,nil];
        [contents addObject:itemDict];
    }
    return contents;
}

+ (BOOL)createPath:(NSString *)path
{
    NSFileManager *manager = [[[NSFileManager alloc] init] autorelease];
    return [manager createDirectoryAtPath:path
              withIntermediateDirectories:YES
                               attributes:nil
                                    error:nil];
}

+ (BOOL)createFile:(NSString *)fileName atPath:(NSString *)path
{
    NSFileManager *manager = [[[NSFileManager alloc] init] autorelease];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    return[manager createFileAtPath:filePath contents:nil attributes:nil];
}

+ (BOOL)removeItemAtPath:(NSString *)path
{
    NSFileManager *manager = [[[NSFileManager alloc] init] autorelease];
    return [manager removeItemAtPath:path error:nil];
}

@end

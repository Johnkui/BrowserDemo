/*
 *****************************************************************************
 * Copyright (C) 2005-2015 UC Mobile Limited. All Rights Reserved
 * File			: UCFileManager.h
 *
 * Description	: UCFileManager
 *
 * Author		: zengkui.wzk@alibaba-inc.com
 *
 * History		: Creation, 16/3/10, zengkui.wzk@alibaba-inc.com, Create the file
 ******************************************************************************
 **/

#import <Foundation/Foundation.h>

static NSString *kPathKey = @"pathKey";
static NSString *kIsDirectoryKey = @"isDirectoryKey";

@interface UCFileManager : NSObject

+ (NSString *)documentPath;
+ (NSArray *)contentsOfDirectoryAtPath:(NSString *)path;
+ (BOOL)createPath:(NSString *)path;
+ (BOOL)createFile:(NSString *)fileName atPath:(NSString *)path;
+ (BOOL)removeItemAtPath:(NSString *)path;

@end

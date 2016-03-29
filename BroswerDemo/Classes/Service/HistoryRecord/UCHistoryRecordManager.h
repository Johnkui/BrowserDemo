/*
 *****************************************************************************
 * Copyright (C) 2005-2015 UC Mobile Limited. All Rights Reserved
 * File			: UCHistoryRecordManager.h
 *
 * Description	: UCHistoryRecordManager
 *
 * Author		: zengkui.wzk@alibaba-inc.com
 *
 * History		: Creation, 16/3/9, zengkui.wzk@alibaba-inc.com, Create the file
 ******************************************************************************
 **/

#import <Foundation/Foundation.h>

@interface UCHistoryRecordManager : NSObject

+ (UCHistoryRecordManager *)sharedInstance;

- (void)addHistoryRecord:(id)record;
- (void)removeHistoryRecord:(id)record;
- (void)removeAllHistoryRecord;
- (void)flushAll; // write all history records to file

@property (nonatomic, readonly, retain) NSMutableArray *records;

@end

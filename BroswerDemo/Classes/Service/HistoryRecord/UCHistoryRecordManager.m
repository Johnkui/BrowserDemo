/*
 *****************************************************************************
 * Copyright (C) 2005-2015 UC Mobile Limited. All Rights Reserved
 * File			: UCHistoryRecordManager.m
 *
 * Description	: UCHistoryRecordManager
 *
 * Author		: zengkui.wzk@alibaba-inc.com
 *
 * History		: Creation, 16/3/9, zengkui.wzk@alibaba-inc.com, Create the file
 ******************************************************************************
 **/

#import "UCHistoryRecordManager.h"

@interface UCHistoryRecordManager()
{
    dispatch_queue_t m_queue;
    NSLock* m_lock;
}

@property (nonatomic, readwrite, retain) NSMutableArray *records;

@end

@implementation UCHistoryRecordManager

+ (UCHistoryRecordManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    static UCHistoryRecordManager* sharedHistoryRecordManager = nil;
    
    dispatch_once(&onceToken, ^{
        sharedHistoryRecordManager = [[UCHistoryRecordManager alloc] init];
    });
    
    return sharedHistoryRecordManager;
}


- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        m_queue = dispatch_queue_create("com.johnkui.historyRecordQueue", DISPATCH_QUEUE_SERIAL);
        m_lock = [[NSLock alloc] init];
        
        dispatch_async(m_queue, ^{
            NSArray *records = [self readHistoryRecord];
            if (records.count > 0)
            {
                _records = [[NSMutableArray arrayWithArray:records] retain];
            }
            else
            {
                _records = [NSMutableArray new];
            }
        });
    }
    
    return self;
}

- (void)dealloc
{
    _records = nil;
    [m_lock release];
    m_lock = nil;
    
    [super dealloc];
}

#pragma mark - Public Interfaces

- (void)addHistoryRecord:(id)record
{
    if (record != nil)
    {
        [self.records addObject:record];
        [self flushAll];
    }
}

- (void)removeHistoryRecord:(id)record
{
    if (record != nil)
    {
        [self.records removeObject:record];
        [self flushAll];
    }
}

- (void)removeAllHistoryRecord
{
    [self.records removeAllObjects];
//    [self flushAll];
    [self clearAllCaches];
}

- (void)flushAll
{
    dispatch_async(m_queue, ^{
        [m_lock lock];
        [self writeData:self.records];
        [m_lock unlock];
    });
}

#pragma mark - Private Interfaces

- (NSString *)archivePath
{
    NSString *archiveDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    archiveDirectory = [archiveDirectory stringByAppendingPathComponent:@"historyRecords"];
    
    BOOL isDir = NO;
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:archiveDirectory
                                              isDirectory:&isDir] && isDir == NO)
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:archiveDirectory
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:&error];
    }
    
    NSString *archivePath = [archiveDirectory stringByAppendingPathComponent:@"records.archiver"];
    
    return archivePath;
}

- (NSArray *)readHistoryRecord
{
    NSString *archivePath = [self archivePath];
    
    NSArray *records = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
    
    return records;
}

- (void)writeData:(id)data
{
    NSString *archivePath = [self archivePath];
    
    if (![NSKeyedArchiver archiveRootObject:data toFile:archivePath])
    {
        NSLog(@"archive failed \n absoulatePath= %@", archivePath);
    }
}

- (BOOL)clearAllCaches
{
    NSString *cacheDirectory = [[self archivePath] stringByDeletingLastPathComponent];
    BOOL isAllCachesCleared = YES;
    
    NSError *error = nil;
    BOOL isDir = YES;
    NSString *cacheItemPath = nil;
    
    NSArray *cacheItems =
    [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cacheDirectory
                                                        error:&error];
    if (!error && cacheItems.count > 0)
    {
        for (NSString *cacheItem in cacheItems)
        {
            cacheItemPath = [cacheDirectory stringByAppendingPathComponent:cacheItem];
            if ([[NSFileManager defaultManager] fileExistsAtPath:cacheItemPath
                                                     isDirectory:&isDir] && !isDir)
            {
                isAllCachesCleared =
                [[NSFileManager defaultManager] removeItemAtPath:cacheItemPath
                                                           error:&error];
            }
        }
    }
    return isAllCachesCleared;
}

@end

/*
 *****************************************************************************
 * Copyright (C) 2005-2015 UC Mobile Limited. All Rights Reserved
 * File			: UCHistoryRecordModel.m
 *
 * Description	: UCHistoryRecordModel
 *
 * Author		: zengkui.wzk@alibaba-inc.com
 *
 * History		: Creation, 16/3/10, zengkui.wzk@alibaba-inc.com, Create the file
 ******************************************************************************
 **/

#import "UCHistoryRecordModel.h"

static NSString *kTitleKey = @"title";
static NSString *kDateKey = @"date";
static NSString *kUrlKey = @"url";

@interface UCHistoryRecordModel ()

@property (nonatomic, readwrite, copy) NSString *title;
@property (nonatomic, readwrite, copy) NSString *date;
@property (nonatomic, readwrite, copy) NSString *url;

@end

@implementation UCHistoryRecordModel

+ (UCHistoryRecordModel *) historyRecordWith:(NSString *)title
                                        date:(NSString *)date
                                         url:(NSString *)url
{
    UCHistoryRecordModel * historyRecord = [[[UCHistoryRecordModel alloc] init] autorelease];
    historyRecord.title = title;
    historyRecord.date = date;
    historyRecord.url = url;
    
    return historyRecord;
}

#pragma mark - Life Cycle

- (void)dealloc
{
    [_title release];
    [_date release];
    [_url release];
    
    _title = nil;
    _date = nil;
    _url = nil;
    
    [super dealloc];
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.title = [aDecoder decodeObjectForKey:kTitleKey];
        self.date = [aDecoder decodeObjectForKey:kDateKey];
        self.url = [aDecoder decodeObjectForKey:kUrlKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:kTitleKey];
    [aCoder encodeObject:self.date forKey:kDateKey];
    [aCoder encodeObject:self.url forKey:kUrlKey];
}

#pragma mark - Log

- (NSString *)description
{
    NSString *description = [NSString stringWithFormat:@"<标题：%@>,<地址：%@>,<时间：%@>",self.title, self.url, self.date];
    return description;
}

@end

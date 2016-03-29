/*
 *****************************************************************************
 * Copyright (C) 2005-2015 UC Mobile Limited. All Rights Reserved
 * File			: UCHistoryRecordModel.h
 *
 * Description	: UCHistoryRecordModel
 *
 * Author		: zengkui.wzk@alibaba-inc.com
 *
 * History		: Creation, 16/3/10, zengkui.wzk@alibaba-inc.com, Create the file
 ******************************************************************************
 **/

#import <Foundation/Foundation.h>

@interface UCHistoryRecordModel : NSObject<NSCoding>

@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *date;
@property (nonatomic, readonly, copy) NSString *url;

+ (UCHistoryRecordModel *) historyRecordWith:(NSString *)title
                                        date:(NSString *)date
                                         url:(NSString *)url;

@end

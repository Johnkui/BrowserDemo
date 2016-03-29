/*
 *****************************************************************************
 * Copyright (C) 2005-2015 UC Mobile Limited. All Rights Reserved
 * File			: UCHistoryRecordViewController.h
 *
 * Description	: UCHistoryRecordViewController -- a view controller used to 
                  preview the history browsing records
 *
 * Author		: zengkui.wzk@alibaba-inc.com
 *
 * History		: Creation, 16/3/9, zengkui.wzk@alibaba-inc.com, Create the file
 ******************************************************************************
 **/

#import <UIKit/UIKit.h>

typedef void (^HistoryRecordSelectedHandler)(NSString *urlString);

@interface UCHistoryRecordViewController : UIViewController

@property (nonatomic, readwrite, copy) HistoryRecordSelectedHandler historyRecrodSelectedHandler;

@end

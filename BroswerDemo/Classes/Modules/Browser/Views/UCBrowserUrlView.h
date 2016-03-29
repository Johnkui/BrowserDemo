/*
 *****************************************************************************
 * Copyright (C) 2005-2015 UC Mobile Limited. All Rights Reserved
 * File			: UCBrowserUrlView.h
 *
 * Description	: UCBrowserUrlView -- URL input view in browser
 *
 * Author		: zengkui.wzk@alibaba-inc.com
 *
 * History		: Creation, 16/3/8, zengkui.wzk@alibaba-inc.com, Create the file
 ******************************************************************************
 **/

#import <UIKit/UIKit.h>

@class UCBrowserUrlView;

@protocol UCBrowserUrlViewDelegate <NSObject>

@optional
- (void)browserUrlView:(UCBrowserUrlView *)browserUrlView startLoadingUrl:(NSString *)url;
- (void)browserUrlView:(UCBrowserUrlView *)browserUrlView stopLoadingUrl:(NSString *)url;

@end


@interface UCBrowserUrlView : UIView

@property (nonatomic, getter=isLoading, assign) BOOL loading;
@property (nonatomic, readwrite, copy) NSString* urlString;

@property (nonatomic, readwrite, assign) id<UCBrowserUrlViewDelegate> delegate;

@end

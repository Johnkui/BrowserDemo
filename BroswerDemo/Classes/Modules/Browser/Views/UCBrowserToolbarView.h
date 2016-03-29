/*
 *****************************************************************************
 * Copyright (C) 2005-2015 UC Mobile Limited. All Rights Reserved
 * File			: UCBrowserToolbarView.h
 *
 * Description	: UCBrowserToolbarView
 *
 * Author		: zengkui.wzk@alibaba-inc.com
 *
 * History		: Creation, 16/3/8, zengkui.wzk@alibaba-inc.com, Create the file
 ******************************************************************************
 **/

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UCBrowserToolbarItem)
{
    UCBrowserToolbarItemBack = 1000,
    UCBrowserToolbarItemForward,
    UCBrowserToolbarItemFileBrowse,
    UCBrowserToolbarItemHistoryBrowse,
    UCBrowserToolbarItemPages
};

@class UCBrowserToolbarView;

@protocol UCBrowserToolbarViewDelegate <NSObject>

@optional
- (void)browserToolbarView:(UCBrowserToolbarView *)toolbarView
        didClickActionItem:(UCBrowserToolbarItem)item;

@end

@interface UCBrowserToolbarView : UIView
@property (nonatomic, readwrite, assign)id<UCBrowserToolbarViewDelegate> delegate;
@property (nonatomic, readwrite, assign)BOOL canGoBack;
@property (nonatomic, readwrite, assign)BOOL canGoFoward;
@end

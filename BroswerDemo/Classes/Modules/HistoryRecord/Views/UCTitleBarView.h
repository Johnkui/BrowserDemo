/*
 *****************************************************************************
 * Copyright (C) 2005-2015 UC Mobile Limited. All Rights Reserved
 * File			: TitleBarView.h
 *
 * Description	: UCTitleBarView
 *
 * Author		: zengkui.wzk@alibaba-inc.com
 *
 * History		: Creation, 16/3/9, zengkui.wzk@alibaba-inc.com, Create the file
 ******************************************************************************
 **/

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UCTitleBarItem)
{
    UCTitleBarItemLeft = 1000,
    UCTitleBarItemRight
};

@class UCTitleBarView;

@protocol UCTitleBarItemViewDelegate <NSObject>

@optional
- (void)titleBarView:(UCTitleBarView *)titleBarView
        didClickActionItem:(UCTitleBarItem)item;

@end

@interface UCTitleBarView : UIView
@property (nonatomic, readwrite, assign) id<UCTitleBarItemViewDelegate> delegate;

@property (nonatomic, readonly, retain) UILabel *titleLabel;
@property (nonatomic, readonly, retain) UIButton *leftButton;
@property (nonatomic, readonly, retain) UIButton *rightButton;

@end

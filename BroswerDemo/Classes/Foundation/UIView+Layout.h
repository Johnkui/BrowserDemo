/*
 *****************************************************************************
 * Copyright (C) 2005-2016 UC Mobile Limited. All Rights Reserved
 * File			: UIView+Layout.h
 *
 * Description	: A category of UIView for convinience using of some origional
                  properties such as width, height, origion x, y, etc.
 *
 * Author		: zengkui.wzk@alibaba-inc.com
 *
 * History		: Creation, 16/3/8, zengkui.wzk@alibaba-inc.com, Create the file
 ******************************************************************************
 **/

#import <UIKit/UIKit.h>

@interface UIView (Layout)

@property (nonatomic, readwrite, assign) CGFloat x;
@property (nonatomic, readwrite, assign) CGFloat y;
@property (nonatomic, readwrite, assign) CGFloat width;
@property (nonatomic, readwrite, assign) CGFloat height;

@property (nonatomic, readwrite, assign) CGFloat right;
@property (nonatomic, readwrite, assign) CGFloat bottom;

@end

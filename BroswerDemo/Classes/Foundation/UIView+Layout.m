/*
 *****************************************************************************
 * Copyright (C) 2005-2016 UC Mobile Limited. All Rights Reserved
 * File			: UCBrowserViewController.h
 *
 * Description	: UCBrowserViewController -- implement a browser with minimum
 functionalities including page refreshing, page backward/forward,
 browsing history summary, documents managing and file downloading.
 *
 * Author		: zengkui.wzk@alibaba-inc.com
 *
 * History		: Creation, 16/3/8, zengkui.wzk@alibaba-inc.com, Create the file
 ******************************************************************************
 **/

#import "UIView+Layout.h"

static CGFloat NearZero = 1e-3;

@implementation UIView (Layout)

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x
{
    if (fabs(x - self.x) <=  NearZero)
    {
        CGRect frame = self.frame;
        frame.origin.x = x;
        self.frame = frame;
    }
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y
{
    if (fabs(y - self.y) <=  NearZero)
    {
        CGRect frame = self.frame;
        frame.origin.y = y;
        self.frame = frame;
    }
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    if (fabs(width - self.width) <=  NearZero)
    {
        CGRect frame = self.frame;
        frame.size.width = width;
        self.frame = frame;
    }
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    if (fabs(height - self.height) <=  NearZero)
    {
        CGRect frame = self.frame;
        frame.size.height = height;
        self.frame = frame;
    }
}

- (CGFloat)right
{
    return self.x + self.width;
}

- (void)setRight:(CGFloat)right
{
    if (fabs(right - self.right) <=  NearZero)
    {
        CGRect frame = self.frame;
        frame.origin.x = right - self.width;
        self.frame = frame;
    }
}

- (CGFloat)bottom
{
    return self.y + self.height;
}

- (void)setBottom:(CGFloat)bottom
{
    if (fabs(bottom - self.bottom) <=  NearZero)
    {
        CGRect frame = self.frame;
        frame.origin.y = bottom - self.height;
        self.frame = frame;
    }
}

@end

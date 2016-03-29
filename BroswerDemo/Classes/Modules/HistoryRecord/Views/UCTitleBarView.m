/*
 *****************************************************************************
 * Copyright (C) 2005-2015 UC Mobile Limited. All Rights Reserved
 * File			: UCTitleBarView.m
 *
 * Description	: UCTitleBarView
 *
 * Author		: zengkui.wzk@alibaba-inc.com
 *
 * History		: Creation, 16/3/9, zengkui.wzk@alibaba-inc.com, Create the file
 ******************************************************************************
 **/

#import "UCTitleBarView.h"
#import "UIView+Layout.h"

@interface UCTitleBarView ()<UITextFieldDelegate>

@property (nonatomic, readwrite, retain) UILabel *titleLabel;
@property (nonatomic, readwrite, retain) UIButton *leftButton;
@property (nonatomic, readwrite, retain) UIButton *rightButton;

@end

@implementation UCTitleBarView

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        [self initTitleBarView];
    }
    return self;
}

- (void)dealloc
{
    [_leftButton removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
    [_rightButton removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];

    [_titleLabel release];
    _titleLabel = nil;
    
    [_leftButton release];
    _leftButton = nil;
    
    [_rightButton release];
    _rightButton = nil;
    
    [super dealloc];
}

- (void)initTitleBarView
{

    self.titleLabel = [[[UILabel alloc] init] autorelease];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.text = @"历史记录";
    
    [self addSubview:self.titleLabel];
    
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.leftButton setTitle:@"返回" forState:UIControlStateNormal];
    UIColor *color = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    [self.leftButton setTitleColor:color forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.leftButton addTarget:self
                     action:@selector(actionButtonFired:)
             forControlEvents:UIControlEventTouchUpInside];
    self.leftButton.tag = UCTitleBarItemLeft;
    
    [self addSubview:self.leftButton];
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.rightButton setTitle:@"关闭" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:color forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.rightButton addTarget:self
                         action:@selector(actionButtonFired:)
               forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.tag = UCTitleBarItemRight;

    [self addSubview:self.rightButton];

}

#pragma mark - Layout

- (void)layoutSubviews
{
    static CGFloat marginX = 5;
    static CGFloat buttonWidth = 60;
    static CGFloat buttonHeight = 44;
    static CGFloat labelHeight = 44;
    
    CGFloat width = buttonWidth;
    CGFloat height = buttonHeight;
    CGFloat x = marginX, y = (self.height - buttonHeight) / 2;
    
    self.leftButton.frame = CGRectMake(x, y, width, height);
    
    x = self.width - marginX - buttonWidth;
    self.rightButton.frame = CGRectMake(x, y, width, height);
    
    width = self.width - 2 * (buttonWidth + marginX);
    height = labelHeight;
    x = (self.width - width) / 2, y = (self.height - buttonHeight) / 2;
    self.titleLabel.frame = CGRectMake(x, y, width, height);
}

#pragma mark - Event Response

- (void)actionButtonFired:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(titleBarView:didClickActionItem:)])
    {
        [self.delegate titleBarView:self didClickActionItem:sender.tag];
    }
}

@end
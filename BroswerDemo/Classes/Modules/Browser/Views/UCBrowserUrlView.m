/*
 *****************************************************************************
 * Copyright (C) 2005-2015 UC Mobile Limited. All Rights Reserved
 * File			: UCBrowserUrlView.m
 *
 * Description	: UCBrowserUrlView
 *
 * Author		: zengkui.wzk@alibaba-inc.com
 *
 * History		: Creation, 16/3/8, zengkui.wzk@alibaba-inc.com, Create the file
 ******************************************************************************
 **/

#import "UCBrowserUrlView.h"
#import "UIView+Layout.h"

@interface UCBrowserUrlView()<UITextFieldDelegate>
{
    UITextField* m_urlTextField;
    UIButton* m_actionButton;
}
@end


@implementation UCBrowserUrlView

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        [self initBrowserUrlView];
    }
    return self;
}

- (void)dealloc
{
    [m_urlTextField release];
    m_urlTextField = nil;
    
    [m_actionButton removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
    [m_actionButton release];
    m_actionButton = nil;
    
    [_urlString release];
    _urlString = nil;
    
    [super dealloc];
}

- (void)initBrowserUrlView
{
    m_urlTextField = [[UITextField alloc] init];
    m_urlTextField.placeholder = @"请输入网址";
    m_urlTextField.backgroundColor = [UIColor lightGrayColor];
    m_urlTextField.borderStyle = UITextBorderStyleRoundedRect;
    m_urlTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    m_urlTextField.textColor = [UIColor blackColor];
    m_urlTextField.font = [UIFont systemFontOfSize:12];
    m_urlTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    m_urlTextField.keyboardType = UIKeyboardTypeWebSearch;
    m_urlTextField.returnKeyType = UIReturnKeyGo;
    m_urlTextField.delegate = self;
    
    [self addSubview:m_urlTextField];
    
    m_actionButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [m_actionButton addTarget:self
                       action:@selector(actionButtonFired:)
             forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:m_actionButton];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    m_urlTextField.frame = self.bounds;
    
    CGFloat width = 12;
    CGFloat height = width * 30.0 / 26;
    CGFloat x = m_urlTextField.width - width - 5, y = (m_urlTextField.height - height ) / 2;
    
    m_actionButton.frame = CGRectMake(x, y, width, height);
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    m_actionButton.hidden = YES;
    m_urlTextField.textAlignment = NSTextAlignmentLeft;

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    NSCharacterSet* characterSet = [NSCharacterSet whitespaceCharacterSet];
    NSString* url = [textField.text stringByTrimmingCharactersInSet:characterSet];

    if (url.length > 0 && [self.delegate respondsToSelector:@selector(browserUrlView:startLoadingUrl:)])
    {
        [self.delegate browserUrlView:self startLoadingUrl:url];
    }
    
    return YES;
}

#pragma mark - Event Response

- (void)actionButtonFired:(UIButton *)sender
{
    sender.enabled = NO;
    
    NSCharacterSet* characterSet = [NSCharacterSet whitespaceCharacterSet];
    NSString* url = [m_urlTextField.text stringByTrimmingCharactersInSet:characterSet];

    if (self.isLoading)
    {
        if (url.length > 0 && [self.delegate respondsToSelector:@selector(browserUrlView:stopLoadingUrl:)])
        {
            [self.delegate browserUrlView:self stopLoadingUrl:url];
        }
    }
    else
    {
        if (url.length > 0 && [self.delegate respondsToSelector:@selector(browserUrlView:startLoadingUrl:)])
        {
            [self.delegate browserUrlView:self startLoadingUrl:url];
        }
    }
    
    sender.enabled = YES;
}

#pragma mark - Getters & Setters

- (void)setLoading:(BOOL)loading
{
    m_actionButton.hidden = NO;
    m_urlTextField.textAlignment = NSTextAlignmentCenter;
    
    if (loading)
    {
        UIImage *image = [UIImage imageNamed:@"NavigationBarStopLoading"];
        [m_actionButton setImage:image forState:UIControlStateNormal];
    }
    else
    {
        UIImage *image = [UIImage imageNamed:@"NavigationBarReload"];
        [m_actionButton setImage:image forState:UIControlStateNormal];
    }
}

- (void)setUrlString:(NSString *)urlString
{
    if (urlString == _urlString)
    {
        return;
    }
    
    [_urlString release];
    _urlString = [urlString copy];
    
    m_urlTextField.text = _urlString;
}

@end

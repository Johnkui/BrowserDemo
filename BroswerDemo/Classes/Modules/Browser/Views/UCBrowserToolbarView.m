/*
 *****************************************************************************
 * Copyright (C) 2005-2015 UC Mobile Limited. All Rights Reserved
 * File			: UCBrowserToolbarView.m
 *
 * Description	: UCBrowserToolbarView
 *
 * Author		: zengkui.wzk@alibaba-inc.com
 *
 * History		: Creation, 16/3/8, zengkui.wzk@alibaba-inc.com, Create the file
 ******************************************************************************
 **/

#import "UCBrowserToolbarView.h"

@interface UCBrowserToolbarView()
{
    UIToolbar* m_toolBar;
}
@end

@implementation UCBrowserToolbarView

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initBrowserToolbarView];
    }
    return self;
}

- (void)dealloc
{
    [m_toolBar release];
    m_toolBar = nil;
    
    [super dealloc];
}

- (void)initBrowserToolbarView
{
    m_toolBar = [[UIToolbar alloc] init];
    
    UIBarButtonItem* backItem = [self toolbarItemWithImage:@"UIButtonBarArrowLeft"
                                                       tag:UCBrowserToolbarItemBack];
    
    UIBarButtonItem* forwardItem = [self toolbarItemWithImage:@"UIButtonBarArrowRight"
                                                          tag:UCBrowserToolbarItemForward];
    
    UIBarButtonItem* fileBrowseItem = [self toolbarItemWithImage:@"UIButtonBarAction"
                                                             tag:UCBrowserToolbarItemFileBrowse];
    
    UIBarButtonItem* historyBrowseItem = [self toolbarItemWithImage:@"UIButtonBarBookmarks"
                                                                tag:UCBrowserToolbarItemHistoryBrowse];
    
    UIBarButtonItem* pagesItem = [self toolbarItemWithImage:@"UIButtonBarPages"
                                                        tag:UCBrowserToolbarItemPages];
    
    UIBarButtonItem* flexibleItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:nil
                                                                                  action:nil] autorelease];
    
    NSArray *items = [NSArray arrayWithObjects:flexibleItem,backItem,
                      flexibleItem,forwardItem,
                      flexibleItem,fileBrowseItem,
                      flexibleItem,historyBrowseItem,
                      flexibleItem,pagesItem,flexibleItem,nil];
    
    [m_toolBar setItems:items];
    
    [self addSubview:m_toolBar];
}

- (void)layoutSubviews
{
    m_toolBar.frame = self.bounds;
}

#pragma mark - Event Response

- (void)toolbarButtonFired:(UIBarButtonItem *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(browserToolbarView:didClickActionItem:)])
    {
        [self.delegate browserToolbarView:self didClickActionItem:sender.tag];
    }
}

#pragma mark - Getters & Setters

- (void)setCanGoBack:(BOOL)canGoBack
{
    _canGoBack = canGoBack;
    UIBarButtonItem* backItem = [self toolbarItemWithTag:UCBrowserToolbarItemBack];
    backItem.enabled = canGoBack;
}

- (void)setCanGoFoward:(BOOL)canGoFoward
{
    _canGoFoward = canGoFoward;
    UIBarButtonItem* forwardItem = [self toolbarItemWithTag:UCBrowserToolbarItemForward];
    forwardItem.enabled = canGoFoward;
}

#pragma mark - Helpers

- (UIBarButtonItem *)toolbarItemWithTag:(NSInteger)tag
{
    __block NSUInteger index = NSNotFound;
    
    [m_toolBar.items enumerateObjectsUsingBlock:^(UIBarButtonItem *obj, NSUInteger idx, BOOL *stop) {
        if (tag == obj.tag)
        {
            index = idx;
            *stop = YES;
        }
    }];
    
    UIBarButtonItem *item = nil;
    if (NSNotFound != index)
    {
        item = m_toolBar.items[index];
    }

    return item;
}

- (UIBarButtonItem *)toolbarItemWithImage:(NSString *)name tag:(NSInteger)tag
{
    UIBarButtonItem* item = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:name]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(toolbarButtonFired:)] autorelease];
    item.tag = tag;
    return item;

}

@end

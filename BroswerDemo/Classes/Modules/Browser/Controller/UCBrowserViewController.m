/*
 *****************************************************************************
 * Copyright (C) 2005-2016 UC Mobile Limited. All Rights Reserved
 * File			: UCBrowserViewController.m
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

#import "UCBrowserViewController.h"
#import "UCBrowserUrlView.h"
#import "UCBrowserToolbarView.h"
#import "UIView+Layout.h"
#import "UCHistoryRecordViewController.h"
#import "UCFileBrowserViewController.h"
#import "UCHistoryRecordManager.h"
#import "UCHistoryRecordModel.h"

@interface UCBrowserViewController ()<UIWebViewDelegate,
UCBrowserUrlViewDelegate,UCBrowserToolbarViewDelegate>
{
    UCBrowserUrlView* m_browserUrlView;
    UCBrowserToolbarView* m_browserToolbarView;
    UIWebView* m_webView;
}
@end

@implementation UCBrowserViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    m_browserUrlView = [[UCBrowserUrlView alloc] initWithFrame:CGRectZero];
    m_browserUrlView.delegate = self;

    [self.view addSubview:m_browserUrlView];
    
    m_webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    m_webView.delegate = self;
    
    [self.view addSubview:m_webView];
    
    m_browserToolbarView = [[UCBrowserToolbarView alloc] initWithFrame:CGRectZero];
    m_browserToolbarView.delegate = self;
    m_browserToolbarView.canGoBack = m_webView.canGoBack;
    m_browserToolbarView.canGoFoward = m_webView.canGoForward;
    
    [self.view addSubview:m_browserToolbarView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat x = 5, y = 25;
    CGFloat width = self.view.width - 2 * x, height = 25;
    
    m_browserUrlView.frame = CGRectMake(x, y, width, height);
    
    x = 0, y = m_browserUrlView.bottom + 5;
    height = self.view.height - y - 44, width = self.view.width;
    m_webView.frame = CGRectMake(x, y, width, height);
    
    x = 0, y = m_webView.bottom, height = 44, width = self.view.width;
    m_browserToolbarView.frame = CGRectMake(x, y, width, height);
}

- (void)dealloc
{
    m_browserToolbarView.delegate = nil;
    [m_browserUrlView release];
    m_browserUrlView = nil;
    
    m_webView.delegate = nil;
    [m_webView release];
    m_webView = nil;
    
    m_browserToolbarView.delegate = nil;
    [m_browserToolbarView release];
    m_browserToolbarView = nil;
    
    [super dealloc];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView
        shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    m_browserUrlView.urlString = webView.request.URL.absoluteString;
    m_browserUrlView.loading = NO;
    
    m_browserToolbarView.canGoBack = m_webView.canGoBack;
    m_browserToolbarView.canGoFoward = m_webView.canGoForward;

    NSString *title = [m_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self addHistoryRecord:webView.request.URL.absoluteString title:title];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    m_browserUrlView.urlString = webView.request.URL.absoluteString;
    m_browserUrlView.loading = NO;
    
    m_browserToolbarView.canGoBack = m_webView.canGoBack;
    m_browserToolbarView.canGoFoward = m_webView.canGoForward;
}

#pragma mark - UCBrowserUrlViewDelegate

- (void)browserUrlView:(UCBrowserUrlView *)browserUrlView startLoadingUrl:(NSString *)url
{

    [self loadRequest:url];
    browserUrlView.loading = YES;
}

- (void)browserUrlView:(UCBrowserUrlView *)browserUrlView stopLoadingUrl:(NSString *)url
{
    [m_webView stopLoading];
}

#pragma mark - UCBrowserToolbarViewDelegate

- (void)browserToolbarView:(UCBrowserToolbarView *)toolbarView
        didClickActionItem:(UCBrowserToolbarItem)item
{
    switch (item)
    {
        case UCBrowserToolbarItemBack:
        {
            if (m_webView.canGoBack)
            {
                [m_webView goBack];
            }
            break;
        }
            
        case UCBrowserToolbarItemForward:
        {
            if (m_webView.canGoForward)
            {
                [m_webView goForward];
            }
            break;
        }
            
        case UCBrowserToolbarItemFileBrowse:
        {
            UCFileBrowserViewController *fileBrowserVC = [[[UCFileBrowserViewController alloc] init] autorelease];
            UINavigationController *navigationVC = [[[UINavigationController alloc] initWithRootViewController:fileBrowserVC] autorelease];
            [self presentViewController:navigationVC animated:YES completion:nil];
            break;
        }
            
        case UCBrowserToolbarItemHistoryBrowse:
        {
            UCHistoryRecordViewController *historyRecordVC = [[[UCHistoryRecordViewController alloc] init] autorelease];
            __block __typeof(self) wself = self;
            historyRecordVC.historyRecrodSelectedHandler = ^(NSString *urlString) {
                [wself loadRequest:urlString];
            };
            [self presentViewController:historyRecordVC animated:YES completion:nil];
            break;
        }
            
        case UCBrowserToolbarItemPages:
        {
            break;
        }
            
        default:
        {
            break;
        }
    }
}

#pragma mark - Helpers

- (void)loadRequest:(NSString *)url
{
    [m_webView stopLoading];
    
    NSString* urlString = nil;
    
    if (0 >= [url rangeOfString:@"http"].length)
    {
        urlString = [NSString stringWithFormat:@"http://%@",url];
    }
    else
    {
        urlString = url;
    }
    
    NSURL* URL = [NSURL URLWithString:urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:URL];
    [m_webView loadRequest:request];
}

- (void)addHistoryRecord:(NSString *)urlString title:(NSString *)title
{
    __block NSInteger index = NSNotFound;
    
    NSArray *records = [UCHistoryRecordManager sharedInstance].records;
    [records enumerateObjectsUsingBlock:^(UCHistoryRecordModel *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.url isEqualToString:urlString])
        {
            index = idx;
            *stop = YES;
        }
    }];
    
    if (NSNotFound == index)
    {
        NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateFormat:@"yyyy-MM-DD HH:MM"];
        NSString *date = [formatter stringFromDate:[NSDate date]];
        
        UCHistoryRecordModel *historyRecord = [UCHistoryRecordModel historyRecordWith:title
                                                                                 date:date
                                                                                  url:urlString];
        [[UCHistoryRecordManager sharedInstance] addHistoryRecord:historyRecord];
    }
}

@end

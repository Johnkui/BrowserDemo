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


#import "UCHistoryRecordViewController.h"
#import "UIView+Layout.h"
#import "UCHistoryRecordManager.h"
#import "UCTitleBarView.h"
#import "UCHistoryRecordModel.h"

@interface UCHistoryRecordViewController ()<UITableViewDataSource,UITableViewDelegate,
UCTitleBarItemViewDelegate,UIAlertViewDelegate>
{
    UCTitleBarView* m_titleBarView;
    UITableView* m_recordTableView;
    UCTitleBarView* m_toolBarView;
}
@end

@implementation UCHistoryRecordViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    m_titleBarView = [[UCTitleBarView alloc] initWithFrame:CGRectZero];
    m_titleBarView.leftButton.hidden = YES;
    m_titleBarView.delegate = self;
    
    [self.view addSubview:m_titleBarView];
    
    m_toolBarView = [[UCTitleBarView alloc] initWithFrame:CGRectZero];
    m_toolBarView.titleLabel.hidden = YES;
    m_toolBarView.leftButton.enabled = [[UCHistoryRecordManager sharedInstance] records].count > 0;
    m_toolBarView.rightButton.enabled = [[UCHistoryRecordManager sharedInstance] records].count > 0;
    [m_toolBarView.leftButton setTitle:@"清空" forState:UIControlStateNormal];
    [m_toolBarView.rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    m_toolBarView.delegate = self;
    
    [self.view addSubview:m_toolBarView];
    
    m_recordTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    m_recordTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    m_recordTableView.delegate = self;
    m_recordTableView.dataSource = self;
    
    [self.view addSubview:m_recordTableView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    static CGFloat statusBarHeight = 20;
    static CGFloat titleBarHeight = 44;
    static CGFloat toolBarHeight = 44;
    CGFloat screenWidth = self.view.width;
    CGFloat screenHeight = self.view.height;
    
    CGFloat x = 0, y = statusBarHeight, width = screenWidth, height = titleBarHeight;
    m_titleBarView.frame = CGRectMake(x, y, width, height);

    x = 0, y = statusBarHeight + titleBarHeight, width = screenWidth, height = screenHeight - y - toolBarHeight;
    m_recordTableView.frame = CGRectMake(x, y, width, height);
    
    x = 0, y = m_recordTableView.bottom, width = screenWidth, height = toolBarHeight;
    m_toolBarView.frame = CGRectMake(x,y,width,height);
}

- (void)dealloc
{
    [m_recordTableView release];
    m_recordTableView = nil;
    
    m_titleBarView.delegate = nil;
    [m_titleBarView release];
    m_titleBarView = nil;
    
    m_toolBarView.delegate = nil;
    [m_toolBarView release];
    m_toolBarView = nil;
    
    [_historyRecrodSelectedHandler release];
    _historyRecrodSelectedHandler = nil;
    
    [super dealloc];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return[[UCHistoryRecordManager sharedInstance] records].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellID] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UITableViewCellEditingStyleDelete == editingStyle)
    {
        NSArray *records = [[UCHistoryRecordManager sharedInstance] records];
        id record = [records objectAtIndex:indexPath.row];
        [[UCHistoryRecordManager sharedInstance] removeHistoryRecord:record];

        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]
                         withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
        
        m_toolBarView.leftButton.enabled = [[UCHistoryRecordManager sharedInstance] records].count > 0;
        m_toolBarView.rightButton.enabled = [[UCHistoryRecordManager sharedInstance] records].count > 0;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *records = [[UCHistoryRecordManager sharedInstance] records];
    if (records.count > indexPath.row)
    {
        UCHistoryRecordModel *record = (UCHistoryRecordModel *)records[indexPath.row];
        cell.textLabel.text = record.title;
        cell.detailTextLabel.text = record.url;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *records = [[UCHistoryRecordManager sharedInstance] records];
    if (records.count > indexPath.row && self.historyRecrodSelectedHandler)
    {
        NSString *urlString = ((UCHistoryRecordModel *)records[indexPath.row]).url;
        self.historyRecrodSelectedHandler(urlString);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark - UCTitleBarViewDelegate

- (void)titleBarView:(UCTitleBarView *)titleBarView didClickActionItem:(UCTitleBarItem)item
{
    if (titleBarView == m_titleBarView)
    {
        if (UCTitleBarItemRight == item)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else if (UCTitleBarItemLeft == item)
        {
            
        }
    }
    else if (titleBarView == m_toolBarView)
    {
        if (UCTitleBarItemRight == item)
        {
            m_recordTableView.editing = !m_recordTableView.editing;
            
            NSString *title = m_recordTableView.editing ? @"完成" : @"编辑";
            [titleBarView.rightButton setTitle:title forState:UIControlStateNormal];
        }
        else if (UCTitleBarItemLeft == item)
        {
            [self clearHistoryRecords];
        }
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        
        [[UCHistoryRecordManager sharedInstance] removeAllHistoryRecord];
        
        [m_recordTableView reloadData];
        
        m_toolBarView.leftButton.enabled = NO;
        m_toolBarView.rightButton.enabled = NO;

    }
}

#pragma mark - Helpers

- (void)clearHistoryRecords
{
    NSArray *records = [[UCHistoryRecordManager sharedInstance] records];
    if(records.count > 0)
    {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@""
                                                            message:@"确定清空历史记录吗？"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil] autorelease];
        [alertView show];
    }
}

@end

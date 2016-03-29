/*
 *****************************************************************************
 * Copyright (C) 2005-2015 UC Mobile Limited. All Rights Reserved
 * File			: UCFileBrowserViewController.m
 *
 * Description	: UCFileBrowserViewController
 *
 * Author		: zengkui.wzk@alibaba-inc.com
 *
 * History		: Creation, 16/3/10, zengkui.wzk@alibaba-inc.com, Create the file
 ******************************************************************************
 **/

#import "UCFileBrowserViewController.h"
#import "UCFileManager.h"

static NSInteger kFileRemoveAlertViewTag = 1000;
static NSInteger kFileNameInputAlertViewTag = 1001;

@interface UCFileBrowserViewController ()<UIActionSheetDelegate, UIAlertViewDelegate>

@property (nonatomic, readwrite, copy) NSArray *fileItems;
@property (nonatomic, readwrite, assign) BOOL willCreateFile;
@property (nonatomic, readwrite, assign) NSInteger willRemoveFileAtRow;

@end

@implementation UCFileBrowserViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _path = [[UCFileManager documentPath] copy];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    self.fileItems = [UCFileManager contentsOfDirectoryAtPath:self.path];
    self.title = [self.path lastPathComponent];
    
    UIBarButtonItem *createFileItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                     target:self
                                                                                     action:@selector(createFileActionFired:)] autorelease];
    
    UIBarButtonItem *closeItem = [[[UIBarButtonItem alloc] initWithTitle:@"关闭"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(closeActionFired:)] autorelease];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:closeItem,createFileItem, nil];

}

- (void)dealloc
{
    [_path release];
    _path = nil;
    
    [_fileItems release];
    _fileItems = nil;
    
    [super dealloc];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fileItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (nil == cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:kCellID] autorelease];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return cell;
}



- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        self.willRemoveFileAtRow = indexPath.row;
        
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:nil
                                                             message:@"确定删除该文件吗？"
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                                   otherButtonTitles:@"确定", nil] autorelease];
        alertView.tag = kFileRemoveAlertViewTag;
        [alertView show];
    }
}

#pragma mark - UITableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.fileItems.count)
    {
        NSDictionary *fileItem = [self.fileItems objectAtIndex:indexPath.row];
        BOOL isDir = [[fileItem objectForKey:kIsDirectoryKey] boolValue];
        NSString *imageName = isDir ? @"UIButtonBarArrowRight" : @"UIButtonBarPages";
        cell.textLabel.text = [fileItem objectForKey:kPathKey];
        cell.imageView.image = [UIImage imageNamed:imageName];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.fileItems.count)
    {
        NSDictionary *fileItem = [self.fileItems objectAtIndex:indexPath.row];
        BOOL isDir = [[fileItem objectForKey:kIsDirectoryKey] boolValue];
        if (isDir)
        {
            UCFileBrowserViewController *fileBrowserVC = [[[UCFileBrowserViewController alloc] init] autorelease];
            fileBrowserVC.path = [self.path stringByAppendingPathComponent:[fileItem objectForKey:kPathKey]];
            [self.navigationController pushViewController:fileBrowserVC animated:YES];
        }
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        self.willCreateFile = NO;
    }
    else if (buttonIndex == 1)
    {
        self.willCreateFile = YES;
    }
    
    NSString *title = self.willCreateFile ? @"文件名称" : @"目录名称";
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:title
                                                     message:nil
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles:@"确定",nil] autorelease];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.tag = kFileNameInputAlertViewTag;
    [alertView show];

}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (kFileNameInputAlertViewTag == alertView.tag)
    {
        if (1 == buttonIndex)
        {
            NSString *inputText = [alertView textFieldAtIndex:0].text;
            BOOL createSucceed = NO;
            
            if (self.willCreateFile)
            {
                createSucceed = [UCFileManager createFile:inputText atPath:self.path];
            }
            else
            {
                createSucceed = [UCFileManager createPath:[self.path stringByAppendingPathComponent:inputText]];
            }
            
            if (createSucceed)
            {
                [self reloadTableView];
            }
        }
    }
    else if (kFileRemoveAlertViewTag == alertView.tag)
    {
        if (1 == buttonIndex)
        {
            NSDictionary *fileItem = [self.fileItems objectAtIndex:self.willRemoveFileAtRow];
            NSString *pathComponent = [fileItem objectForKey:kPathKey];
            NSString *path = [self.path stringByAppendingPathComponent:pathComponent];
            
            if ([UCFileManager removeItemAtPath:path])
            {
                self.fileItems = [UCFileManager contentsOfDirectoryAtPath:self.path];
                [self reloadTableView];
            }
        }
        else
        {
            self.tableView.editing = NO;
        }
    }
}

#pragma mark - Event Response

- (void)createFileActionFired:(id)sender
{
    UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle:@"创建"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"目录", @"文件",nil] autorelease];
    [actionSheet showInView:self.view];
}

- (void)closeActionFired:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Helpers

- (void)reloadTableView
{
    self.fileItems = [UCFileManager contentsOfDirectoryAtPath:self.path];
    [self.tableView reloadData];
}

@end

//
//  COPhotoGroupViewController.m
//  LxAsset
//
//  Created by houzhenyong on 14-6-15.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "COAssetsGroupsViewController.h"
#import "COAssetGroupCell.h"
#import "COAssetsMultiSelectViewController.h"

@interface COAssetsGroupsViewController () <UITableViewDataSource, UITableViewDelegate>{
    UITableView *_tableView;
}

@end

@implementation COAssetsGroupsViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"照片";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem * cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
    self.navigationItem.rightBarButtonItem = cancelButton;
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [COAssetHelper sharedInstance].bReverse = NO;
    [[COAssetHelper sharedInstance] getGroupList:^(NSArray *groupList) {
        [_tableView reloadData];
    }];
}

- (void)onCancel
{
    [self.delegate cancelSelectAssetsGroup];
}

- (void)dealloc
{
    [[COAssetHelper sharedInstance] clearData];
}

#pragma mark- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[COAssetHelper sharedInstance] getGroupCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"cellID_abcdefg";
    COAssetGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[COAssetGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSDictionary *groupInfo = [[COAssetHelper sharedInstance] getGroupInfo:indexPath.row];
    
    [cell setLeftImage:[groupInfo objectForKey:@"thumbnail"] groupName:[groupInfo objectForKey:@"name"] count:[[groupInfo objectForKey:@"count"] integerValue]];

    return cell;
}

#pragma mark- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ALAssetsGroup *assetsGroup = [COAssetHelper sharedInstance].assetGroups[indexPath.row];
    [self.delegate didSelectAssetsGroup:assetsGroup];
}

@end

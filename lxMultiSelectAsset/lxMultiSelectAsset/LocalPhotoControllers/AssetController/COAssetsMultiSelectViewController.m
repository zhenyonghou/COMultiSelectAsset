//
//  COPhotoCollectionViewController.m
//  LxAsset
//
//  Created by houzhenyong on 14-6-16.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//
#import <AssetsLibrary/AssetsLibrary.h>
#import "COAssetsMultiSelectViewController.h"
#import "COImageEnableSelectGridCell.h"
#import "UIImage+ImageWithColor.h"
#import "COFullScreenImageViewerController.h"

static NSString* kCellID = @"cell_laisdfausd8f";

@interface COAssetsMultiSelectViewController () <UICollectionViewDataSource
, UICollectionViewDelegateFlowLayout
, COSelectFlagGridCellDelegate
, COFullScreenImageViewerControllerDelegate> {
    ALAssetsGroup *_assetsGroup;
    UICollectionView *_collectionView;
    UIToolbar *_toolbar;
    NSMutableArray *_selectedIndexsArray;
}

@end

@implementation COAssetsMultiSelectViewController

- (id)initWithAssetsGroup:(ALAssetsGroup*)group
{
    self = [super init];
    if (self) {
        _assetsGroup = group;
        _selectedIndexsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem * cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
    self.navigationItem.rightBarButtonItem = cancelButton;
    
    NSString *name = [_assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    self.title = name;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.allowsMultipleSelection = NO;
    _collectionView.alwaysBounceVertical = YES;
    [_collectionView registerClass:[COImageEnableSelectGridCell class] forCellWithReuseIdentifier:kCellID];
    [self.view addSubview:_collectionView];
    
    [[COAssetHelper sharedInstance] getPhotoListOfGroup:_assetsGroup result:^(NSArray *photos) {
        // ALAsset *alPhoto
        [_collectionView reloadData];
    }];
    
    [self buildToolbar];
}

//- (void)scrollToBottom
//{
//    CGFloat yOffset = 0;
//    if (_collectionView.contentSize.height > _collectionView.bounds.size.height) {
//        yOffset = _collectionView.contentSize.height - _collectionView.bounds.size.height;
//    }
//    [_collectionView setContentOffset:CGPointMake(0, yOffset) animated:YES];
//}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    [self scrollToBottom];
//}

- (void)buildToolbar
{
    UIToolbar* toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44)];
    toolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [toolBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]]
             forToolbarPosition:UIBarPositionBottom
                     barMetrics:UIBarMetricsDefault];
    
//    UIButton* previewButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 3, 40, 44 - 6)];
//    [previewButton setTitle:@"预览" forState:UIControlStateNormal];
//    [previewButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
//    [previewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [previewButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//    [previewButton addTarget:self action:@selector(onPreview) forControlEvents:UIControlEventTouchUpInside];
//
//    UIBarButtonItem* previewButtonItem = [[UIBarButtonItem alloc] initWithCustomView:previewButton];
    
    UIButton* completeButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 3, 52, 44 - 6)];
    [completeButton setTitle:@"完成" forState:UIControlStateNormal];
    [completeButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [completeButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];

    [completeButton addTarget:self action:@selector(onComplete) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* completeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:completeButton];
    
    UIBarButtonItem *btnPlace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray* items = @[btnPlace, completeButtonItem];
    
    [toolBar setItems:items];

    _toolbar = toolBar;
    [self.view addSubview:_toolbar];
}

- (void)onCancel
{
    [self.delegate cancelSelectAssets];
}

- (void)onPreview
{
    
}

- (void)onComplete
{
    NSMutableArray *selectArray = [[NSMutableArray alloc] init];
    for (NSIndexPath *indexPath in _selectedIndexsArray) {
        ALAsset *asset = [[COAssetHelper sharedInstance] getAssetAtIndex:indexPath.row];
        [selectArray addObject:asset];
    }
    [self.delegate completeSelectAssets:selectArray];
}

#pragma mark- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[COAssetHelper sharedInstance].assetPhotos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    COImageEnableSelectGridCell *gridCell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    ALAsset *asset = [[COAssetHelper sharedInstance] getAssetAtIndex:indexPath.row];
    [gridCell setImage:[[COAssetHelper sharedInstance] getImageFromAsset:asset type:kAssetPhotoSizeTypeThumbnail]];
    gridCell.selectIconButton.stateOn = [_selectedIndexsArray containsObject:indexPath];
    gridCell.delegate = self;
    return gridCell;
}

#pragma mark- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(77, 77);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 2, 44 + 2, 2);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    COFullScreenImageViewerController *fullScreenVC = [[COFullScreenImageViewerController alloc] initWithImageAtIndex:indexPath.row];
    fullScreenVC.selectedIndexArray = _selectedIndexsArray;
    fullScreenVC.delegate = self;
    [self.navigationController pushViewController:fullScreenVC animated:YES];
}

#pragma mark- COSelectFlagGridCellDelegate

- (void)selectFlagGridCell:(COSelectFlagGridCell*)selectFlagCell stateChanged:(BOOL)select
{
    NSIndexPath *indexPath = [_collectionView indexPathForCell:selectFlagCell];
    if (select) {
        [_selectedIndexsArray addObject:indexPath];
    } else {
        [_selectedIndexsArray removeObject:indexPath];
    }
}

#pragma mark- COFullScreenImageViewerControllerDelegate

- (void)selectOrUnselectItemWithIndex:(NSInteger)index isSelected:(BOOL)isSelected
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    if (isSelected) {
        [_selectedIndexsArray addObject:indexPath];
    } else {
        NSIndexPath *find = nil;
        for (NSIndexPath* item in _selectedIndexsArray) {
            if (item.section == indexPath.section && item.row == indexPath.row) {
                find = item;
                break;
            }
        }
        if (find) {
            [_selectedIndexsArray removeObject:find];
        }
    }
    [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

@end

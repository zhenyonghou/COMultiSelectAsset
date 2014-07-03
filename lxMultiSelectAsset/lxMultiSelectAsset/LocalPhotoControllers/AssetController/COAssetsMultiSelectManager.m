//
//  COAssetsMultiSelectManager.m
//  lxMultiSelectAsset
//
//  Created by houzhenyong on 14-7-3.
//  Copyright (c) 2014年 houzhenyong. All rights reserved.
//

#import "COAssetsMultiSelectManager.h"
#import "COAssetsGroupsViewController.h"
#import "COAssetsMultiSelectViewController.h"

@interface COAssetsMultiSelectManager()<COAssetsGroupsViewControllerDelegate, COAssetsMultiSelectViewControllerDelegate>
{
    COAssetsGroupsViewController * _assetsGroupsViewController;
    COAssetsMultiSelectViewController *_assetsMultiSelectViewController;
    
    UIViewController *_parentViewController;
}


@end

@implementation COAssetsMultiSelectManager

- (void)showInViewController:(UIViewController*)viewController
{
    _parentViewController = viewController;
    
    if (!_assetsGroupsViewController) {
        _assetsGroupsViewController = [[COAssetsGroupsViewController alloc] init];
        _assetsGroupsViewController.delegate = self;
    }
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:_assetsGroupsViewController];
    [_parentViewController presentViewController:navi animated:YES completion:nil];
}

- (void)dismiss
{
    [_assetsGroupsViewController dismissViewControllerAnimated:YES completion:^{
        _assetsGroupsViewController = nil;
        _assetsMultiSelectViewController = nil;
    }];
}

#pragma mark- COAssetsGroupsViewControllerDelegate

- (void)cancelSelectAssetsGroup
{
    [self dismiss];
}

- (void)didSelectAssetsGroup:(ALAssetsGroup*)group
{
    _assetsMultiSelectViewController = [[COAssetsMultiSelectViewController alloc] initWithAssetsGroup:group];
    _assetsMultiSelectViewController.delegate = self;
    [_assetsGroupsViewController.navigationController pushViewController:_assetsMultiSelectViewController animated:YES];
}

#pragma mark- COAssetsMultiSelectViewControllerDelegate

- (void)cancelSelectAssets
{
    [self dismiss];
    [self.delegate cancelSelectAssets];
}

- (void)completeSelectAssets:(NSArray*)assets
{
    [self dismiss];
    [self.delegate completeSelectAssets:assets];
}

@end

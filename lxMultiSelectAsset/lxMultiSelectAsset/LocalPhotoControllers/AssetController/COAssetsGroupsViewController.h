//
//  COPhotoGroupViewController.h
//  LxAsset
//
//  Created by houzhenyong on 14-6-15.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "COAssetHelper.h"

@protocol COAssetsGroupsViewControllerDelegate;

@interface COAssetsGroupsViewController : UIViewController

@property (nonatomic, weak) id<COAssetsGroupsViewControllerDelegate> delegate;

@end

@protocol COAssetsGroupsViewControllerDelegate <NSObject>

- (void)cancelSelectAssetsGroup;

- (void)didSelectAssetsGroup:(ALAssetsGroup*)group;

@end

//
//  COPhotoCollectionViewController.h
//  LxAsset
//
//  Created by houzhenyong on 14-6-16.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "COAssetHelper.h"

@protocol COAssetsMultiSelectViewControllerDelegate;

@interface COAssetsMultiSelectViewController : UIViewController

@property (nonatomic, weak) id<COAssetsMultiSelectViewControllerDelegate> delegate;

- (id)initWithAssetsGroup:(ALAssetsGroup*)group;

@end

@protocol COAssetsMultiSelectViewControllerDelegate <NSObject>

- (void)cancelSelectAssets;

- (void)completeSelectAssets:(NSArray*)assets;

@end

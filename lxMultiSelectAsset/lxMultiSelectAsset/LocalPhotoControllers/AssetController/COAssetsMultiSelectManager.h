//
//  COAssetsMultiSelectManager.h
//  lxMultiSelectAsset
//
//  Created by houzhenyong on 14-7-3.
//  Copyright (c) 2014年 houzhenyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol COAssetsMultiSelectManagerDelegate;

@interface COAssetsMultiSelectManager : NSObject

@property (nonatomic, weak) id<COAssetsMultiSelectManagerDelegate> delegate;

- (void)showInViewController:(UIViewController*)viewController;

- (void)dismiss;

@end

@protocol COAssetsMultiSelectManagerDelegate <NSObject>

- (void)cancelSelectAssets;

- (void)completeSelectAssets:(NSArray*)assets;

@end

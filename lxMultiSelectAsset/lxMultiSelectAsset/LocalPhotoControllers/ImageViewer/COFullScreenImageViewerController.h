//
//  COLargePhotoViewController.h
//  LxAsset
//
//  Created by houzhenyong on 14-6-16.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol COFullScreenImageViewerControllerDelegate;

@interface COFullScreenImageViewerController : UIViewController

@property (nonatomic, strong)NSMutableArray *selectedIndexArray;

@property (nonatomic, weak)id<COFullScreenImageViewerControllerDelegate> delegate;

- (id)initWithImageAtIndex:(NSUInteger)imageIndex;

- (NSInteger)currentImageIndex;

- (void)moveToImageAtIndex:(NSInteger)index animated:(BOOL)animated;

@end

@protocol COFullScreenImageViewerControllerDelegate <NSObject>

- (void)selectOrUnselectItemWithIndex:(NSInteger)index isSelected:(BOOL)isSelected;

@end

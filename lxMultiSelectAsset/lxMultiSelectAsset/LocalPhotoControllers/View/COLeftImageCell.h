//
//  COLeftImageCell.h
//  LxAsset
//
//  Created by houzhenyong on 14-6-15.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface COLeftImageCell : UITableViewCell {
}

@property (nonatomic, assign)CGSize imageSize;
@property (nonatomic, assign)CGFloat imageLeftMargin;
@property (nonatomic, assign)CGFloat imageRightMargin;

@property (nonatomic, strong, readonly) UIImageView *leftImageView;

- (void)setLeftImage:(UIImage*)image text:(NSString*)text;

@end

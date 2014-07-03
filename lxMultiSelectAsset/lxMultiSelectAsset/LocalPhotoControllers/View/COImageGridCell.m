//
//  COImageGridCell.m
//  LxAsset
//
//  Created by houzhenyong on 14-6-26.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "COImageGridCell.h"

@implementation COImageGridCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_imageView];
    }
    return self;
}

- (void)setImage:(UIImage*)image
{
    _imageView.image = image;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _imageView.frame = self.bounds;
}

@end

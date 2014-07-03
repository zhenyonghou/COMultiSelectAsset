//
//  COLeftImageCell.m
//  LxAsset
//
//  Created by houzhenyong on 14-6-15.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "COLeftImageCell.h"

@implementation COLeftImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _leftImageView = [[UIImageView alloc] init];
        [self addSubview:_leftImageView];
    }
    return self;
}

- (void)setLeftImage:(UIImage*)image text:(NSString*)text
{
    self.leftImageView.image = image;
    self.textLabel.text = text;
}

- (void)layoutSubviews
{
    if (CGSizeEqualToSize(self.imageSize, CGSizeZero)) {
        self.imageSize = CGSizeMake(self.bounds.size.height, self.bounds.size.height);
    }
    
    self.leftImageView.frame = CGRectMake(self.imageLeftMargin, (self.bounds.size.height - self.imageSize.height)/2, self.imageSize.width, self.imageSize.height);
    
    CGSize labelSize = [self.textLabel sizeThatFits:CGSizeZero];
    
    if (self.imageRightMargin == 0.f) {
        self.imageRightMargin = 5.f;
    }
    
    self.textLabel.frame = CGRectMake(self.imageLeftMargin + self.imageSize.width + self.imageRightMargin,
                                      (self.bounds.size.height - labelSize.height)/2, labelSize.width, labelSize.height);
}

@end

//
//  COAssetGroupCell.m
//  LxAsset
//
//  Created by houzhenyong on 14-6-15.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "COAssetGroupCell.h"

@implementation COAssetGroupCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageRightMargin = 6;
    }
    return self;
}

- (void)setLeftImage:(UIImage*)image groupName:(NSString*)name count:(NSUInteger)count
{
    NSString *text = [NSString stringWithFormat:@"%@   (%d)", name, count];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributeString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:NSMakeRange(0, [text length])];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [name length])];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange([name length], [text length] - [name length])];
    self.textLabel.attributedText = attributeString;
    
    self.leftImageView.image = image;
}

@end

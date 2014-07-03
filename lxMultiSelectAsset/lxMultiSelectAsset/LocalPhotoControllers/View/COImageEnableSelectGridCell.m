//
//  COImageEnableSelectGridCell.m
//  LxAsset
//
//  Created by houzhenyong on 14-6-19.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "COImageEnableSelectGridCell.h"

@implementation COImageEnableSelectGridCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *unselectedIcon = [UIImage imageNamed:@"FriendsSendsPicturesSelectIcon_ios7"];
        UIImage *selectedIcon = [UIImage imageNamed:@"FriendsSendsPicturesSelectYIcon_ios7"];
        [self setUnselectedIcon:unselectedIcon selectedIcon:selectedIcon];
    }
    return self;
}

@end

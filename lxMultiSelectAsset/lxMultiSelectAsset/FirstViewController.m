//
//  FirstViewController.m
//  LxAsset
//
//  Created by houzhenyong on 14-6-15.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "FirstViewController.h"
#import "COAssetsMultiSelectManager.h"

@interface FirstViewController () <COAssetsMultiSelectManagerDelegate>
@property (nonatomic, strong) COAssetsMultiSelectManager *multiSelectManager;
@end

@implementation FirstViewController

- (id)init{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [button setTitle:@"ShowAsset" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onShowAsset) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)onShowAsset
{
    self.multiSelectManager = [[COAssetsMultiSelectManager alloc] init];
    self.multiSelectManager.delegate = self;
    [self.multiSelectManager showInViewController:self];
}

#pragma mark- COAssetsMultiSelectManagerDelegate

- (void)cancelSelectAssets
{
    NSLog(@"cancelSelectAssets");
}

- (void)completeSelectAssets:(NSArray*)assets
{
    NSLog(@"completeSelectAssets count=%d", [assets count]);
}

@end

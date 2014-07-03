//
//  COFullScreenImageViewerController.m
//  LxAsset
//
//  Created by houzhenyong on 14-6-16.
//  Copyright (c) 2014年 hou zhenyong. All rights reserved.
//

#import "COFullScreenImageViewerController.h"
#import "COAssetHelper.h"
#import "COImagePageView.h"
#import "COImageViewer.h"
#import "COFakeNavigationBar.h"
#import "BASwitchButton.h"

typedef enum COScrollDirection {
    kScrollDirectionNone = 0,
    kScrollDirectionRight,
    kScrollDirectionLeft,
    kScrollDirectionUp,
    kScrollDirectionDown,
} COScrollDirection;

@interface COFullScreenImageViewerController () <UIScrollViewDelegate> {
    NSInteger _currentIndex;
    BOOL _barsHidden;
}
@property (nonatomic, strong) BASwitchButton *selectedButton;

@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic, assign) COScrollDirection scrollDirection;

@property (nonatomic, strong) COFakeNavigationBar *fakeNavigationBar;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *imageViews;

@end

@implementation COFullScreenImageViewerController

- (id)initWithImageAtIndex:(NSUInteger)imageIndex
{
    self = [super init];
    if (self) {
        _currentIndex = imageIndex;
        _scrollDirection = kScrollDirectionNone;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    if (!_scrollView) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        _scrollView.delegate = self;
        _scrollView.scrollEnabled = YES;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.directionalLockEnabled = YES;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.delaysContentTouches = YES;
        _scrollView.clipsToBounds = YES;
        _scrollView.bounces = YES;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_scrollView];
        
        [self setupFakeNavigationBar];
    }

    NSMutableArray *views = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < [[COAssetHelper sharedInstance] getPhotoCountOfCurrentGroup]; i++) {
        [views addObject:[NSNull null]];
    }
    self.imageViews = views;
}

- (void)setupFakeNavigationBar
{
    self.fakeNavigationBar = [[COFakeNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    self.fakeNavigationBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [self.view addSubview:self.fakeNavigationBar];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self action:@selector(onBackButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"barbuttonicon_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"barbuttonicon_back"] forState:UIControlStateNormal];
    self.fakeNavigationBar.backButton = backButton;
    
    CGRect selectedButtonRect = CGRectMake(0, 0, 60, 64);
    UIImage *unselectedIcon = [UIImage imageNamed:@"FriendsSendsPicturesSelectBigNIcon_ios7"];
    UIImage *selectedIcon = [UIImage imageNamed:@"FriendsSendsPicturesSelectBigYIcon_ios7"];
    BASwitchButton *selectedButton = [[BASwitchButton alloc] initWithFrame:selectedButtonRect
                                                                  offImage:unselectedIcon
                                                                   onImage:selectedIcon
                                                                    target:self
                                                                  selector:@selector(onSelectOrUnselectCurrentImage:)];
    selectedButton.bounceAnimate = YES;
    self.fakeNavigationBar.rightButton = selectedButton;
    self.selectedButton = selectedButton;
}

- (void)setTopBarsHidden:(BOOL)hidden
{
    [self.navigationController setNavigationBarHidden:hidden animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:hidden withAnimation:UIStatusBarAnimationNone];
}

- (void)onBackButtonTouched
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onSelectOrUnselectCurrentImage:(NSNumber*)selectState
{
    [self.delegate selectOrUnselectItemWithIndex:_currentIndex isSelected:[selectState boolValue]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setTopBarsHidden:YES];

    [self setupScrollViewContentSize];
    [self moveToImageAtIndex:_currentIndex animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self setTopBarsHidden:NO];
}

- (void)loadScrollViewWithPage:(NSInteger)page {
    if (page < 0) {
        return;
    }

    if (page >= [[COAssetHelper sharedInstance] getPhotoCountOfCurrentGroup]) {
        return;
    }

    // 可复用, 只创造有限几个COImagePageView
    COImagePageView *imageView = [_imageViews objectAtIndex:(NSUInteger) page];
    if ((NSNull *) imageView == [NSNull null]) {
        imageView = [self dequeueImageView];
        if (imageView != nil) {
            [_imageViews exchangeObjectAtIndex:(NSUInteger) imageView.tag withObjectAtIndex:(NSUInteger) page];
            imageView = [_imageViews objectAtIndex:(NSUInteger) page];
        }
    }

    if (imageView == nil || (NSNull *) imageView == [NSNull null]) {
        imageView = [[COImagePageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _scrollView.bounds.size.width, _scrollView.bounds.size.height)];
        [_imageViews replaceObjectAtIndex:(NSUInteger) page withObject:imageView];
    }
    
//    NSLog(@"load page: %d", page);
    
    [imageView setDisplayImage:[[COAssetHelper sharedInstance] getImageAtIndex:page type:kAssetPhotoSizeTypeScreen]];

    if (imageView.superview == nil) {
        [_scrollView addSubview:imageView];
    }

    // 当前照片左边和右边留出间隔
    CGRect frame = _scrollView.frame;
    CGFloat xOrigin = (frame.size.width * page);
    if (page > _currentIndex) {
        xOrigin = (frame.size.width * page) + kSFImageViewerImageGap;
    } else if (page < _currentIndex) {
        xOrigin = (frame.size.width * page) - kSFImageViewerImageGap;
    }

    frame.origin.x = xOrigin;
    frame.origin.y = 0;
    imageView.frame = frame;
}

- (BOOL)isSelectItemWithIndex:(NSInteger)index
{
    BOOL find = NO;
    for (NSIndexPath* item in self.selectedIndexArray) {
        if (item.row == index) {
            find = YES;
            break;
        }
    }
    return find;
}

- (void)moveToImageAtIndex:(NSInteger)index animated:(BOOL)animated {
    if (index < [[COAssetHelper sharedInstance] getPhotoCountOfCurrentGroup] && index >= 0) {
        _currentIndex = index;
        
        BOOL isSelectCurrentItem = [self isSelectItemWithIndex:_currentIndex];
        self.selectedButton.stateOn = isSelectCurrentItem;
        
        [self enqueueImageViewAtIndex:index];
        
        [self loadScrollViewWithPage:index - 1];
        [self loadScrollViewWithPage:index];
        [self loadScrollViewWithPage:index + 1];
        
        CGRect visibleFrame = ((COImagePageView *)_imageViews[index]).frame;
        [self.scrollView setContentOffset:visibleFrame.origin animated:animated];
       
        if (index + 1 < [[COAssetHelper sharedInstance] getPhotoCountOfCurrentGroup] && (NSNull *) _imageViews[index + 1] != [NSNull null]) {
            [((COImagePageView *) self.imageViews[index + 1]) killScrollViewZoom];
        }
        if (index - 1 >= 0 && (NSNull *)self.imageViews[index - 1] != [NSNull null]) {
            [((COImagePageView *) self.imageViews[index - 1]) killScrollViewZoom];
        }
    }
}

- (void)setupScrollViewContentSize {
    CGFloat width = self.scrollView.bounds.size.width * [[COAssetHelper sharedInstance] getPhotoCountOfCurrentGroup];
    CGSize contentSize = CGSizeMake(width, 0);      // 锁定上下移动
    if (!CGSizeEqualToSize(contentSize, self.scrollView.contentSize)) {
        self.scrollView.contentSize = contentSize;
    }
}

- (void)enqueueImageViewAtIndex:(NSInteger)theIndex {
    NSInteger count = 0;
    for (COImagePageView *view in _imageViews) {
        if ([view isKindOfClass:[COImagePageView class]]) {
            if (count > theIndex + 1 || count < theIndex - 1) {
                [view prepareForReuse];
                [view removeFromSuperview];
            } else {
                view.tag = 0;
            }
        }
        count++;
    }
}

- (COImagePageView *)dequeueImageView {
    NSInteger count = 0;
    for (COImagePageView *view in self.imageViews) {
        if ([view isKindOfClass:[COImagePageView class]]) {
            if (view.superview == nil) {
                view.tag = count;
                return view;
            }
        }
        count++;
    }
    return nil;
}

- (NSInteger)centerImageIndex {
    if (self.scrollView) {
        CGFloat pageWidth = self.scrollView.frame.size.width;
        NSInteger centerImageIndex = (NSInteger)(floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1);
        if (centerImageIndex >= 0) {
            return centerImageIndex;
        }
    }
    return 0;
}

- (NSInteger)currentImageIndex
{
    return _currentIndex;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = [self centerImageIndex];
    
    if (index >= [[COAssetHelper sharedInstance] getPhotoCountOfCurrentGroup] || index < 0) {
        return;
    }

    if (self.lastContentOffset > scrollView.contentOffset.x) {
        self.scrollDirection = kScrollDirectionRight;
    }
    else if (self.lastContentOffset < scrollView.contentOffset.x) {
        self.scrollDirection = kScrollDirectionLeft;
    } else {
        self.scrollDirection = kScrollDirectionNone;
    }
    
//    NSLog(@"direction = %d [%f, %f]", self.scrollDirection, scrollView.contentOffset.x, scrollView.contentOffset.y);
    
    self.lastContentOffset = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _currentIndex = [self centerImageIndex];
    if (_currentIndex >= [[COAssetHelper sharedInstance] getPhotoCountOfCurrentGroup] || _currentIndex < 0) {
        return;
    }
    
    [self loadScrollViewWithPage:_currentIndex - 1];
    [self loadScrollViewWithPage:_currentIndex + 1];

    if (_currentIndex + 1 < [[COAssetHelper sharedInstance] getPhotoCountOfCurrentGroup]
        && (NSNull *)self.imageViews[_currentIndex + 1] != [NSNull null]) {
        [((COImagePageView *)self.imageViews[_currentIndex + 1]) killScrollViewZoom];
    }
    if (_currentIndex >= 1
        && (NSNull *)self.imageViews[_currentIndex - 1] != [NSNull null]) {
        [((COImagePageView *)self.imageViews[_currentIndex - 1]) killScrollViewZoom];
    }

    BOOL isSelectCurrentItem = [self isSelectItemWithIndex:_currentIndex];
    self.selectedButton.stateOn = isSelectCurrentItem;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    // centerImageIndex计算下一个index不靠谱，用最近的移动方向预测下一个index比较靠谱
    NSInteger nextIndex = _currentIndex;
    if (self.scrollDirection == kScrollDirectionLeft) {
        nextIndex = _currentIndex + 1;
    } else if (self.scrollDirection == kScrollDirectionRight) {
        nextIndex = _currentIndex - 1;
    }
    
    if (nextIndex != _currentIndex && nextIndex >= 0 && nextIndex < [[COAssetHelper sharedInstance] getPhotoCountOfCurrentGroup]) {
        CGRect newFrame = CGRectMake(_scrollView.bounds.size.width * nextIndex, 0.0f, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
        COImagePageView *imageView = _imageViews[nextIndex];
        [UIView animateWithDuration:0.48 animations:^{
            imageView.frame = newFrame;
        }];
    }
}

@end

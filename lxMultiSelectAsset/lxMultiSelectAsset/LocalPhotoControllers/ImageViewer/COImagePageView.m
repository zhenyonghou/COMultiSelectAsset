
#import "COImagePageView.h"
#import "COImageScrollView.h"

@interface COImagePageView()

@property(strong, nonatomic, readonly) COImageScrollView *scrollView;

@end

@implementation COImagePageView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;

        COImageScrollView *scrollView = [[COImageScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:scrollView];
        _scrollView = scrollView;
    }
    return self;
}

- (void)setDisplayImage:(UIImage*)aImage {
    [_scrollView setDisplayImage:aImage];
    self.userInteractionEnabled = YES;
}

- (void)killScrollViewZoom
{
    [_scrollView killScrollViewZoom];
}

- (void)prepareForReuse {
    self.tag = -1;
    [_scrollView removeImage];
}

#pragma mark - Animation

//- (CABasicAnimation *)fadeAnimation {
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    animation.fromValue = [NSNumber numberWithFloat:0.0f];
//    animation.toValue = [NSNumber numberWithFloat:1.0f];
//    animation.duration = .3f;
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//
//    return animation;
//}

#pragma mark - Bars

- (void)toggleBars {
//    [[NSNotificationCenter defaultCenter] postNotificationName:kSFImageViewerToogleBarsNotificationKey object:nil];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    UITouch *touch = [touches anyObject];

    if (touch.tapCount == 1) {
        [self performSelector:@selector(toggleBars) withObject:nil afterDelay:.2];
    }
}


@end

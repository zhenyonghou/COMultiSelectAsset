
#import "COImageScrollView.h"
#import "COImagePageView.h"
#import "COImageViewer.h"
#import "COViewUtlity.h"

@interface COImageScrollView() <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *displayImageView;

@end

@implementation COImageScrollView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollEnabled = NO;
		self.clipsToBounds = NO;
		self.maximumZoomScale = 3.0f;
		self.minimumZoomScale = 1.0f;
		self.showsVerticalScrollIndicator = NO;
		self.showsHorizontalScrollIndicator = NO;
        self.bounces = YES;
        self.bouncesZoom = YES;
		self.scrollsToTop = NO;
		self.backgroundColor = [UIColor clearColor];
		self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.clipsToBounds = YES;
        self.delegate = self;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.displayImageView = imageView;
        [self addSubview:self.displayImageView];
    }
    return self;
}

- (void)setDisplayImage:(UIImage*)image
{
    self.displayImageView.image = image;
    [self layoutScrollViewAnimated:NO];
}

- (void)removeImage
{
    self.displayImageView.image = nil;
}

// 恢复到铺满view大小
- (void)layoutScrollViewAnimated:(BOOL)animated {
    if (!self.displayImageView.image) {
        return;
    }
    
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.1];
    }
    
    CGSize newImageSize = [COViewUtlity sizeScaledWithRawSize:self.displayImageView.image.size constrainedSize:self.bounds.size];
    
    self.displayImageView.frame = CGRectMake((self.bounds.size.width - newImageSize.width)/2,
                                             (self.bounds.size.height - newImageSize.height)/2,
                                             newImageSize.width,
                                             newImageSize.height);
    
    self.contentSize = CGSizeMake(newImageSize.width, newImageSize.height);
    [self resetContentSize];
    
    if (animated) {
        [UIView commitAnimations];
    }
}

- (void)resetContentSize
{
    CGFloat offsetX = (self.bounds.size.width > self.contentSize.width) ? (self.bounds.size.width - self.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (self.bounds.size.height > self.contentSize.height) ? (self.bounds.size.height - self.contentSize.height) * 0.5 : 0.0;
    
    self.displayImageView.center = CGPointMake(self.contentSize.width * 0.5 + offsetX, self.contentSize.height * 0.5 + offsetY);
}

- (void)zoomRectWithCenter:(CGPoint)center{
    if (self.zoomScale > 1.0f) {
        self.scrollEnabled = NO;
        [((COImagePageView *)self.superview) killScrollViewZoom];
        return;
    }
    self.scrollEnabled = YES;
	CGRect rect;
	rect.size = CGSizeMake(self.frame.size.width / kSFImageViewerZoomScale, self.frame.size.height / kSFImageViewerZoomScale);
	rect.origin.x = MAX((center.x - (rect.size.width / 2.0f)), 0.0f);		
	rect.origin.y = MAX((center.y - (rect.size.height / 2.0f)), 0.0f);
	
	CGRect frame = [self.superview convertRect:self.frame toView:self.superview];
	CGFloat borderX = frame.origin.x;
	CGFloat borderY = frame.origin.y;
	
	if (borderX > 0.0f && (center.x < borderX || center.x > self.frame.size.width - borderX)) {
				
		if (center.x < (self.frame.size.width / 2.0f)) {
			rect.origin.x += (borderX/kSFImageViewerZoomScale);
		} else {
			rect.origin.x -= ((borderX/kSFImageViewerZoomScale) + rect.size.width);
		}
	}
	
	if (borderY > 0.0f && (center.y < borderY || center.y > self.frame.size.height - borderY)) {
		if (center.y < (self.frame.size.height / 2.0f)) {
			rect.origin.y += (borderY/kSFImageViewerZoomScale);
		} else {
			rect.origin.y -= ((borderY/kSFImageViewerZoomScale) + rect.size.height);
		}
	}

	[self zoomToRect:rect animated:YES];
}

- (void)killScrollViewZoom {
//    if (self.zoomScale <= 1.0f) return;
    if (!self.displayImageView.image) {
        return;
    }
    
    [self layoutScrollViewAnimated:NO];
//    [self setZoomScale:YES animated:YES];
}

- (void)toggleBars{
//	[[NSNotificationCenter defaultCenter] postNotificationName:kSFImageViewerToogleBarsNotificationKey object:nil];
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesEnded:touches withEvent:event];
	UITouch *touch = [touches anyObject];
	
	if (touch.tapCount == 1) {
		[self performSelector:@selector(toggleBars) withObject:nil afterDelay:.2];
	} else if (touch.tapCount == 2) {
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(toggleBars) object:nil];
		[self zoomRectWithCenter:[[touches anyObject] locationInView:self]];
	}
}

#pragma mark- UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.displayImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self resetContentSize];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    
}

@end

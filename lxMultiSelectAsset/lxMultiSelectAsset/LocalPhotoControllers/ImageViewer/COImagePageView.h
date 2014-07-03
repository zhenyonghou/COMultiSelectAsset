
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface COImagePageView : UIView

- (void)setDisplayImage:(UIImage*)aImage;

- (void)killScrollViewZoom;

- (void)prepareForReuse;

@end

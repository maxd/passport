#import "UIButton+Gradient.h"

@implementation UIButton (Gradient)

- (void)greenGradient {
    UIImage *button = [UIImage imageNamed:@"button_green"];
    UIImage *newImage = [button resizableImageWithCapInsets:UIEdgeInsetsMake(0, 21, 0, 21)];
    
    [self setBackgroundImage:newImage forState:UIControlStateNormal];
}

@end

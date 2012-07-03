#import "UIButton+Gradient.h"

@implementation UIButton (Gradient)

- (void)greenGradient {
    [self buttonColor:@"button_green"];
}

- (void)redGradient {
    [self buttonColor:@"button_red"];
}

- (void)grayGradient {
    [self buttonColor:@"button_gray"];
}

- (void)buttonColor:(NSString *)imageName {
    UIImage *button = [UIImage imageNamed:imageName];
    UIImage *newImage = [button resizableImageWithCapInsets:UIEdgeInsetsMake(0, 21, 0, 21)];

    [self setBackgroundImage:newImage forState:UIControlStateNormal];
}

@end

#import "CustomCityViewController.h"
#import "UIButton+Gradient.h"

@interface CustomCityViewController () <UITextFieldDelegate> {
    IBOutlet UITextField *txtCustomCity;
    IBOutlet UIButton *btConfirm;
}

@end

@implementation CustomCityViewController

@synthesize delegate = _delegate;
@synthesize city = _city;


- (void)viewDidLoad {
    [btConfirm greenGradient];

    [txtCustomCity becomeFirstResponder];

    txtCustomCity.text = self.city;
}

#pragma mark TextField handlers

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];

    [self.delegate didSelectCustomCity:txtCustomCity.text];

    return NO;
}

#pragma mark Confirm Button Handler

- (IBAction)confirmButtonHandler:(id)sender {
    [self.delegate didSelectCustomCity:txtCustomCity.text];
}

@end

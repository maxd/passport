#import "LoginViewController.h"
#import "SettingsRepository.h"
#import "UIButton+Gradient.h"

@interface LoginViewController () {
    IBOutlet UITextField *txtPassword;
    IBOutlet UIButton *btLogin;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [txtPassword becomeFirstResponder];
    [btLogin greenGradient];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

#pragma mark Handlers

- (IBAction)login:(id)sender {
    if ([SettingsRepository isValidPassword:txtPassword.text]) {
        [self dismissModalViewControllerAnimated:YES];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] 
                                  initWithTitle:@"Предупреждение" 
                                  message:@"Введен неверный пароль." 
                                  delegate:self 
                                  cancelButtonTitle:@"OK" 
                                  otherButtonTitles:nil];
        
        [alertView show];
    }
}

- (void)viewDidUnload {
    btLogin = nil;
    [super viewDidUnload];
}
@end

#import "PasswordViewController.h"
#import "SettingsRepository.h"
#import "UIButton+Gradient.h"

#define EMPTY_PASSWORD_TAG 1

@interface PasswordViewController () <UIAlertViewDelegate, UITextFieldDelegate> {
    IBOutlet UITextField *txtPassword;
    IBOutlet UITextField *txtConfirmPassword;
    IBOutlet UIButton *btConfirmPassword;
}

@end

@implementation PasswordViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [btConfirmPassword greenGradient];
}

#pragma mark Handlers

- (IBAction)confirmPassword:(id)sender {
    if (![txtPassword.text isEqualToString:txtConfirmPassword.text]) {
        [self showDifferentPasswordsAlertView];
        return;
    }

    if ([txtPassword.text length] == 0) {
        [self showEmptyPasswordAlertView];
        return;
    }

    [SettingsRepository setPassword:txtPassword.text];
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark Alert Views

- (void)showDifferentPasswordsAlertView {
    UIAlertView *alertView = [[UIAlertView alloc]
            initWithTitle:@"Предупреждение"
                  message:@"Введенные пароли различаются. Попробуйте ввести их еще раз."
                 delegate:self
        cancelButtonTitle:@"OK"
        otherButtonTitles:nil];

    [alertView show];
}

- (void)showEmptyPasswordAlertView {
    UIAlertView *alertView = [[UIAlertView alloc]
            initWithTitle:@"Предупреждение"
                  message:@"Вы ввели пустой пароль. Вы уверены что не хотите защитить паспортные данные?"
                 delegate:self
        cancelButtonTitle:@"Нет"
        otherButtonTitles:@"Да", nil];
    [alertView setTag:EMPTY_PASSWORD_TAG];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == EMPTY_PASSWORD_TAG && buttonIndex == 1) {
        [SettingsRepository setPassword:nil];

        [self dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark Text Field Handlers

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)viewDidUnload {
    btConfirmPassword = nil;
    [super viewDidUnload];
}

@end

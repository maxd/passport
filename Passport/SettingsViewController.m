#import "SettingsViewController.h"
#import "SettingsRepository.h"
#import "UIButton+Gradient.h"

#define EMPTY_PASSWORD_TAG 1

@interface SettingsViewController () <UIAlertViewDelegate, UITextFieldDelegate> {
    IBOutlet UITextField *txtPassword;
    IBOutlet UITextField *txtConfirmPassword;
    IBOutlet UIButton *btChangePassword;
}

@end

@implementation SettingsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [btChangePassword greenGradient];
}

#pragma mark Handlers

- (IBAction)changePassword:(id)sender {
    if (![txtPassword.text isEqualToString:txtConfirmPassword.text]) {
        [self showDifferentPasswordsAlertView];
        return;
    }
    
    if ([txtPassword.text length] == 0) {
        [self showEmptyPasswordAlertView];
        return;
    }
    
    [SettingsRepository setPassword:txtPassword.text];

    [self showPasswordChangedAlertView];
}

#pragma mark Alert Views

- (void)showDifferentPasswordsAlertView {
    UIAlertView *alertView = [[UIAlertView alloc]
            initWithTitle:@"Предупреждение"
                  message:@"Введенные пароли различаются. Попробуйте ввести их еще раз."
                 delegate:nil
        cancelButtonTitle:@"OK"
        otherButtonTitles:nil];

    [alertView show];
}

- (void)showEmptyPasswordAlertView {
    UIAlertView *alertView = [[UIAlertView alloc]
            initWithTitle:@"Предупреждение"
                  message:@"Вы ввели пустой пароль. Вы уверены что хотите снять защиту с паспортных данных?"
                 delegate:self
        cancelButtonTitle:@"Нет"
        otherButtonTitles:@"Да", nil];
    [alertView setTag:EMPTY_PASSWORD_TAG];
    [alertView show];
}

- (void)showPasswordChangedAlertView {
    UIAlertView *alertView = [[UIAlertView alloc]
            initWithTitle:@"Предупреждение"
                  message:@"Пароль изменен."
                 delegate:nil
        cancelButtonTitle:@"OK"
        otherButtonTitles:nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == EMPTY_PASSWORD_TAG && buttonIndex == 1) {
        [SettingsRepository setPassword:nil];
    }
}

#pragma mark Text Field Handlers

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)viewDidUnload {
    btChangePassword = nil;
    [super viewDidUnload];
}
@end

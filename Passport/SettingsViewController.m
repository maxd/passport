#import "SettingsViewController.h"
#import "SettingsRepository.h"
#import "UIButton+Gradient.h"
#import <InAppPurchase/InAppPurchase.h>
#import "MainViewController.h"
#import "ProductIdentifiers.h"
#import "DisableAdProductActivator.h"

#define EMPTY_PASSWORD_TAG 1

@interface SettingsViewController () <UIAlertViewDelegate, UITextFieldDelegate> {
    IBOutlet UITextField *txtPassword;
    IBOutlet UITextField *txtConfirmPassword;
    IBOutlet UIButton *btChangePassword;
    IBOutlet UIButton *btDisableAd;

    InAppPurchaseManager *inAppPurchaseManager;
}

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(inAppPurchaseStartedHandler:)
                   name:IN_APP_PURCHASE_STARTED_NOTIFICATION
                 object:nil];

    [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(inAppPurchaseFinishedHandler:)
                   name:IN_APP_PURCHASE_FINISHED_NOTIFICATION
                 object:nil];

    [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(productsUpdateSuccessHandler:)
                   name:IN_APP_PURCHASE_PRODUCTS_UPDATE_SUCCESS_NOTIFICATION
                 object:nil];

    [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(changeAdBanner:)
                   name:CHANGE_AD_BANNER_NOTIFICATION
                 object:nil];

    [btChangePassword greenGradient];
    [btDisableAd redGradient];

    BOOL isAdDisabled = [[[NSUserDefaults standardUserDefaults] objectForKey:DISABLE_AD_PRODUCT_IDENTIFIER] boolValue];
    btDisableAd.enabled = NO;
    btDisableAd.hidden = isAdDisabled;

    if (!isAdDisabled) {
        inAppPurchaseManager = [InAppPurchaseManager new];
        [inAppPurchaseManager addProductActivator:[DisableAdProductActivator new]];
        [inAppPurchaseManager updateProducts];
    }
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [super viewDidUnload];
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

#pragma mark Disable Ad

- (IBAction)disableAdHandler:(id)sender {
    if (inAppPurchaseManager.canMakePurchases) {
        [inAppPurchaseManager purchaseProduct:DISABLE_AD_PRODUCT_IDENTIFIER];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]
                initWithTitle:@"Предупреждение"
                      message:@"Возможность совершения покупок запрещена на этом устройстве."
                     delegate:nil
            cancelButtonTitle:@"Закрыть"
            otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)inAppPurchaseStartedHandler:(NSNotification *)notification {
    btDisableAd.enabled = NO;
}

- (void)inAppPurchaseFinishedHandler:(NSNotification *)notification {
    btDisableAd.enabled = YES;
}

- (void)productsUpdateSuccessHandler:(id)sender {
    SKProduct *product = [inAppPurchaseManager productByIdentifier:DISABLE_AD_PRODUCT_IDENTIFIER];

    if (product) {
        btDisableAd.enabled = YES;
        btDisableAd.titleLabel.adjustsFontSizeToFitWidth = YES;
        [btDisableAd setTitle:[NSString stringWithFormat:@"%@ %@", product.localizedTitle, product.localizedPrice] forState:UIControlStateNormal];
    }
}

- (void)changeAdBanner:(NSNotification *)notification {
    btDisableAd.hidden = ![[notification.userInfo objectForKey:@"visible"] boolValue];
}

@end

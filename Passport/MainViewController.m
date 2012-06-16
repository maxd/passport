#import "MainViewController.h"
#import "SettingsRepository.h"
#import "LoginViewController.h"

@interface MainViewController () {
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification 
                                               object:nil];
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

#pragma mark Handlers

- (void)applicationDidBecomeActive:(id)sender {
    if (![SettingsRepository isValidPassword:nil]) {
        LoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
        [self presentModalViewController:loginViewController animated:NO];
    }
}

@end

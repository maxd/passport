#import "MainViewController.h"
#import "SettingsRepository.h"
#import "LoginViewController.h"
#import "GADBannerView.h"
#import "PassportRepository.h"
#import "Passport.h"
#import "ProductIdentifiers.h"
#import "InAppPurchaseManager.h"

#define ADMOB_TOKEN @"a14fede9eb5ac32"

@interface MainViewController () {
    UIView *container;
    CGRect defaultContainerFrame;

    GADBannerView *ctlBanner;

    BOOL isInPurchase;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(applicationWillResignActive:)
                   name:UIApplicationWillResignActiveNotification
                 object:nil];

    [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(changeAdBanner:)
                   name:CHANGE_AD_BANNER_NOTIFICATION object:nil];

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

    container = [self findContainerView];
    defaultContainerFrame = container.frame;

    PassportRepository *passportRepository = [PassportRepository new];
    Passport *passport = [passportRepository get];

    if (![[[NSUserDefaults standardUserDefaults] objectForKey:DISABLE_AD_PRODUCT_IDENTIFIER] boolValue]) {
        if (passport.passportSeries.length != 0 && passport.passportNumber.length != 0) {
            [self showBanner];
        }
    }
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

#pragma mark Handlers

- (void)applicationWillResignActive:(id)sender {
    if (![SettingsRepository isValidPassword:nil] && !isInPurchase) {
        LoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
        [self presentModalViewController:loginViewController animated:NO];
    }
}

- (void)inAppPurchaseStartedHandler:(NSNotification *)notification {
    isInPurchase = YES;
}

- (void)inAppPurchaseFinishedHandler:(NSNotification *)notification {
    // This hack don't show login window after complete or cancel purchase
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        isInPurchase = NO;
    });
}

#pragma mark Show Banner

// See http://www.hindsightlabs.com/blog/2010/02/08/adding-a-persistent-ad-banner-to-a-uitabbar/

- (void)initializeBanner {
    ctlBanner = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    ctlBanner.adUnitID = ADMOB_TOKEN;
    ctlBanner.rootViewController = self;
    ctlBanner.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    GADRequest *request = [GADRequest new];
#ifdef DEBUG
    request.testing = YES;
#endif

    [ctlBanner loadRequest:request];
}

- (UIView *)findContainerView {
    // A UITabBarController's view has two subviews: the UITabBar and a container UITransitionView that is
    // used to hold the child views. Save a reference to the container.
    for (UIView *view in self.view.subviews) {
        if (![view isKindOfClass:[UITabBar class]]) {
            return view;
        }
    }
    return nil;
}

- (void)showBanner {
    if (!ctlBanner) {
        [self initializeBanner];

        CGFloat containerHeight = defaultContainerFrame.size.height;
        CGFloat containerWidth = defaultContainerFrame.size.width;

        CGFloat adBannerHeight = ctlBanner.frame.size.height;

        container.frame = CGRectMake(0.0, 0.0, containerWidth, containerHeight - adBannerHeight);
        ctlBanner.frame = CGRectMake(0.0, containerHeight - adBannerHeight, containerWidth, adBannerHeight);

        [self.view addSubview:ctlBanner];
    }
}

- (void)hideBanner {
    if (ctlBanner) {
        CGFloat containerHeight = defaultContainerFrame.size.height;
        CGFloat containerWidth = defaultContainerFrame.size.width;

        container.frame = CGRectMake(0.0, 0.0, containerWidth, containerHeight);
        [ctlBanner removeFromSuperview];

        ctlBanner = nil;
    }
}

- (void)changeAdBanner:(NSNotification *)notification {
    if ([[notification.userInfo objectForKey:@"visible"] boolValue]) {
        [self showBanner];
    } else {
        [self hideBanner];
    }
}

@end

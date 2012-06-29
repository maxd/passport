#import "MainViewController.h"
#import "SettingsRepository.h"
#import "LoginViewController.h"
#import "GADBannerView.h"

#define ADMOB_TOKEN @"a14fede9eb5ac32"

@interface MainViewController () {
    UIView *container;
    CGRect defaultContainerFrame;

    GADBannerView *ctlBanner;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification 
                                               object:nil];

    container = [self findContainerView];
    defaultContainerFrame = container.frame;

    [self initializeBanner];
    [self showBanner];
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

- (void) showBanner {
    CGFloat containerHeight = defaultContainerFrame.size.height;
    CGFloat containerWidth = defaultContainerFrame.size.width;

    CGFloat adBannerHeight = ctlBanner.frame.size.height;

    container.frame = CGRectMake(0.0, 0.0, containerWidth, containerHeight - adBannerHeight);
    ctlBanner.frame = CGRectMake(0.0, containerHeight - adBannerHeight, containerWidth, adBannerHeight);

    [self.view addSubview:ctlBanner];
}

- (void) hideBanner {
    CGFloat containerHeight = defaultContainerFrame.size.height;
    CGFloat containerWidth = defaultContainerFrame.size.width;

    container.frame = CGRectMake(0.0, 0.0, containerWidth, containerHeight);
    [ctlBanner removeFromSuperview];
}

@end

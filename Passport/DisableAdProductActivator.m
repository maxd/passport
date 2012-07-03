#import "DisableAdProductActivator.h"
#import "MainViewController.h"
#import "ProductIdentifiers.h"

@implementation DisableAdProductActivator

- (NSString *)productIdentifier {
    return DISABLE_AD_PRODUCT_IDENTIFIER;
}

- (BOOL)activateProduct:(SKPaymentTransaction *)transaction {
    BOOL result = [super activateProduct:transaction];

    [[NSNotificationCenter defaultCenter]
            postNotificationName:CHANGE_AD_BANNER_NOTIFICATION
                          object:self
                        userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"visible"]];

    return result;
}

@end

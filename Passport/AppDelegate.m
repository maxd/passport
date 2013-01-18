#import "AppDelegate.h"
#import "UICKeyChainStore.h"
#import "Flurry.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#ifdef ENABLE_FLURRY    
    [Flurry startSession:@"5CBRQJ9MN4R8KT65HH9F"];
#endif
    
//    [UICKeyChainStore removeAllItems];
//    NSLog(@"%@", [UICKeyChainStore keyChainStore]);
    return YES;
}

@end

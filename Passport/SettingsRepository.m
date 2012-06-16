#import "SettingsRepository.h"
#import "UICKeyChainStore.h"
#import "NSString+Hash.h"

#define PASSWORD_KEY @"password"

@implementation SettingsRepository

+ (BOOL)isValidPassword:(NSString *)password {
    NSString *currentPassword = [UICKeyChainStore stringForKey:PASSWORD_KEY];

    return (password == nil && (currentPassword == nil || [currentPassword isEqualToString:@""])) || [currentPassword isEqualToString:password.sha1];
}

+ (void)setPassword:(NSString *)password {
    [UICKeyChainStore setString:password ? password.sha1 : @"" forKey:PASSWORD_KEY];
}

@end

#import <Foundation/Foundation.h>

@interface SettingsRepository : NSObject

+ (BOOL)isValidPassword:(NSString *)password;
+ (void)setPassword:(NSString *)password;

@end

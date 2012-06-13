#import <Foundation/Foundation.h>

@class Passport;

@interface MailComposer : NSObject

- (NSString *)composeMailSubject:(Passport *)passport;
- (NSString *)composeMailBody:(Passport *)passport;

@end

#import <Foundation/Foundation.h>

@class Passport;

@interface TextComposer : NSObject

- (NSString *)composeMailSubject:(Passport *)passport;
- (NSString *)composeMailBody:(Passport *)passport;

- (NSString *)composePrintBody:(Passport *)passport;

@end

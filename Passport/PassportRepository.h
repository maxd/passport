#import <Foundation/Foundation.h>

@class Passport;

@interface PassportRepository : NSObject

- (Passport *)get;
- (void)save:(Passport *)passport;

@end

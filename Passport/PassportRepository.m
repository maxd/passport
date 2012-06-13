#import "PassportRepository.h"
#import "UICKeyChainStore.h"
#import "Passport.h"

#define PASSPORT_KEY @"passport"

@interface PassportRepository () {
}

@end

@implementation PassportRepository

- (Passport *)get {
    NSLog(@"%@", [UICKeyChainStore keyChainStore]);

    NSData *data = [UICKeyChainStore dataForKey:PASSPORT_KEY];
    return data ? [NSKeyedUnarchiver unarchiveObjectWithData:data] : [Passport new];
}

- (void)save:(Passport *)passport {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:passport];
    [UICKeyChainStore setData:data forKey:PASSPORT_KEY];
}

@end

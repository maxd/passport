#import "GenderFormatter.h"

@implementation GenderFormatter

+ (NSString *) genderToDescription:(Gender) gender {
    switch (gender) {
        case Male:
            return @"Мужчина";
        case Female:
            return @"Женщина";
        default:
            return nil;
    }
}

@end

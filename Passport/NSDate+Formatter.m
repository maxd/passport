#import "NSDate+Formatter.h"

@implementation NSDate (Formatter)

- (NSString *)toLongDate {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    
    return [dateFormatter stringFromDate:self];
}

@end

#import "TextComposer.h"
#import "Passport.h"
#import "GenderFormatter.h"
#import "NSDate+Formatter.h"

#define APPLY_TEMPLATE_PARAMETER(name, value) result = [result stringByReplacingOccurrencesOfString:name withString:value ? value : @"-"];

@implementation TextComposer

- (NSString *)composeMailSubject:(Passport *)passport {
    NSString *result = @"Паспортные данные от {last-name} {first-name} {middle-name}";

    APPLY_TEMPLATE_PARAMETER(@"{first-name}", passport.firstName);
    APPLY_TEMPLATE_PARAMETER(@"{last-name}", passport.lastName);
    APPLY_TEMPLATE_PARAMETER(@"{middle-name}", passport.middleName);
    
    return result;
}

- (NSString *)composeMailBody:(Passport *)passport {
    NSString *templatePath = [[NSBundle mainBundle] pathForResource:@"e-mail" ofType:@"template"];
    
    NSString *result = [NSString stringWithContentsOfFile:templatePath encoding:NSUTF8StringEncoding error:nil];

    return [self composeBody:result passport:passport];
}

- (NSString *)composePrintBody:(Passport *)passport {
    NSString *templatePath = [[NSBundle mainBundle] pathForResource:@"print" ofType:@"template"];

    NSString *result = [NSString stringWithContentsOfFile:templatePath encoding:NSUTF8StringEncoding error:nil];

    return [self composeBody:result passport:passport];
}

- (NSString *)composeBody:(NSString *)result passport:(Passport *)passport {
    APPLY_TEMPLATE_PARAMETER(@"{first-name}", passport.firstName);
    APPLY_TEMPLATE_PARAMETER(@"{last-name}", passport.lastName);
    APPLY_TEMPLATE_PARAMETER(@"{middle-name}", passport.middleName);
    APPLY_TEMPLATE_PARAMETER(@"{gender}", [GenderFormatter genderToDescription:passport.gender]);
    APPLY_TEMPLATE_PARAMETER(@"{day-of-birth}", [passport.dateOfBirth toLongDate]);
    APPLY_TEMPLATE_PARAMETER(@"{state}", passport.state);
    APPLY_TEMPLATE_PARAMETER(@"{city}", passport.city);

    APPLY_TEMPLATE_PARAMETER(@"{passport-series}", passport.passportSeries);
    APPLY_TEMPLATE_PARAMETER(@"{passport-number}", passport.passportNumber);

    APPLY_TEMPLATE_PARAMETER(@"{place-of-receipt}", passport.placeOfReceipt);
    APPLY_TEMPLATE_PARAMETER(@"{subdivision-code}", passport.subdivisionCode);
    APPLY_TEMPLATE_PARAMETER(@"{date-of-receipt}", [passport.dateOfReceipt toLongDate]);

    return result;
}

@end

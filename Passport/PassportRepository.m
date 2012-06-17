#import "PassportRepository.h"
#import "UICKeyChainStore.h"
#import "Passport.h"

#define PASSPORT_SERIES_KEY @"passport.series"
#define PASSPORT_NUMBER_KEY @"passport.number"

#define PASSPORT_FIRST_NAME_KEY @"passport.first-name"
#define PASSPORT_LAST_NAME_KEY @"passport.last-name"
#define PASSPORT_MIDDLE_NAME_KEY @"passport.middle-name"
#define PASSPORT_GENDER_KEY @"passport.gender"
#define PASSPORT_DATE_OF_BIRTH_KEY @"passport.date-of-birth"

#define PASSPORT_STATE_KEY @"passport.state"
#define PASSPORT_CITY_KEY @"passport.city"

#define PASSPORT_SUBDIVISION_CODE_KEY @"passport.subdivision-code"
#define PASSPORT_PLACE_OF_RECEIPT_KEY @"passport.place-of-receipt"
#define PASSPORT_DATE_OF_RECEIPT_KEY @"passport.date-of-receipt"


#define GET(key) [UICKeyChainStore stringForKey:key]
#define SET(key, value) [UICKeyChainStore setString:value ? value : @"" forKey:key]

@interface PassportRepository () {
    NSDateFormatter *dateFormatter;
}

@end

@implementation PassportRepository

- (id)init {
    self = [super init];
    if (self) {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd.MM.yyyy";
        dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    }
    return self;
}

- (Passport *)get {
    Passport *passport = [Passport new];

    passport.passportSeries = GET(PASSPORT_SERIES_KEY);
    passport.passportNumber = GET(PASSPORT_NUMBER_KEY);

    passport.firstName = GET(PASSPORT_FIRST_NAME_KEY);
    passport.lastName = GET(PASSPORT_LAST_NAME_KEY);
    passport.middleName = GET(PASSPORT_MIDDLE_NAME_KEY);
    passport.gender = (Gender) [GET(PASSPORT_GENDER_KEY) intValue];
    passport.dateOfBirth = [dateFormatter dateFromString:GET(PASSPORT_DATE_OF_BIRTH_KEY)];

    passport.state = GET(PASSPORT_STATE_KEY);
    passport.city = GET(PASSPORT_CITY_KEY);

    passport.subdivisionCode = GET(PASSPORT_SUBDIVISION_CODE_KEY);
    passport.placeOfReceipt = GET(PASSPORT_PLACE_OF_RECEIPT_KEY);
    passport.dateOfReceipt = [dateFormatter dateFromString:GET(PASSPORT_DATE_OF_RECEIPT_KEY)];

    return passport;
}

- (void)save:(Passport *)passport {
    SET(PASSPORT_SERIES_KEY, passport.passportSeries);
    SET(PASSPORT_NUMBER_KEY, passport.passportNumber);

    SET(PASSPORT_FIRST_NAME_KEY, passport.firstName);
    SET(PASSPORT_LAST_NAME_KEY, passport.lastName);
    SET(PASSPORT_MIDDLE_NAME_KEY, passport.middleName);
    SET(PASSPORT_GENDER_KEY, [[NSNumber numberWithInt:passport.gender] stringValue]);
    SET(PASSPORT_DATE_OF_BIRTH_KEY, [dateFormatter stringFromDate:passport.dateOfBirth]);

    SET(PASSPORT_STATE_KEY, passport.state);
    SET(PASSPORT_CITY_KEY, passport.city);

    SET(PASSPORT_SUBDIVISION_CODE_KEY, passport.subdivisionCode);
    SET(PASSPORT_PLACE_OF_RECEIPT_KEY, passport.placeOfReceipt);
    SET(PASSPORT_DATE_OF_RECEIPT_KEY, [dateFormatter stringFromDate:passport.dateOfReceipt]);
}

@end

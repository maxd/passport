#import "Passport.h"

@implementation Passport

@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize middleName = _middleName;
@synthesize gender = _gender;
@synthesize dateOfBirth = _dateOfBirth;
@synthesize city = _city;
@synthesize state = _state;

@synthesize passportSeries = _passportSeries;
@synthesize passportNumber = _passportNumber;

@synthesize subdivisionCode = _subdivisionCode;
@synthesize placeOfReceipt = _placeOfReceipt;
@synthesize dateOfReceipt = _dateOfReceipt;

- (id)init {
    self = [super init];
    if (self) {
        _gender = UnknownGender;
    }
    return self;
}

@end

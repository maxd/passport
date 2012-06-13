#import "Passport.h"
#import "NSCoding.h"

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

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        DECODEOBJECT(_firstName);
        DECODEOBJECT(_lastName);
        DECODEOBJECT(_middleName);
        DECODEINT(_gender);
        DECODEOBJECT(_dateOfBirth);
        DECODEOBJECT(_city);
        DECODEOBJECT(_state);

        DECODEOBJECT(_passportSeries);
        DECODEOBJECT(_passportNumber);

        DECODEOBJECT(_subdivisionCode);
        DECODEOBJECT(_placeOfReceipt);
        DECODEOBJECT(_dateOfReceipt);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    ENCODEOBJECT(_firstName);
    ENCODEOBJECT(_lastName);
    ENCODEOBJECT(_middleName);
    ENCODEINT(_gender);
    ENCODEOBJECT(_dateOfBirth);
    ENCODEOBJECT(_city);
    ENCODEOBJECT(_state);

    ENCODEOBJECT(_passportSeries);
    ENCODEOBJECT(_passportNumber);

    ENCODEOBJECT(_subdivisionCode);
    ENCODEOBJECT(_placeOfReceipt);
    ENCODEOBJECT(_dateOfReceipt);
}

@end

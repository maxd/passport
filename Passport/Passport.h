#import <Foundation/Foundation.h>
#import "Gender.h"

@interface Passport : NSObject

@property (strong) NSString *firstName;
@property (strong) NSString *lastName;
@property (strong) NSString *middleName;
@property (assign) Gender gender;
@property (strong) NSDate *dateOfBirth;
@property (strong) NSString *city;
@property (strong) NSString *state;

@property (strong) NSString *passportSeries;
@property (strong) NSString *passportNumber;

@property (strong) NSString *subdivisionCode;
@property (strong) NSString *placeOfReceipt;
@property (strong) NSDate *dateOfReceipt;

@end

#import <MessageUI/MessageUI.h>
#import "PassportViewController.h"
#import "Passport.h"
#import "ActionSheetPicker.h"
#import "PassportRepository.h"
#import "NSDate+Formatter.h"
#import "TextComposer.h"
#import "GenderFormatter.h"
#import "SettingsRepository.h"
#import "Flurry.h"
#import "StatesViewController.h"
#import "CitiesViewController.h"

@interface PassportViewController () <UITextFieldDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate,
        StatesViewControllerDelegate, CitiesViewControllerDelegate> {
    IBOutlet UITextField *txtPassportSeries;
    IBOutlet UITextField *txtPassportNumber;

    IBOutlet UITextField *txtLastName;
    IBOutlet UITextField *txtFirstName;
    IBOutlet UITextField *txtMiddleName;
    IBOutlet UITextField *txtGender;
    IBOutlet UITextField *txtBirthDay;
    IBOutlet UITextField *txtState;
    IBOutlet UITextField *txtCity;

    IBOutlet UITextField *txtSubdivisionCode;
    IBOutlet UITextField *txtPlaceOfReceipt;
    IBOutlet UITextField *txtDateOfReceipt;

    PassportRepository *passportRepository;
    Passport *passport;
}

@end

@implementation PassportViewController

#pragma mark View settings

- (void)viewDidLoad {
    [super viewDidLoad];

    passportRepository = [PassportRepository new];

    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (!self.isEditing) {
        passport = [passportRepository get];

        [self showPassportData];
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];

    txtFirstName.enabled = editing;
    txtLastName.enabled = editing;
    txtMiddleName.enabled = editing;

    txtPassportSeries.enabled = editing;
    txtPassportNumber.enabled = editing;
    
    txtSubdivisionCode.enabled = editing;
    txtPlaceOfReceipt.enabled = editing;

    if (editing) {
        passport = [passportRepository get];
        [self showPassportData];
        
        [Flurry logEvent:@"START_EDIT_PASSPORT"];
    } else {
        [self fillPassport];
        [passportRepository save:passport];
        
        if ([txtPassportSeries.text length] != 0 && [txtPassportNumber.text length] != 0 && [SettingsRepository isValidPassword:nil]) {
            [self performSegueWithIdentifier:@"ShowPasswordView" sender:self];
        }
    }
}

#pragma mark UITableView settings

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark TextField handlers

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark UITableView handlers

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 3) {
        NSArray *genders = [NSArray arrayWithObjects:@"Мужской", @"Женский", nil];

        ActionSheetStringPicker *stringPicker = [[ActionSheetStringPicker alloc]
                initWithTitle:@"Пол"
                         rows:genders
             initialSelection:(passport.gender == UnknownGender ? Male : passport.gender) - (int)Male
                       target:self
                successAction:@selector(genderWasSelected:origin:)
                 cancelAction:nil
                       origin:tableView];

        [stringPicker showActionSheetPicker];
    }

    if (indexPath.section == 1 && indexPath.row == 4) {
        ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc]
                 initWithTitle:@"Дата рождения"
                datePickerMode:UIDatePickerModeDate
                  selectedDate:passport.dateOfBirth ? passport.dateOfBirth : [NSDate new]
                        target:self
                        action:@selector(birthDateWasSelected:origin:)
                        origin:tableView];

        [datePicker showActionSheetPicker];
    }
    
    if (indexPath.section == 3 && indexPath.row == 2) {
        ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc]
                                             initWithTitle:@"Дата выдачи"
                                             datePickerMode:UIDatePickerModeDate
                                             selectedDate:passport.dateOfReceipt ? passport.dateOfReceipt : [NSDate new]
                                             target:self
                                             action:@selector(dateOfReceiptWasSelected:origin:)
                                             origin:tableView];
        
        [datePicker showActionSheetPicker];
    }
}

- (void)genderWasSelected:(NSNumber *)index origin:(id)origin {
    Gender gender = (Gender) ([index integerValue] + (int)Male);

    if (passport.gender != gender) {
        passport.gender = gender;

        txtGender.text = [GenderFormatter genderToDescription:passport.gender];

        [Flurry logEvent:@"FILL_FIELD_GENDER"];
    }
}

- (void)birthDateWasSelected:(NSDate *)date origin:(id)origin {
    if (![passport.dateOfBirth isEqualToDate:date]) {
        passport.dateOfBirth = date;

        txtBirthDay.text = [date toLongDate];

        [Flurry logEvent:@"FILL_FIELD_BIRTH_DAY"];
    }
}

- (void)dateOfReceiptWasSelected:(NSDate *)date origin:(id)origin {
    if (![passport.dateOfReceipt isEqualToDate:date]) {
        passport.dateOfReceipt = date;

        txtDateOfReceipt.text = [date toLongDate];

        [Flurry logEvent:@"FILL_FIELD_DATE_OF_RECEIPT"];
    }
}

#pragma mark Passport helpers

- (void)showPassportData {
    txtFirstName.text = passport.firstName;
    txtLastName.text = passport.lastName;
    txtMiddleName.text = passport.middleName;
    txtGender.text = [GenderFormatter genderToDescription:passport.gender];
    txtBirthDay.text = [passport.dateOfBirth toLongDate];
    txtCity.text = passport.city;
    txtState.text = passport.state;

    txtPassportSeries.text = passport.passportSeries;
    txtPassportNumber.text = passport.passportNumber;

    txtSubdivisionCode.text = passport.subdivisionCode;
    txtPlaceOfReceipt.text = passport.placeOfReceipt;
    txtDateOfReceipt.text = [passport.dateOfReceipt toLongDate];
}

#define FILL_FIELD(field, newValue, eventName) \
if (![field isEqualToString:newValue]) { \
    field = newValue; \
    [Flurry logEvent:[NSString stringWithFormat:@"FILL_FIELD_%@", eventName]]; \
}

- (void)fillPassport {
    FILL_FIELD(passport.passportSeries, txtPassportSeries.text, @"PASSPORT_SERIES")
    FILL_FIELD(passport.passportNumber, txtPassportNumber.text, @"PASSPORT_NUMBER")

    FILL_FIELD(passport.lastName, txtLastName.text, @"LAST_NAME")
    FILL_FIELD(passport.firstName, txtFirstName.text, @"FIRST_NAME")
    FILL_FIELD(passport.middleName, txtMiddleName.text, @"MIDDLE_NAME")
    FILL_FIELD(passport.city, txtCity.text, @"CITY")
    FILL_FIELD(passport.state, txtState.text, @"STATE")

    FILL_FIELD(passport.subdivisionCode, txtSubdivisionCode.text, @"SUBDEVISION_CODE")
    FILL_FIELD(passport.placeOfReceipt, txtPlaceOfReceipt.text, @"PLACE_OF_RECEIPT")
}

#pragma mark Send/Print Actions

- (IBAction)sendAction:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Отмена" destructiveButtonTitle:nil otherButtonTitles:nil];
    if ([MFMailComposeViewController canSendMail]) {
        [actionSheet addButtonWithTitle:@"Отправить по e-mail"];
    }
    if ([UIPrintInteractionController isPrintingAvailable]) {
        [actionSheet addButtonWithTitle:@"Распечатать на принтере"];
    }
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:
            [self sendMail];
            break;
        case 2:
            [self print];
            break;
    }
}

- (void)sendMail {
    [Flurry logEvent:@"SEND_MAIL_PASSPORT_DATA"];

    TextComposer *textComposer = [TextComposer new];
    NSString *subject = [textComposer composeMailSubject:passport];
    NSString *body = [textComposer composeMailBody:passport];
    
    MFMailComposeViewController *controller = [MFMailComposeViewController new];
    controller.mailComposeDelegate = self;
    [controller setSubject:subject];
    [controller setMessageBody:body isHTML:NO];

    [self presentModalViewController:controller animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)print {
    [Flurry logEvent:@"PRINT_PASSPORT_DATA"];

    TextComposer *textComposer = [TextComposer new];

    UISimpleTextPrintFormatter *printFormatter = [[UISimpleTextPrintFormatter alloc] initWithText:[textComposer composePrintBody:passport]];
    UIFont *font = [UIFont fontWithName:@"Courier New" size:17.0];
    printFormatter.font = font;

    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = @"Паспортные данные";
    printInfo.duplex = UIPrintInfoDuplexNone;

    UIPrintInteractionController *printController = [UIPrintInteractionController sharedPrintController];
    printController.printInfo = printInfo;
    printController.showsPageRange = NO;
    printController.printFormatter = printFormatter;
    [printController presentAnimated:YES completionHandler:nil];
}

#pragma mark Prepare for Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowStatesView"]) {
        StatesViewController *statesViewController = segue.destinationViewController;
        statesViewController.delegate = self;
        statesViewController.state = txtState.text;
    } else if ([segue.identifier isEqualToString:@"ShowCitiesView"]) {
        CitiesViewController *citiesViewController = segue.destinationViewController;
        citiesViewController.delegate = self;
        citiesViewController.state = txtState.text;
        citiesViewController.city = txtCity.text;
    }
}

#pragma mark States View Controller Handler

- (void)didSelectState:(NSString *)state {
    txtState.text = state;
}

#pragma mark Cities View Controller Handler

- (void)didSelectCity:(NSString *)city {
    txtCity.text = city;
}

@end

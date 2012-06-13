#import <MessageUI/MessageUI.h>
#import "PassportViewController.h"
#import "Passport.h"
#import "ActionSheetPicker.h"
#import "PassportRepository.h"
#import "NSDate+Formatter.h"
#import "MailComposer.h"
#import "GenderFormatter.h"

@interface PassportViewController () <UITextFieldDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate> {
    IBOutlet UITextField *txtFirstName;
    IBOutlet UITextField *txtLastName;
    IBOutlet UITextField *txtMiddleName;
    IBOutlet UITextField *txtGender;
    IBOutlet UITextField *txtBirthDay;
    IBOutlet UITextField *txtCity;
    IBOutlet UITextField *txtState;

    IBOutlet UITextField *txtPassportSeries;
    IBOutlet UITextField *txtPassportNumber;

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

    passport = [passportRepository get];

    [self showPassportData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];

    txtFirstName.enabled = editing;
    txtLastName.enabled = editing;
    txtMiddleName.enabled = editing;
    txtState.enabled = editing;
    txtCity.enabled = editing;
    
    txtPassportSeries.enabled = editing;
    txtPassportNumber.enabled = editing;
    
    txtSubdivisionCode.enabled = editing;
    txtPlaceOfReceipt.enabled = editing;

    if (editing) {
        passport = [passportRepository get];
        [self showPassportData];
    } else {
        [self fillPassport];
        [passportRepository save:passport];
    }
}

#pragma mark UITableView settings

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

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
             initialSelection:passport.gender
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
                                             selectedDate:passport.dateOfBirth ? passport.dateOfBirth : [NSDate new]
                                             target:self
                                             action:@selector(dateOfReceiptWasSelected:origin:)
                                             origin:tableView];
        
        [datePicker showActionSheetPicker];
    }
}

- (void)genderWasSelected:(NSNumber *)index origin:(id)origin {
    Gender gender = (Gender) [index integerValue];

    passport.gender = gender;
    
    txtGender.text = [GenderFormatter genderToDescription:passport.gender];
}

- (void)birthDateWasSelected:(NSDate *)date origin:(id)origin {
    passport.dateOfBirth = date;

    txtBirthDay.text = [date toLongDate];
}

- (void)dateOfReceiptWasSelected:(NSDate *)date origin:(id)origin {
    passport.dateOfReceipt = date;
    
    txtDateOfReceipt.text = [date toLongDate];
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

- (void)fillPassport {
    passport.firstName = txtFirstName.text;
    passport.lastName = txtLastName.text;
    passport.middleName = txtMiddleName.text;
    passport.city = txtCity.text;
    passport.state = txtState.text;

    passport.passportSeries = txtPassportSeries.text;
    passport.passportNumber = txtPassportNumber.text;

    passport.subdivisionCode = txtSubdivisionCode.text;
    passport.placeOfReceipt = txtPlaceOfReceipt.text;
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
    MailComposer *mailComposer = [MailComposer new];
    NSString *subject = [mailComposer composeMailSubject:passport];
    NSString *body = [mailComposer composeMailBody:passport];
    
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

}

@end

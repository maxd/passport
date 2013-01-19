#import "CitiesViewController.h"
#import "JSONKit.h"
#import "CustomCityViewController.h"

#define TITLE_FIELD @"title"

@interface CitiesViewController () <UISearchBarDelegate, CustomCityViewControllerDelegate> {
    IBOutlet UISearchBar *ctlSearchBar;
    IBOutlet UILabel *lblEmptyTable;

    NSArray *cities;
}

@end

@implementation CitiesViewController

@synthesize delegate = _delegate;
@synthesize state = _state;
@synthesize city = _city;


- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *statesFilePath = [[NSBundle mainBundle] pathForResource:@"states" ofType:@"json"];
    NSData *statesFileContent = [NSData dataWithContentsOfFile:statesFilePath];

    NSArray *states = [statesFileContent objectFromJSONData];
    states = [states filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title == %@", self.state]];
    NSDictionary *stateObj = states.count != 0 ? [states objectAtIndex:0] : nil;
    NSNumber *stateId = [NSNumber numberWithInt:[[stateObj objectForKey:@"id"] intValue]];

    NSString *citiesFilePath = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"json"];
    NSData *citiesFileContent = [NSData dataWithContentsOfFile:citiesFilePath];

    NSArray *allCities = [citiesFileContent objectFromJSONData];
    cities = [allCities filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"state == %@", stateId]];
    
    NSMutableDictionary *otherCity = [NSMutableDictionary new];
    [otherCity setObject:@"Ввести другой город" forKey:@"title"];
    cities = [cities arrayByAddingObject:otherCity];
}

#pragma mark State Filter

- (NSArray *)filteredCities {
    if ([ctlSearchBar.text length] != 0)
        return [cities filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title BEGINSWITH[c] %@ OR id == NIL", ctlSearchBar.text]];
    return cities;
}

#pragma mark Table Handlers

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger statesCount = [self.filteredCities count];

    lblEmptyTable.hidden = statesCount != 0;

    return statesCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *stateObj = [self.filteredCities objectAtIndex:(NSUInteger) indexPath.row];

    NSString *stateTitle = [stateObj objectForKey:TITLE_FIELD];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityCell"];
    cell.textLabel.text = stateTitle;
    cell.accessoryType = [self.city isEqualToString:stateTitle] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    cell.accessoryType = ![stateObj objectForKey:@"id"] ? UITableViewCellAccessoryDisclosureIndicator : cell.accessoryType;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *stateObj = [self.filteredCities objectAtIndex:(NSUInteger) indexPath.row];

    [ctlSearchBar setShowsCancelButton:NO animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    if ([stateObj objectForKey:@"id"]) {
        [self.delegate didSelectCity:[stateObj objectForKey:TITLE_FIELD]];

        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self performSegueWithIdentifier:@"ShowCustomCityView" sender:self];
    }
}

#pragma mark SearchBar Handlers

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [ctlSearchBar setShowsCancelButton:YES animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [ctlSearchBar setShowsCancelButton:NO animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    return YES;
}

#pragma mark Perform Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowCustomCityView"]) {
        CustomCityViewController *controller = segue.destinationViewController;
        controller.delegate = self;
        controller.city = self.city;
    }
}

#pragma mark Custom City Delegate Handler

- (void)didSelectCustomCity:(NSString *)city {
    [self.delegate didSelectCity:city];

    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end

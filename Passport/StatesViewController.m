#import "StatesViewController.h"
#import "JSONKit.h"

#define TITLE_FIELD @"title"

@interface StatesViewController () <UISearchBarDelegate> {
    IBOutlet UISearchBar *ctlSearchBar;
    IBOutlet UILabel *lblEmptyTable;
    
    NSArray *states;
}

@end

@implementation StatesViewController

@synthesize delegate = _delegate;
@synthesize state = _state;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *statesFilePath = [[NSBundle mainBundle] pathForResource:@"states" ofType:@"json"];
    NSData *statesFileContent = [NSData dataWithContentsOfFile:statesFilePath];

    states = [statesFileContent objectFromJSONData];
}

#pragma mark State Filter

- (NSArray *)filteredStates {
    if ([ctlSearchBar.text length] != 0)
        return [states filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title BEGINSWITH[c] %@", ctlSearchBar.text]];
    return states;
}

#pragma mark Table Handlers

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger statesCount = [self.filteredStates count];

    lblEmptyTable.hidden = statesCount != 0;

    return statesCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *stateObj = [self.filteredStates objectAtIndex:(NSUInteger) indexPath.row];

    NSString *stateTitle = [stateObj objectForKey:TITLE_FIELD];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StateCell"];
    cell.textLabel.text = stateTitle;
    cell.accessoryType = [self.state isEqualToString:stateTitle] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *stateObj = [self.filteredStates objectAtIndex:(NSUInteger) indexPath.row];

    [self.delegate didSelectState:[stateObj objectForKey:TITLE_FIELD]];

    [ctlSearchBar setShowsCancelButton:NO animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    [self.navigationController popViewControllerAnimated:YES];
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

@end

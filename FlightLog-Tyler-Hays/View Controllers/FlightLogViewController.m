//
//  FlightLogViewController.m
//  FlightLog-Tyler-Hays
//
//  Created by Tyler Hays on 4/8/19.
//  Copyright © 2019 Tyler Hays. All rights reserved.
//

#import "FlightLogViewController.h"
#import "DBUtility.h"
#import "FlightLog.h"
#import "FlightLogQueries.h"
#import "FlightLogTableViewCell.h"
#import "FlightViewViewController.h"

@interface FlightLogViewController ()<UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSArray <FlightLog *> * displayFlightLog;
@property (strong, nonatomic) FlightLog *flightLogToDisplay;

@end

@implementation FlightLogViewController

NSString *viewFlightSegue = @"ViewFlightSegue";
- (void)viewDidLoad {
    [super viewDidLoad];
    
  
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.flightLogs = [[FlightLogQueries getAllFlights] mutableCopy];
    self.displayFlightLog = self.flightLogs;
    [self.tableView reloadData];
}

- (void)resetDisplayListToDefault {
    self.displayFlightLog = self.flightLogs;
    [self.tableView reloadData];
}

- (void)searchByAircraft:(NSString *)searchValue {
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF.airCraftIdentifier CONTAINS[cd] %@", searchValue];
    self.displayFlightLog = [self.flightLogs filteredArrayUsingPredicate:predicate] ;
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:viewFlightSegue]) {
        FlightViewViewController *vc = segue.destinationViewController;
        [vc setupViewWithLog:self.flightLogToDisplay];
    }
}

#pragma mark - Tableview Datasource and Delegates
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    FlightLogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FlightCell" forIndexPath:indexPath];
    FlightLog *log = [self.displayFlightLog objectAtIndex:indexPath.row];
    [cell setupCellwithFlightLog:log];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.displayFlightLog.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.flightLogToDisplay = self.displayFlightLog[indexPath.row];
    [self performSegueWithIdentifier:viewFlightSegue sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - search bar delegates
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = NO;
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
    [searchBar setText:@""];
    self.displayFlightLog = self.flightLogs;
    [self.tableView reloadData];
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(nonnull NSString *)searchText {
    if (searchText.length == 0) {
        self.displayFlightLog = self.flightLogs;
        [self.tableView reloadData];
        return;
    }
    [self searchByAircraft:searchText];
}
@end

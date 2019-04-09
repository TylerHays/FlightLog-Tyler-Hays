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

@interface FlightLogViewController ()<UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSArray <FlightLog *> * displayFlightLog;

@end

@implementation FlightLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.flightLogs = [[FlightLogQueries getAllFlights] mutableCopy];
    self.displayFlightLog = self.flightLogs;
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

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    FlightLogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FlightCell" forIndexPath:indexPath];
    FlightLog *log = [self.displayFlightLog objectAtIndex:indexPath.row];
    [cell setupCellwithFlightLog:log];
    
    return cell;
   
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.displayFlightLog.count;
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

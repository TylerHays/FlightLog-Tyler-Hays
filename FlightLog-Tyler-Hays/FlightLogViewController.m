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

@interface FlightLogViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSMutableArray <FlightLog *> * displayFlightLog;

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
    
    NSMutableArray *displayFlights = [[NSMutableArray alloc] init];
    for (FlightLog *flight in self.flightLogs) {
        NSString *identtifier = flight.airCraftIdentifier;
        if ([identtifier rangeOfString:@"bla"].location != NSNotFound) {
            [displayFlights addObject:flight];
        }
    }
    self.displayFlightLog = displayFlights;
    [self.tableView reloadData];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [[UITableViewCell alloc] init];
   
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.displayFlightLog.count;
}


@end

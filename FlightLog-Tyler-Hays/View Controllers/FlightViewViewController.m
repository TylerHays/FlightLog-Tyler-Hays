//
//  FlightViewViewController.m
//  FlightLog-Tyler-Hays
//
//  Created by Tyler Hays on 4/12/19.
//  Copyright © 2019 Tyler Hays. All rights reserved.
//

#import "FlightViewViewController.h"
#import "FlightLog.h"
#import "FlightLogQueries.h"
#import "EditFlightViewController.h"

@interface FlightViewViewController ()
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UILabel *aircraftLabel;
@property (weak, nonatomic) IBOutlet UILabel *flightTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *flightDateLabel;


@end

@implementation FlightViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}


- (IBAction)deletePressed:(id)sender {
    [FlightLogQueries deleteFlightLog:self.flightLog];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupViewWithLog:(FlightLog *)flightLog {
    self.flightLog = flightLog;
}

- (void)setupView {
    self.aircraftLabel.text = [self flightLog].airCraftIdentifier;
    self.flightTimeLabel.text = [NSString stringWithFormat:@"%f"  , [self flightLog].flightTime ];
    self.flightDateLabel.text = [self flightLog].flightDate;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EditFlightViewController *editFlight = [segue destinationViewController];
    [editFlight setupWithFlightLog:self.flightLog];
}

@end

//
//  EditFlightViewController.m
//  FlightLog-Tyler-Hays
//
//  Created by Tyler Hays on 4/8/19.
//  Copyright © 2019 Tyler Hays. All rights reserved.
//

#import "EditFlightViewController.h"
#import "FlightLogViewController.h"
#import "DBUtility.h"
#import "FlightLog.h"
#import "FlightLogQueries.h"
#import "Utility.h"

@interface EditFlightViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *airCraftTextField;
@property (weak, nonatomic) IBOutlet UITextField *flightTimeTextField;
@property (nonatomic, strong, nullable) FlightLog *flightLog;

@end

@implementation EditFlightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.flightLog == nil) {
        self.flightLog = [[FlightLog alloc] init];
    } else {
        [self setupViewWithFligtLog:self.flightLog];
    }
    self.airCraftTextField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
}

-(void)setupWithFlightLog:(FlightLog *)flightLog {
    self.flightLog = flightLog;
}

-(void)setupViewWithFligtLog:(FlightLog *)flightLog {
    [self.airCraftTextField setText:flightLog.airCraftIdentifier];
    
    NSString *flightTime =  [Utility displayFlightHoursFormate:[self flightLog].flightTime];
    [self flightTimeTextField].text = flightTime;
    [self.datePicker setDate:[flightLog getDateFromFlightDate]];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return false;
    }
    
    if (textField != self.flightTimeTextField) {
        return true;
    }
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSArray  *arrayOfString = [newString componentsSeparatedByString:@"."];
    
    if ([arrayOfString count] > 2) {
        return NO;
    }
    if (![self isNumeric:string]){
        return NO;
    }
    
    return YES;
}

- (BOOL)isNumeric:(NSString *)input {
    for (int i = 0; i < [input length]; i++) {
        char c = [input characterAtIndex:i];
        if (!((c >= '0' && c <= '9') || c=='.')) {
            return NO;
        }
    }
    return YES;
}

- (IBAction)saveFlightClicked:(id)sender {
    FlightLog *flight = self.flightLog;
    NSString *flightTimeText = [self flightTimeTextField].text;
    flight.airCraftIdentifier = self.airCraftTextField.text;
    flight.flightTime = [flightTimeText doubleValue];
    [flight setFlightDateFromDate:[self datePicker].date];
    [FlightLogQueries createOrUpdateFlightLog:flight];
    [self.navigationController popViewControllerAnimated:YES];
}

@end

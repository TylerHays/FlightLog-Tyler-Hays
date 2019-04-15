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
  //  self.flightTimeTextField.num
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)setupWithFlightLog:(FlightLog *)flightLog {
    self.flightLog = flightLog;
}

-(void)setupViewWithFligtLog:(FlightLog *)flightLog {
    [self.airCraftTextField setText:flightLog.airCraftIdentifier];
    
    NSString *flightTime =  [NSString stringWithFormat:@"%g hours", flightLog.flightTime ];
    [self flightTimeTextField].text = flightTime;
    [self.datePicker setDate:[flightLog getDateFromFlightDate]];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.airCraftTextField) {
        [self aircraftTextField:textField shouldChangeCharactersInRange:range replacementString:string];
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

- (BOOL)aircraftTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return true;
}

- (BOOL)isNumeric:(NSString *)input {
    for (int i = 0; i < [input length]; i++) {
        char c = [input characterAtIndex:i];
        // Allow a leading '-' for negative integers
        if (!((c >= '0' && c <= '9') || c=='.')) {
            return NO;
        }
    }
    return YES;
}


- (IBAction)saveFlightClicked:(id)sender {
    
    //TODO: Add error checker
    FlightLog *flight = self.flightLog;
    NSString *flightTimeText = [self flightTimeTextField].text;
    flight.airCraftIdentifier = self.airCraftTextField.text;
    flight.flightTime = [flightTimeText doubleValue];
    [flight setFlightDateFromDate:[self datePicker].date];
    [FlightLogQueries createOrUpdateFlightLog:flight];
    [self.navigationController popViewControllerAnimated:YES];
}

@end

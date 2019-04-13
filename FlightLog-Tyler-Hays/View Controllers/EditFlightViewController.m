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
    
    NSString *flightTime =  [NSString stringWithFormat:@"%f hours", flightLog.flightTime ];
    
     
   // [self.flightTimeTextField text] = flightLog.flightTime
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSArray  *arrayOfString = [newString componentsSeparatedByString:@"."];
    
    if ([arrayOfString count] > 2) {
        return NO;
    }
    if (![self isNumeric:newString]){
        return NO;
    }
    
    return YES;
}

- (BOOL)isNumeric:(NSString *)input {
    for (int i = 0; i < [input length]; i++) {
        char c = [input characterAtIndex:i];
        // Allow a leading '-' for negative integers
        if ((c >= '0' && c <= '9') || c=='.') {
            return YES;
        }
    }
    return NO;
}


- (IBAction)saveFlightClicked:(id)sender {
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy/mm/dd"];
    FlightLog *flight = self.flightLog;
    flight.airCraftIdentifier = self.airCraftTextField.text;
    flight.flightTime = 3;
    NSDate *date = self.datePicker.date;
    flight.flightDate = [dateFormater stringFromDate:date];
    [FlightLogQueries createOrUpdateFlightLog:flight];
    [self.navigationController popViewControllerAnimated:YES];
}

@end

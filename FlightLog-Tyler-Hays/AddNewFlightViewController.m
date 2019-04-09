//
//  AddNewFlightViewController.m
//  FlightLog-Tyler-Hays
//
//  Created by Tyler Hays on 4/8/19.
//  Copyright © 2019 Tyler Hays. All rights reserved.
//

#import "AddNewFlightViewController.h"
#import "FlightLogViewController.h"
#import "DBUtility.h"
#import "FlightLog.h"
#import "FlightLogQueries.h"

@interface AddNewFlightViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *airCraftTextField;
@property (weak, nonatomic) IBOutlet UITextField *flightTimeTextField;

@end

@implementation AddNewFlightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    [dateFormater setDateFormat:@"MM/DD/yyyy"];
    FlightLog *flight = [[FlightLog alloc] init];
    flight.airCraftIdentifier = self.airCraftTextField.text;
    flight.flightTime = 3;
    NSDate *date = self.datePicker.date;
    flight.flightDate = [dateFormater stringFromDate:date];
    [FlightLogQueries createOrUpdateFlightLog:flight];
    
   
    NSLog(@"saved");
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end

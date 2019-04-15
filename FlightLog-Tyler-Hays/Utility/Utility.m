//
//  Utility.m
//  FlightLog-Tyler-Hays
//
//  Created by Tyler Hays on 4/14/19.
//  Copyright © 2019 Tyler Hays. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+ (NSString *)displayFlightHoursFormate:(double)flightHours {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = 20;
    NSNumber *number = [NSNumber numberWithDouble:flightHours];
    return [formatter stringFromNumber:number];
}

@end

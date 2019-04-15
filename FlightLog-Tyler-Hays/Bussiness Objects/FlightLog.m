//
//  FlightLog.m
//  TylerFlightLog
//
//  Created by Tyler Hays on 4/8/19.
//  Copyright © 2019 Tyler Hays. All rights reserved.
//

#import "FlightLog.h"

@implementation FlightLog

static NSDateFormatter *defaultDateFormater;
static NSDateFormatter *monthDayYearFomater;



- (void)setFlightDateFromDate:(NSDate *)date {
    NSDateFormatter *dateFormater = [self getDefaultDateFormater];
    self.flightDate = [dateFormater stringFromDate:date];
}

- (NSDate *)getDateFromFlightDate {
    NSDateFormatter *dateFormater = [self getDefaultDateFormater];
    return [dateFormater dateFromString:self.flightDate];
}

- (NSString *)flightDateWithMonthDayYear {
    NSDate * date = [self getDateFromFlightDate];
    NSDateFormatter *dFormatter = [[NSDateFormatter alloc] init];
    [dFormatter setDateFormat:@"MM/dd/yyyy"];
    return [dFormatter stringFromDate:date];
}


- (NSDateFormatter *)getDefaultDateFormater {
    NSDateFormatter *dFormatter = [[NSDateFormatter alloc] init];
    [dFormatter setDateFormat:@"yyyy/MM/dd"];
    return dFormatter;
}

@end

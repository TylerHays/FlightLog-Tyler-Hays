//
//  FlightLog.h
//  TylerFlightLog
//
//  Created by Tyler Hays on 4/8/19.
//  Copyright © 2019 Tyler Hays. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlightLog : NSObject

@property (readwrite, nonatomic) NSInteger dbId;
@property (nonnull, strong, nonatomic) NSString *airCraftIdentifier;
@property (nonatomic, readwrite) double flightTime;
@property (nonatomic, strong, nonatomic) NSString *flightDate;

- (void)setFlightDateFromDate:(NSDate *)date;
- (NSDate *)getDateFromFlightDate;
- (NSString *)flightDateWithMonthDayYear;

@end

NS_ASSUME_NONNULL_END

//
//  FlightLogQueries.h
//  FlightLog-Tyler-Hays
//
//  Created by Tyler Hays on 4/8/19.
//  Copyright © 2019 Tyler Hays. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FlightLog;

NS_ASSUME_NONNULL_BEGIN

@interface FlightLogQueries : NSObject

+ (FlightLog *)getFlightLogById:(NSInteger)dbId;
+ (NSInteger)createOrUpdateFlightLog:(FlightLog *)flightLog;
+ (NSArray *)getAllFlights;
+ (void)deleteFlightLog:(FlightLog *)flightLog;
@end

NS_ASSUME_NONNULL_END

//
//  FlightLogQueries.m
//  FlightLog-Tyler-Hays
//
//  Created by Tyler Hays on 4/8/19.
//  Copyright © 2019 Tyler Hays. All rights reserved.
//

#import "FlightLogQueries.h"
#import "FlightLog.h"
#import "GenericDao.h"

@implementation FlightLogQueries

+ (FlightLog *)getFlightLogById:(NSInteger)dbId {
    return [GenericDao readObjectOfClass:[FlightLog class] withId:dbId];
}

+ (NSInteger)createOrUpdateFlightLog:(FlightLog *)flightLog {
    return [GenericDao createOrUpdate:flightLog];
}

+ (void)deleteFlightLog:(FlightLog *)flightLog {
    [GenericDao removeObject:flightLog];
}

+ (NSArray *)getAllFlights {
    NSString *orderByClause = @"FlightDate DESC";
    return [GenericDao readEntireListOfObject:[FlightLog class] WithOrderByClause:orderByClause];
}

@end

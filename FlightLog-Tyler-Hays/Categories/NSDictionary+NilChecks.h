//
//  NSDictionary+NilChecks.h
//  TylerFlightLog
//
//  Created by Tyler Hays on 4/7/19.
//  Copyright © 2019 Tyler Hays. All rights reserved.
//
//
#import <Foundation/Foundation.h>
@interface NSDictionary (NilChecks)

- (NSString *)getStringValueForKey:(NSString *) key;
- (double) getDoubleValueForKey:(NSString *)key;
- (NSInteger) getIntValueForKey:(NSString *)key;

/**
 * Returns YES if value is "True", No otherwise.
 */
- (BOOL)getTrueOrFalseValueForKey:(NSString *)key;

@end

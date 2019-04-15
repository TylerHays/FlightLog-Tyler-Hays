//
//  NSDictionary+NilChecks.m
//  TylerFlightLog
//
//  Created by Tyler Hays on 4/7/19.
//  Copyright © 2019 Tyler Hays. All rights reserved.
//

#import "NSDictionary+NilChecks.h"

@implementation NSDictionary (NilChecks)

-(NSString *)getStringValueForKey:(NSString *)key {
    id str = [self valueForKey:key] ;
    if (!str) str = @"" ;
    if (str  == [NSNull null]) str = @"" ;
    
    // Changed to valueForKey and forced string conversion to prevent crashes when you force an int -> str.
    return [NSString stringWithFormat:@"%@", str] ;
}

-(double)getDoubleValueForKey:(NSString *)key {
    id str = [self objectForKey:key] ;
    if (!str) str = @"" ;
    if (str  == [NSNull null]) str = @"" ;
    return [str doubleValue];
}

-(float)getFloatValueForKey:(NSString *)key {
    id str = [self objectForKey:key] ;
    if (!str) str = @"" ;
    if (str  == [NSNull null]) str = @"" ;
    return [str floatValue];
}

-(NSInteger)getIntValueForKey:(NSString *)key {
    id str = [self objectForKey:key] ;
    if (!str) str = @"" ;
    if (str  == [NSNull null]) str = @"" ; 
    return [str integerValue] ;
}

- (BOOL)getTrueOrFalseValueForKey:(NSString *)key {
    NSString *stringValue = [[self getStringValueForKey:key] lowercaseString];
    return [stringValue isEqualToString:@"true"];
}

@end

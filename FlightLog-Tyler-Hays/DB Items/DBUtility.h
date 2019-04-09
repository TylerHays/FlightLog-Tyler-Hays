//
//  DBUtility.h
//  TylerFlightLog
//
//  Created by Tyler Hays on 4/8/19.
//  Copyright © 2019 Tyler Hays. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBUtility : NSObject

+ (long long) executeUpdate:(NSString *)updateQuery withDictionaryArgs:(NSDictionary *)argsDict;
+ (NSMutableArray *) executeQuery:(NSString *)query withArrayArgs:(NSArray *)argsArray;

+ (nonnull NSMutableArray *) executeQuery:(nonnull NSString *)query withDictionaryArgs:(nullable NSDictionary *)argsDict;
@end

NS_ASSUME_NONNULL_END

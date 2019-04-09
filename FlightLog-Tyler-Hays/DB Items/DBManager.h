//
//  DBManager.h
//  TylerFlightLog
//
//  Created by Tyler Hays on 4/7/19.
//  Copyright © 2019 Tyler Hays. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"

@interface DBManager : NSObject

@property (nonatomic, strong) FMDatabaseQueue * databaseQueue;

+ (instancetype)sharedManager;
- (NSInteger) lastInsertId;

@end


//
//  DBUtility.m
//  TylerFlightLog
//
//  Created by Tyler Hays on 4/8/19.
//  Copyright © 2019 Tyler Hays. All rights reserved.
//

#import "DBUtility.h"
#import "DBManager.h"
#import "FMDatabase.h"

@implementation DBUtility

static DBManager *dbManager;

+ (void)initialize {
    if (self == [DBUtility class]) {
        dbManager = [DBManager sharedManager];
        [self executeUpdate:@"PRAGMA foreign_keys=ON" withDictionaryArgs:nil]; //SQLite requires foreign_keys to be turn on every time the connection is open
    }
}

+ (long long) executeUpdate:(NSString *)updateQuery withDictionaryArgs:(NSDictionary *)argsDict {
    
    DBManager * dbManager = [DBManager sharedManager];
    __block long long rowID;
    [dbManager.databaseQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:updateQuery withParameterDictionary:argsDict];
        
        rowID = [db lastInsertRowId];
        if ([db hadError]) {
            NSLog(@"DB Error %d: %@  -- QUERY: %@", [db lastErrorCode], [db lastErrorMessage], updateQuery); }
        
    }];
    return rowID;
}

+ (NSMutableArray *) executeQuery:(NSString *)query withArrayArgs:(NSArray *)argsArray {
    DBManager * dbManager = [DBManager sharedManager];
    
    __block NSMutableArray * result = [NSMutableArray array];
    
    [dbManager.databaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * resultSet = [db executeQuery:query withArgumentsInArray:argsArray];
        
        if ([db hadError]) {
            NSLog(@"DB Error %d: %@", [db lastErrorCode], [db lastErrorMessage]); }
        
        while([resultSet next]) {
            [result addObject:[resultSet resultDictionary]];  //add the result dictionary to the array
        }
    }];
    
    return result;
}

+ (NSMutableArray *) executeQuery:(NSString *)query withDictionaryArgs:(NSDictionary *)argsDict {
    DBManager * dbManager = [DBManager sharedManager];
    
    __block NSMutableArray * result = [NSMutableArray array];
    
    [dbManager.databaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * resultSet = [db executeQuery:query withParameterDictionary:argsDict];
        
        if ([db hadError]) {
            NSLog(@"DB Error %d: %@  -- QUERY: %@", [db lastErrorCode], [db lastErrorMessage], query); }
        
        while([resultSet next]) {
            [result addObject:[resultSet resultDictionary]];  //add the result dictionary to the array
        }
    }];
    
    return result;
}
@end

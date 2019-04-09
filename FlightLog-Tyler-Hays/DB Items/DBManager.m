//
//  DBManager.m
//  TylerFlightLog
//
//  Created by Tyler Hays on 4/7/19.
//  Copyright © 2019 Tyler Hays. All rights reserved.
//

#import "DBManager.h"
#import "FMDatabase.h"

@implementation DBManager

+ (instancetype)sharedManager {
    static id sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    self = [super init];
    if (self) {
        _databaseQueue = [[FMDatabaseQueue alloc] initWithPath:[self databasePath]];
    }
    return self;
}

-(NSInteger) lastInsertId {
    __block NSInteger lastInsertRowId = NSNotFound;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        lastInsertRowId = (NSInteger)[db lastInsertRowId];
    }];
    return lastInsertRowId;
}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL {
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue:[NSNumber numberWithBool: YES]
                                  forKey:NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

- (NSString *)databasePath {
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *dbName = @"app.db";
    
    NSString * documentDbFolderPath = [documentsDirectory stringByAppendingPathComponent:dbName];
    if ( [fileManager fileExistsAtPath: documentDbFolderPath]) {
        return documentDbFolderPath;
    }
    else {
        NSString *sourceFile = [[NSBundle mainBundle] pathForResource:dbName ofType:nil];
        if (![fileManager copyItemAtPath:sourceFile toPath:documentDbFolderPath error:&error]) {
            NSLog(@"[getDBPath] Error copying the db: %@", [error localizedDescription]);
        }
        else {
            [self addSkipBackupAttributeToItemAtURL: [NSURL fileURLWithPath:documentDbFolderPath]];
            NSLog(@"[getDBPath]: Copied the DB from the main bundle.");
        }
    }
    return documentDbFolderPath;
}

    
@end

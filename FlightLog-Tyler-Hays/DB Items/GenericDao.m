//
//  GenericDao.m
//  TylerFlightLog
//
//  Created by Tyler Hays on 4/8/19.
//  Copyright © 2019 Tyler Hays. All rights reserved.
//
//

//Note. Most of this code taking from an old project.

#import <objc/runtime.h>
#import "GenericDao.h"
#import "DBUtility.h"
#import "NSDictionary+NilChecks.h"

NSString * const dbIdString = @"dbId";
NSString * const IdString = @"ID";

@implementation GenericDao


// This function will figure out if it is supposed to be an update or an insert for you.
+ (long)createOrUpdate:(id)object {
    long dbId = [self getDbId:object];
    if (dbId == 0) return [self create:object];
    else return [self update:object];
}

+ (long)create:(id)object {
    NSDictionary *data = [GenericDao loadPropertiesForClass:[object class]];
    
    // I need to get the db maks off the object.  Don't forget.
    
    NSDictionary *dbMask = [GenericDao getColumnNameMasksFromObject:object];
    NSArray *dbIgnore = [GenericDao getPropertyIgnoreListFromObject:object];
    NSString *dbTableName = [GenericDao getDbTableNameFromObject:object];
    
    
    // Variables for processing.
    NSArray *columns = [data allKeys] ;
    NSMutableDictionary * arguments = [[NSMutableDictionary alloc ] init ];
    NSString *sqlProperties = @"" ;
    NSString *sqlValues = @"" ;
    NSInteger counter = 0 ;
    
    for (NSString *column in columns) {
        NSString *columnMask = column;
        
        if ([column isEqualToString:dbIdString]) continue; // we don't want to assign the id manually
        
        if ([dbIgnore containsObject:column]) continue; // in the ignore list
        
        // Check our DB masks
        if ([[dbMask allKeys] containsObject:column]) {
            columnMask = [dbMask valueForKey:column];
        }
        
        // unescape if needed
        NSString *value = [self decodeColumnName:columnMask];
        
        if (counter == 0) {
            sqlProperties = [NSString stringWithFormat:@"%@", columnMask];
            sqlValues = [NSString stringWithFormat:@":%@", value];
        } else {
            sqlProperties = [NSString stringWithFormat:@"%@, %@", sqlProperties, columnMask];
            sqlValues = [NSString stringWithFormat:@"%@, :%@", sqlValues, value];
        }
        
        id prop =[object valueForKey:column];
        if (!prop) {
            //            NSLog(@"[GenericDAO Warning] Found a nil in '%@' when saving a %@", column, [object class]);
            prop = @"" ;
        }
        [arguments setObject:prop forKey:value];
        counter ++ ;
    }
    
    NSString * queryString = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)", dbTableName, sqlProperties, sqlValues] ;
    
    long newId = (long) [DBUtility executeUpdate:queryString withDictionaryArgs:arguments];
    [self setDbId:object withDbId:newId];
    return newId;
}

+ (long)update:(id)object {
    NSDictionary *data = [GenericDao loadPropertiesForClass:[object class]];
    
    // Variables for processing.
    NSArray *columns = [data allKeys];
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    NSString *sqlProperties = @"";
    NSInteger counter = 0;
    NSDictionary *dbMask = [GenericDao getColumnNameMasksFromObject:object];
    NSArray *dbIgnore = [GenericDao getPropertyIgnoreListFromObject:object];
    NSString *dbTableName = [GenericDao getDbTableNameFromObject:object];
    
    long dbId = [self getDbId:object];
    
    for (NSString *column in columns) {
        NSString *columnMask = column;
        
        if ([column isEqualToString:@"dbIgnoreList"]) continue; // we need to ignore the dbIgnoreList
        if ([column isEqualToString:@"dbMasks"]) continue; // we need to ignore the dbIgnoreList
        
        
        if ([dbIgnore containsObject:column]) {
            continue ;
        }
        
        // Check our DB masks
        if ([[dbMask allKeys] containsObject:column]) {
            columnMask = [dbMask valueForKey:column];
        }
        
        // unescape reserved keywords if needed
        NSString *value = [self decodeColumnName:columnMask];
        
        if (counter == 0) {
            sqlProperties = [NSString stringWithFormat:@"%@=:%@", columnMask, value];
        } else {
            sqlProperties = [NSString stringWithFormat:@"%@, %@=:%@", sqlProperties, columnMask, value];
        }
        
        id prop = [object valueForKey:column] ;
        if (!prop) {
            prop = @"" ;
        }
        
        [arguments setObject:prop forKey:value];
        counter++;
    }
    
    NSString * queryString = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE ID=%lu", dbTableName, sqlProperties, dbId];
    
    [DBUtility executeUpdate:queryString withDictionaryArgs:arguments];
    
    return dbId ;
}

#pragma mark - Read Single

+ (id)readObjectOfClass:(Class)class withId:(long)dbId
{
    if (!class) {
        NSLog(@"[Attempt to read from the DB with no class set.]");
        return nil;
    }
    if (!dbId) {
        NSLog(@"[Attempt to read an object from %@ from the DB with no ID set.]", class);
        return nil;
    }
    
    id ob = [[NSClassFromString([GenericDao classStringForClass:class]) alloc ] init ] ;
    
    NSString *dbTableName = [GenericDao getDbTableNameFromObject:ob];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE ID=%lu", dbTableName, dbId];
    NSArray *result = [DBUtility executeQuery:query withDictionaryArgs:nil];
    
    if ([result count] == 0) {
        NSLog(@"Failed to find %@ at DBID#%lu", [GenericDao classStringForClass:class], dbId);
        return nil;
    }
    
    NSDictionary *typeData = [GenericDao loadPropertiesForClass:class];
    NSArray *columns = [typeData allKeys];
    NSDictionary *row = [result objectAtIndex:0]; // We should only get one result.
    
    id object = [self fillObjectOfClass:class WithRowData:row forColumns:columns usingTypeDictonary:typeData];
    
    return object;
}

+ (id)readObjectOfClass:(Class)objectClass withWhereClause:(NSString *)whereClause andValueDictionary:(NSDictionary *)valueDict {
    NSArray *results = [self readListOfObject:objectClass withWhereClause:whereClause andValueDictionary:valueDict];
    
    if (results.count > 0) return [results objectAtIndex:0];
    else return [[objectClass alloc] init];
}

#pragma mark - Read List

+ (NSArray *)readEntireListOfObject:(Class)objectClass {
    id ob = [[NSClassFromString([GenericDao classStringForClass:objectClass]) alloc ] init ] ;
    NSString *dbTableName = [GenericDao getDbTableNameFromObject:ob];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@", dbTableName];
    return [self readListOfObject:objectClass withQuery:query andValueDictionary:nil];
}

+ (NSArray *)readEntireListOfObject:(Class)objectClass WithOrderByClause:(NSString *)orderByClause {
    id ob = [[NSClassFromString([GenericDao classStringForClass:objectClass]) alloc ] init ] ;
    NSString *dbTableName = [GenericDao getDbTableNameFromObject:ob];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY %@", dbTableName, orderByClause];
    return [self readListOfObject:objectClass withQuery:query andValueDictionary:nil];
}

// Use this one if you want to send a where clause without using the fmdb argument dictionary.
+ (NSArray *)readListOfObject:(Class)objectClass withWhereClause:(NSString *)whereClause {
    
    id ob = [[NSClassFromString([GenericDao classStringForClass:objectClass]) alloc ] init ] ;
    
    NSString *dbTableName = [GenericDao getDbTableNameFromObject:ob];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ ", dbTableName, whereClause];
    return [self readListOfObject:objectClass withQuery:query andValueDictionary:nil];
}

+ (NSArray *)readListOfObject:(Class)objectClass withWhereClause:(NSString *)whereClause andWithOrderByClause:(NSString *)orderByClause andValueDictionary:(NSDictionary *)valueDictionary {
    id ob = [[NSClassFromString([GenericDao classStringForClass:objectClass]) alloc ] init ] ;
    
    NSString *dbTableName = [GenericDao getDbTableNameFromObject:ob];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ ORDER BY %@", dbTableName, whereClause, orderByClause];
    return [self readListOfObject:objectClass withQuery:query andValueDictionary:valueDictionary];
}

// Use this method if you want to use the fmdb argument dictionary with your where clause. ( Recommended :D  )
+ (NSArray *)readListOfObject:(Class)objectClass withWhereClause: (NSString *)whereClause andValueDictionary:(NSDictionary *)valueDict {
    id ob = [[NSClassFromString([GenericDao classStringForClass:objectClass]) alloc] init];
    
    NSString *dbTableName = [GenericDao getDbTableNameFromObject:ob];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@", dbTableName, whereClause];
    return [self readListOfObject:objectClass withQuery:query andValueDictionary:valueDict];
}

+ (NSArray *)readListOfObject:(Class)objectClass withQuery:(NSString *)query andValueDictionary:(NSDictionary *)valueDictionary {
    NSArray *rows = [DBUtility executeQuery:query withDictionaryArgs:valueDictionary];
    NSMutableArray *list = [NSMutableArray array];
    NSDictionary *typeData = [GenericDao loadPropertiesForClass:objectClass];
    NSArray *columns = [typeData allKeys];
    for (NSDictionary *row in rows) {
        id object = [self fillObjectOfClass:objectClass WithRowData:row forColumns:columns usingTypeDictonary:typeData];
        [list addObject:object];
    }
    
    return list;
}

+ (NSArray *)readListOfObject:(Class)objectClass withJoinClauses:(NSArray *) joinClauses withWhereClause:(NSString *)whereClause andWithOrderByClause:(NSString *)orderByClause andValueDictionary:(NSDictionary *)valueDictionary {
    
    return [self readListOfObject:objectClass withJoinClauses:joinClauses withWhereClause:whereClause andWithOrderByClause:orderByClause isDistinct:NO andValueDictionary:valueDictionary];
}

+ (NSArray *)readListOfObject:(Class)objectClass withJoinClauses:(NSArray *) joinClauses withWhereClause:(NSString *)whereClause andWithOrderByClause:(NSString *)orderByClause isDistinct:(BOOL)isDistinct andValueDictionary:(NSDictionary *)valueDictionary {
    id ob = [[NSClassFromString([GenericDao classStringForClass:objectClass]) alloc ] init ] ;
    
    NSString *dbTableName = [GenericDao getDbTableNameFromObject:ob];
    NSMutableString *completeJoinString = [NSMutableString stringWithString:@""];
    for (NSString *clause in joinClauses) {
        [completeJoinString appendString: [NSString stringWithFormat:@"JOIN %@ ", clause ]];
    }
    
    NSString * distinct = isDistinct? @"DISTINCT" : @"";
    NSString *orderBy = orderByClause != nil ? [NSString stringWithFormat:@"ORDER BY %@", orderByClause ]: @"";
    NSString *query = [NSString stringWithFormat:@"SELECT %@ %@.* FROM %@ %@ WHERE %@ %@", distinct, dbTableName, dbTableName, completeJoinString,  whereClause, orderBy];
    return [self readListOfObject:objectClass withQuery:query andValueDictionary:valueDictionary];
}

#pragma mark - Remove

// An object must have a db Id assigned in order to delete it.
+ (void)removeObject:(id) object {
    NSInteger dbId;
    if ([object respondsToSelector:NSSelectorFromString(dbIdString)]) {
        dbId = [[object valueForKey:dbIdString] integerValue];
    }
    else {
        dbId = 0;
    }
    
    if (!dbId) {
        NSLog(@"Attempt to delete %@ with no dbId", [self classStringForClass:[object class]]);
        return;
    }
    NSString *dbTableName = [GenericDao getDbTableNameFromObject:object];
    
    NSString *query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE ID=%lu", dbTableName, dbId];
    [DBUtility executeQuery:query withDictionaryArgs:nil];
}

#pragma mark - Helper Functions

+ (NSString *)decodeColumnName:(NSString *)columnMask {
    NSString *value = columnMask;
    if ([columnMask isEqualToString:@"[date]"]) {
        value = @"date";
    }
    else if ([columnMask isEqualToString:@"[order]"]) {
        value = @"order";
    }
    return value;
}

+ (NSDictionary *)makeKeysLowercase:(NSDictionary *)dictionary {
    NSArray *keys = [dictionary allKeys];
    NSMutableDictionary *lowercaseKeys = [NSMutableDictionary dictionary];
    for (NSString *key in keys) {
        NSString *lowercaseKey = [key lowercaseString];
        [lowercaseKeys setObject:[dictionary valueForKey:key] forKey:lowercaseKey];
    }
    return lowercaseKeys;
}

+ (long)getDbId:(id)object {
    if ([object respondsToSelector:NSSelectorFromString(dbIdString)]) {
        return [[object valueForKey:dbIdString] longValue];
    }
    else {
        NSLog(@"%@ doesn't have a dbId!", NSStringFromClass([object class]));
        return 0;
    }
}

+ (void)setDbId:(id)object withDbId:(long)dbId {
    if ([object respondsToSelector:NSSelectorFromString(dbIdString)]) {
        [object setValue:[NSNumber numberWithLong:dbId] forKey:dbIdString];
    }
    else {
        NSLog(@"%@ doesn't have a dbId!", NSStringFromClass([object class]));
        return;
    }
}

+ (NSString *)classStringForClass:(Class)objectClass {
    return [NSString stringWithUTF8String:class_getName(objectClass)];
}

+ (NSArray *)getColumnList:(id)object {
    NSDictionary *results = [GenericDao loadPropertiesForClass:[object class]];
    return [results allKeys] ;
}

//This code is based from http://code.google.com/p/sqlitepersistentobjects/
+(NSDictionary *)loadPropertiesForClass:(Class) class {
    // Recurse up the classes, but stop at NSObject. Each class only reports its own properties, not those inherited from its superclass
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    
    unsigned int propertyCount;
    objc_property_t *propertyList = class_copyPropertyList(class, &propertyCount);
    // Loop through properties and add declarations for the create
    for (int i = 0; i < propertyCount; i++)
    {
        objc_property_t *property = propertyList + i;
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(*property)];
        NSString *attributes = [NSString stringWithUTF8String: property_getAttributes(*property)];
        NSArray *attributeParts = [attributes componentsSeparatedByString:@","];
        
        //ignore the internal properties...
        if ([propertyName hasPrefix:@"_"]) {
            continue;
        }
        
        if (attributeParts != nil)
        {
            if ([attributeParts count] > 0)
            {
                NSString *propertyType = [[attributeParts objectAtIndex:0] substringFromIndex:1];
                //Ignore arrays.
                if ([propertyType hasPrefix:@"@"] ) // Object
                {
                    NSString *className = [propertyType substringWithRange:NSMakeRange(2, [propertyType length] - 3)];
                    if ([className isEqualToString:@"NSMutableArray"] || [className isEqualToString:@"NSArray"]) {
                        continue;
                    }
                }
                
                [properties setObject:propertyType forKey:propertyName]; //lowercase so we can match up on reads
            }
        }
    }
    
    free(propertyList);
    
    return properties;
}

// Objects can have a method for "ignoreColumnList" for ignoring properties
+ (NSArray *)getPropertyIgnoreListFromObject:(id)object {
    NSArray *propertyIgnoreList;
    SEL propertyIgnoreListSelector = NSSelectorFromString(@"propertyIgnoreList");
    if ([object respondsToSelector:propertyIgnoreListSelector]) {
        // Using a function pointer here so ARC knows about return type
        IMP implementation = [object methodForSelector:propertyIgnoreListSelector];
        NSArray * (*propertyIgnoreListFunction)(id, SEL) = (void *)implementation; // make a function pointer that returns an array and takes the object and the selector as arguments
        propertyIgnoreList = propertyIgnoreListFunction(object, propertyIgnoreListSelector);
    }
    else {
        propertyIgnoreList = [NSArray array];
    }
    return propertyIgnoreList;
}

// Objects can have a method for "columnNameMasks" for masking property names to column names
+ (NSDictionary *)getColumnNameMasksFromObject:(id)object {
    NSMutableDictionary *columnNameMasks;
    SEL columnNameMasksSelector = NSSelectorFromString(@"columnNameMasks");
    if ([object respondsToSelector:columnNameMasksSelector]) {
        // Using a function pointer here so ARC knows about return type
        IMP implementation = [object methodForSelector:columnNameMasksSelector]; // implementation details for columnNameMask
        NSMutableDictionary * (*columnNameMasksFunction)(id, SEL) = (void *)implementation; // grab the function pointer to columnNameMask
        columnNameMasks = columnNameMasksFunction(object, columnNameMasksSelector); // call the function
    }
    else {
        columnNameMasks = [NSMutableDictionary dictionary];
    }
    
    // We always want to mask dbId to ID
    [columnNameMasks setValue:IdString forKey:dbIdString];
    // encode reserved sqlite keywords
    [columnNameMasks setValue:@"[date]" forKey:@"date"];
    [columnNameMasks setValue:@"[order]" forKey:@"order"];
    
    return columnNameMasks;
}

+(NSString *)getDbTableNameFromObject:(id)object {
    NSString *tableName = @"" ;
    SEL tableNameMaskSelector = NSSelectorFromString(@"dbTableName");
    if ([object respondsToSelector:tableNameMaskSelector]) {
        // Using a function pointer here so ARC knows about return type
        IMP implementation = [object methodForSelector:tableNameMaskSelector]; // implementation details for columnNameMask
        NSString * (*tableNameMasksFunction)(id, SEL) = (void *)implementation; // grab the function pointer to columnNameMask
        tableName = tableNameMasksFunction(object, tableNameMaskSelector); // call the function
    } else {
        tableName = [GenericDao classStringForClass:[object class]];
    }
    
    return tableName ;
}

+ (id)fillObjectOfClass:(Class)objectClass WithRowData:(NSDictionary *)row forColumns:(NSArray *)columns usingTypeDictonary:(NSDictionary *)types {
    
    id object = [[objectClass alloc] init];
    NSDictionary *dbMasks = [GenericDao getColumnNameMasksFromObject:object];
    NSArray *dbIgnore = [GenericDao getPropertyIgnoreListFromObject:object];
    
    row = [self makeKeysLowercase:row];
    for (NSString *column in columns) {
        NSString *type = [types objectForKey:column];
        NSString *columnMask = @"";
        
        // check ignore list
        if ([dbIgnore containsObject:column]) continue ;
        
        if ([column isEqualToString:@"dbIgnoreList"]) continue; // we need to ignore the dbIgnoreList
        if ([column isEqualToString:@"dbMasks"]) continue; // we need to ignore the dbIgnoreList
        
        // Check our DB masks
        if ([[dbMasks allKeys] containsObject:column]) {
            columnMask = [dbMasks valueForKey:column];
        } else {
            columnMask = column;
        }
        
        if ([columnMask isEqualToString:@"[date]"]) columnMask = @"date";
        if ([columnMask isEqualToString:@"[order]"]) columnMask = @"order";
        
        columnMask = [columnMask lowercaseString]; // need an exact match to pull the value out
        
        // NSInvalidArgumentException
        if ([type isEqualToString: @"i"]) {  // integer
            [object setValue:[NSNumber numberWithLong:[row getIntValueForKey:columnMask]] forKey:column];
        }
        else if ([type isEqualToString: @"f"]) {  // float
            @try {
                [object setValue:[NSNumber numberWithFloat:[[row valueForKey:columnMask] floatValue]] forKey:column];
            }
            @catch (NSException *exception) {
                [object setValue:[NSNumber numberWithFloat:0.0f] forKey:column];
            }
        }
        else if ([type isEqualToString: @"l"]) {  // double
            @try {
                [object setValue:[NSNumber numberWithDouble:[[row valueForKey:columnMask] doubleValue]] forKey:column];
            }
            @catch (NSException *exception) {
                [object setValue:[NSNumber numberWithDouble:0.0f] forKey:column];
            }
        }
        else if ([type isEqualToString: @"b"]) {  // boolean
            @try {
                [object setValue:[NSNumber numberWithBool:[[row valueForKey:columnMask] boolValue]] forKey:column];
            }
            @catch (NSException *exception) {
                [object setValue:[NSNumber numberWithBool:NO] forKey:column];
            }
        }
        else { // object value
            @try {
                
                [object setValue:[row valueForKey:columnMask] forKey:column];
                
            }
            @catch (NSException *exception) {
                [object setValue:@"" forKey:column];
            }
        }
    }
    return object;
}

@end

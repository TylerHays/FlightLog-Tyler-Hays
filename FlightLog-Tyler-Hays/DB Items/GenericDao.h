//
//  GenericDao.h
//  TylerFlightLog
//
//  Created by Tyler Hays on 4/8/19.
//  Copyright © 2019 Tyler Hays. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GenericDao : NSObject

+ (long)create:(id)object;
+ (long)update:(id)object;
+ (long)createOrUpdate:(id)object;
+ (id)readObjectOfClass:(Class)objectClass withId:(long)dbId;
+ (id)readObjectOfClass:(Class)objectClass withWhereClause:(NSString *)whereClause andValueDictionary:(NSDictionary *)valueDict;
+ (NSArray *)readEntireListOfObject:(Class)objectClass;
+ (NSArray *)readListOfObject:(Class)objectClass withWhereClause: (NSString *)whereClause;
+ (NSArray *)readListOfObject:(Class)objectClass withWhereClause: (NSString *)whereClause andWithOrderByClause: (NSString *) orderByClause andValueDictionary:(NSDictionary *)valueDictionary;
+ (NSArray *)readListOfObject:(Class)objectClass withWhereClause: (NSString *)whereClause andValueDictionary:(NSDictionary *)valueDict;
+ (NSArray *)readListOfObject:(Class)objectClass withQuery:(NSString *)query andValueDictionary:(nullable NSDictionary *)valueDictionary;
+ (NSArray *)readListOfObject:(Class)objectClass withJoinClauses:(NSArray *) joinClauses withWhereClause:(NSString *)whereClause andWithOrderByClause:(NSString *)orderByClause andValueDictionary:(NSDictionary *)valueDictionary;
+ (NSArray *)readListOfObject:(Class)objectClass withJoinClauses:(NSArray *) joinClauses withWhereClause:(NSString *)whereClause andWithOrderByClause:(NSString *)orderByClause isDistinct:(BOOL)isDistinct andValueDictionary:(NSDictionary *)valueDictionary;
+ (void)removeObject:(id) object ;
+ (NSDictionary *)loadPropertiesForClass:(Class)objectClass;
+ (NSString *)getDbTableNameFromObject:(id)object ;

@end

NS_ASSUME_NONNULL_END

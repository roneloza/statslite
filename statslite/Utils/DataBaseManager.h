//
//  DataBaseManager.h
//  sgs
//
//  Created by rone loza on 5/24/17.
//  Copyright © 2017 Novit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBaseManager : NSObject

+ (void)createDataBase;
+ (void)updateDataBaseVersion:(NSNumber *)version;

+ (void)createSchemeTableFromClassName:(NSString *)className uniqueFields:(NSArray *)uniqueFields;

/**
 *@brief SELECT SQL
 *@param className Class of Model
 *@param where NSArray of *TableClause
 *@return rows in NSArray of *className
 **/
+ (NSArray *)selectFromClassName:(NSString *)className where:(NSArray *)where;

/**
 *@brief INSERT SQL
 *@param className Class of Model
 *@param keyPairs NSDictionary of key:*NSString value:id
 *@param where NSArray of *TableClause
 *@return affected rows NSInteger
 **/
+ (NSInteger)insertFromClassName:(NSString *)className keyPairs:(NSDictionary *)keyPairs where:(NSArray *)where;

/**
 *@brief DELETE SQL
 *@param className Class of Model
 *@param where NSArray of *TableClause
 *@return affected rows NSInteger
 **/
+ (NSInteger)deleteFromClassName:(NSString *)className where:(NSArray *)where;

@end

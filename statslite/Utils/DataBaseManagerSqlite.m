
//
//  DataBaseManagerSqlite.m
//  sgs
//
//  Created by rone loza on 5/24/17.
//  Copyright © 2017 Novit. All rights reserved.
//

#import "DataBaseManagerSqlite.h"
#import "Constants.h"
#import "Item.h"
#import "TableClause.h"
#import <objC/message.h>
#import <EGO/EGODatabase.h>

#define kEC_DatabaseName @"stas.sqlite"

//#define kELDatabasePath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/elcomercio.sqlite"]
#define kEC_DatabasePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:kEC_DatabaseName]

@implementation DataBaseManagerSqlite

+ (void)createDataBase {
    
    [super createDataBase];
    
//    AppDebugLog(@"%@", kEC_DatabasePath);
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:kEC_DatabasePath]) {
        
        [[NSFileManager defaultManager] createFileAtPath:kEC_DatabasePath contents:nil attributes:nil];
    }
}

+ (void)updateDataBaseVersion:(NSNumber *)version {
    
    [super updateDataBaseVersion:version];
}

+ (void)createSchemeTableFromClassName:(NSString *)className uniqueFields:(NSArray *)uniqueFields {
    
    [super createSchemeTableFromClassName:className uniqueFields:uniqueFields];
    
    EGODatabase *database = [EGODatabase databaseWithPath:kEC_DatabasePath];
    
    NSString *query = [[NSString alloc] initWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (rowid INTEGER PRIMARY KEY);", className];
    
    [database executeQuery:query];
    
    id object = [[NSClassFromString(className) alloc] init];
    
    if ([object conformsToProtocol:@protocol(ObjectInspectRuntime)]) {
        
        for (__weak NSString *propertyName in [object propertyListClassNames]) {
            
            query = [[NSString alloc] initWithFormat:@"ALTER TABLE %@ ADD %@ TEXT DEFAULT NULL;",
                     className, propertyName];
            
            [database executeQuery:query];
        }
    }
    
//    query = [[NSString alloc] initWithFormat:@"CREATE UNIQUE INDEX %@_%@_idx ON %@(%@);",
//             className, [uniqueFields componentsJoinedByString:@"_"], className, [uniqueFields componentsJoinedByString:@","]];
//    
//    [database executeQuery:query];
    
    [database close];
}

+ (NSArray *)selectFromClassName:(NSString *)className where:(NSArray *)where; {
    
    [super selectFromClassName:className where:where];
    
    NSString *whereClause = where.count > 0 ? @"WHERE " : @"";
    
    for (__weak TableClause *clause in where) {
        
        whereClause = [whereClause stringByAppendingString:[[NSString alloc] initWithFormat:@"%@ %@ '%@' %@ ", clause.key, clause.operatorCondition, clause.value, (clause.operatorExpression.length > 0 ? clause.operatorExpression : @"")]];
    }
    
    NSString *query = [[NSString alloc] initWithFormat:@"SELECT * FROM %@ %@ ORDER BY rowid DESC;"
                       , className, whereClause];
    
    
    EGODatabase *database = [EGODatabase databaseWithPath:kEC_DatabasePath];
    EGODatabaseResult *rs = [database executeQuery:query];
    
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:rs.count];
    
    for (EGODatabaseRow *row in rs) {
        
        id object = [[NSClassFromString(className) alloc] init];
        
        if ([object conformsToProtocol:@protocol(ObjectInspectRuntime)]) {
            
            for (__weak NSString *propertyName in [object propertyListClassNames]) {
                
                SEL propertySetSelector = NSSelectorFromString([[NSString alloc] initWithFormat:@"set%@:", [propertyName capitalizedString]]);
                
                if (class_respondsToSelector([object class], propertySetSelector)) {
                    
                    void (*objc_msgSendTypedSetter)(id selfObject, SEL _cmd, id object) = (void*)objc_msgSend;
                    
                    id value = [row stringForColumn:propertyName];
                    
//                    if (value && ![value isKindOfClass:[NSNull class]]) {
                    if (![value isKindOfClass:[NSNull class]]) {
                        
                        objc_msgSendTypedSetter(object, propertySetSelector, value);
                    }
                    
                }
            }
        }
        
        [temp addObject:object];
    }
    
    [database close];
    
    return [temp copy];
}

+ (NSInteger)insertFromClassName:(NSString *)className keyPairs:(NSDictionary *)keyPairs where:(NSArray *)where; {
    
    [super insertFromClassName:className keyPairs:keyPairs where:where];
    
    NSString *whereClause = where.count > 0 ? @"WHERE " : @"";
    
    for (__weak TableClause *clause in where) {
        
        whereClause = [whereClause stringByAppendingString:[[NSString alloc] initWithFormat:@"%@ %@ '%@' %@ ", clause.key, clause.operatorCondition, clause.value, (clause.operatorExpression.length > 0 ? clause.operatorExpression : @"")]];
    }
    
    NSString *updateClause = @"";
    NSString *insertClause = @"";
    
    for (__weak NSString *key in keyPairs) {
        
        __weak NSString *lastKey = [keyPairs.allKeys lastObject];
        
        id value = [keyPairs valueForKey:key];
        
        NSString *valueString = ([value isKindOfClass:[NSNull class]] ? @"NULL" : [[NSString alloc] initWithFormat:@"'%@'", [[value description] stringByReplacingOccurrencesOfString:@"'" withString:@"\""]]);
        
        updateClause = [updateClause stringByAppendingString:[[NSString alloc] initWithFormat:@"%@ = %@ %@", key, valueString, (key == lastKey ? @"" : @",")]];
        
        insertClause = [insertClause stringByAppendingString:[[NSString alloc] initWithFormat:@"%@ %@", valueString, (key == lastKey ? @"" : @",")]];
    }
    
    NSString *query = [[NSString alloc] initWithFormat:@"INSERT OR IGNORE INTO %@(%@) VALUES(%@);"
                             "UPDATE %@ SET %@ %@",
                       className,
                       [keyPairs.allKeys componentsJoinedByString:@","],
                       insertClause,
                       className,
                       updateClause,
                       whereClause];
    
    EGODatabase *database = [EGODatabase databaseWithPath:kEC_DatabasePath];
    
    [database executeQuery:query];
    
    NSInteger affectedRows = [database affectedRows];
    
    return affectedRows;
}

+ (NSInteger)deleteFromClassName:(NSString *)className where:(NSArray *)where; {
    
    [super deleteFromClassName:className where:where];
    
    NSString *whereClause = where.count > 0 ? @"WHERE " : @"";
    
    for (__weak TableClause *clause in where) {
        
        whereClause = [whereClause stringByAppendingString:[[NSString alloc] initWithFormat:@"%@ %@ '%@' %@ ", clause.key, clause.operatorCondition, clause.value, (clause.operatorExpression.length > 0 ? clause.operatorExpression : @"")]];
    }
    
    NSString *query = [[NSString alloc] initWithFormat:@"DELETE FROM %@ %@;",
                       className,
                       whereClause];
    
    EGODatabase *database = [EGODatabase databaseWithPath:kEC_DatabasePath];
    
    [database executeQuery:query];
    
    NSInteger affectedRows = [database affectedRows];
    
    return affectedRows;
}

@end

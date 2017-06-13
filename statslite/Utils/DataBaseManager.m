//
//  DataBaseManager.m
//  sgs
//
//  Created by rone loza on 5/24/17.
//  Copyright © 2017 Novit. All rights reserved.
//

#import "DataBaseManager.h"

@implementation DataBaseManager

+ (void)createDataBase; {
    
}

+ (void)updateDataBaseVersion:(NSNumber *)version; {
    
}

+ (void)createSchemeTableFromClassName:(NSString *)className uniqueFields:(NSArray *)uniqueFields {
    
}

+ (NSArray *)selectFromClassName:(NSString *)className where:(NSArray *)where; {
    
    return nil;
}

+ (NSInteger)insertFromClassName:(NSString *)className keyPairs:(NSDictionary *)keyPairs where:(NSArray *)where; {
    
    return NSNotFound;
}

+ (NSInteger)deleteFromClassName:(NSString *)className where:(NSArray *)where; {
    
    return NSNotFound;
}

@end

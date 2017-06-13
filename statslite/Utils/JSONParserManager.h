//
//  JSONParserManager.h
//  statslite
//
//  Created by Daniel on 11/04/17.
//  Copyright © 2017 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserProfile;

@interface JSONParserManager : NSObject

+ (UserProfile *)userProfile;
//
////+ (NSArray *)paramInputsWithJsonStringData:(NSString *)jsonStringData;
//
//+ (NSArray *)getCheckInQueriesWithJsonData:(NSData *)jsonData;
//
+ (void)updateProfileJSONFromDict:(NSDictionary *)dict;

+ (NSArray *)getArrayDeserializeClassName:(NSString *)className jsonData:(NSData *)jsonData;

+ (id)getObjectDeserializeClassName:(NSString *)className jsonData:(NSData *)jsonData;

@end

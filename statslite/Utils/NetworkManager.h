//
//  NetworkManager.h
//  statslite
//
//  Created by Daniel on 7/04/17.
//  Copyright © 2017 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Network/Network.h>

@interface NetworkManager : NSObject

+ (void)getTokenWithParams:(NSDictionary *)params completion:(void(^)(NSString *newToken, NSError *error))completion;

+ (void)signInUserPassWithParams:(NSDictionary *)params completion:(void(^)(NSInteger responseCodeData, NSError *error))completion;

+ (void)getUserInfoPassWithUserName:(NSString *)userName completion:(void(^)(NSString *jsonStringData, NSError *error))completion;

+ (void)getParamImputsWithCompletion:(void(^)(NSArray *data, NSError *error))completion;

+ (void)checkInUserParams:(NSDictionary *)params completion:(void(^)(NSInteger responseCodeData, NSError *error))completion;

+ (void)getCheckInQueriesWithUserName:(NSString *)userName dateString:(NSString *)dateString completion:(void(^)(NSArray *data, NSError *error))completion;

+ (void)putProfileUserParams:(NSDictionary *)params completion:(void(^)(NSInteger responseCodeData, NSError *error))completion;

+ (void)postLastTrackingGroupWithCompletion:(void(^)(NSString *responseCodeData, NSError *error))completion;

+ (void)postInsertTrackingWithParams:(NSDictionary *)params completion:(void(^)(NSString *responseCodeData, NSError *error))completion;

+ (void)getListTrackingGroupWithUserName:(NSString *)userName completion:(void(^)(NSArray *data, NSError *error))completion;

+ (void)getListDetailTrackingGroupWithUserName:(NSString *)userName trackingGroup:(NSString *)trackingGroup completion:(void(^)(NSArray *data, NSError *error))completion;
@end

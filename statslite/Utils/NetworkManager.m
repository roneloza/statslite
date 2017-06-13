//
//  NetworkManager.m
//  statslite
//
//  Created by Daniel on 7/04/17.
//  Copyright © 2017 Daniel. All rights reserved.
//

#import "NetworkManager.h"
#import "NSString+Utils.h"
#import "JSONParserManager.h"
#import "PreferencesManager.h"
#import "Constants.h"

@implementation NetworkManager

+ (void)getTokenWithParams:(NSDictionary *)params completion:(void(^)(NSString *newToken, NSError *error))completion {
    
    NSString *postBody = [NSString queryStringFromDictionary:params];
    
    NSString *sURL = [NSString stringWithFormat:@"%@/%@", kUrlHost, kUrlApiToken];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:sURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kNetworkDefaultTimeoutSeconds];
    
    request.HTTPMethod = @"POST";
    request.HTTPBody = [postBody dataUsingEncoding:NSUTF8StringEncoding];
    
    [NetworkConnection sendAsynchronousRequest:request completionOnLocalQueue:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSString *newToken = nil;
        
        if (!error && data){
            
            NSDictionary *json = (data ? (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error] : nil);
            newToken = [json valueForKey:kJson_Key_access_token];
            [PreferencesManager setPreferencesString:newToken forKey:kJson_Key_access_token];
        }
        
        if (completion) completion(newToken, error);
    }];
}

+ (void)signInUserPassWithParams:(NSDictionary *)params completion:(void(^)(NSInteger responseCodeData, NSError *error))completion {
    
    NSString *token = [PreferencesManager getPreferencesStringForKey:kJson_Key_access_token];
    
    NSString *postBody = [NSString queryStringFromDictionary:params];
    
    NSString *sURL = [NSString stringWithFormat:@"%@/%@", kUrlHost, kUrlApiUser];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:sURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kNetworkDefaultTimeoutSeconds];
    
    request.HTTPMethod = @"POST";
    request.HTTPBody = [postBody dataUsingEncoding:NSUTF8StringEncoding];
    
    [request addValue:[NSString stringWithFormat:@"%@ %@", kUrlApiHeaderPrefix, token] forHTTPHeaderField:kUrlApiHeaderAuthorization];
    
    [NetworkConnection sendAsynchronousRequest:request completionOnLocalQueue:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSInteger responseCodeData = (data ? [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] integerValue] : NSNotFound);
        
        if (completion) completion(responseCodeData, error);
    }];
}

+ (void)getUserInfoPassWithUserName:(NSString *)userName completion:(void(^)(NSString *jsonStringData, NSError *error))completion {
    
    NSString *token = [PreferencesManager getPreferencesStringForKey:kJson_Key_access_token];
    
    NSString *sURL = [NSString stringWithFormat:@"%@/%@/%@", kUrlHost, kUrlApiUser, userName];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:sURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kNetworkDefaultTimeoutSeconds];
    
    request.HTTPMethod = @"GET";
    
    [request addValue:[NSString stringWithFormat:@"%@ %@", kUrlApiHeaderPrefix, token] forHTTPHeaderField:kUrlApiHeaderAuthorization];
    
    [NetworkConnection sendAsynchronousRequest:request completionOnLocalQueue:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        //NSJSONSerialization *json = (data ? [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error] : nil);
        
        NSString *jsonStringData = (data ? [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] : nil);
        
        if (completion) completion(jsonStringData, error);
        
    }];
}

+ (void)getParamImputsWithCompletion:(void(^)(NSArray *data, NSError *error))completion {
    
    NSString *token = [PreferencesManager getPreferencesStringForKey:kJson_Key_access_token];
    
    NSString *sURL = [NSString stringWithFormat:@"%@/%@", kUrlHost, kUrlApiParams];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:sURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kNetworkDefaultTimeoutSeconds];
    
    request.HTTPMethod = @"GET";
    
    [request addValue:[NSString stringWithFormat:@"%@ %@", kUrlApiHeaderPrefix, token] forHTTPHeaderField:kUrlApiHeaderAuthorization];
    
    [NetworkConnection sendAsynchronousRequest:request completionOnLocalQueue:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        //id json = (data ? [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error] : nil);
        
//        NSString *jsonStringData = (data ? [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] : nil);
        
        NSArray *params = (data && !error ? [JSONParserManager getArrayDeserializeClassName:@"ParamInput" jsonData:data] : nil);
        
        if (completion) completion(params, error);
        
    }];
}

+ (void)checkInUserParams:(NSDictionary *)params completion:(void(^)(NSInteger responseCodeData, NSError *error))completion {
    
    NSString *token = [PreferencesManager getPreferencesStringForKey:kJson_Key_access_token];
    
    NSString *postBody = [NSString queryStringFromDictionary:params];
    
    NSString *sURL = [NSString stringWithFormat:@"%@/%@", kUrlHost, kUrlApiCheckIn];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:sURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kNetworkDefaultTimeoutSeconds];
    
    request.HTTPMethod = @"POST";
    request.HTTPBody = [postBody dataUsingEncoding:NSUTF8StringEncoding];
    
    [request addValue:[NSString stringWithFormat:@"%@ %@", kUrlApiHeaderPrefix, token] forHTTPHeaderField:kUrlApiHeaderAuthorization];
    
    [NetworkConnection sendAsynchronousRequest:request completionOnLocalQueue:^(NSURLResponse *response, NSData *data, NSError *error) {
        
       NSInteger responseCodeData = (data ? [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] integerValue] : NSNotFound);
        
        if (completion) completion(responseCodeData, error);
    }];
}

+ (void)getCheckInQueriesWithUserName:(NSString *)userName dateString:(NSString *)dateString completion:(void(^)(NSArray *data, NSError *error))completion {
    
    NSString *token = [PreferencesManager getPreferencesStringForKey:kJson_Key_access_token];
    
    NSString *sURL = [NSString stringWithFormat:@"%@/%@/%@/%@", kUrlHost, kUrlApiCheckIn, userName, dateString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:sURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kNetworkDefaultTimeoutSeconds];
    
    request.HTTPMethod = @"GET";
    
    [request addValue:[NSString stringWithFormat:@"%@ %@", kUrlApiHeaderPrefix, token] forHTTPHeaderField:kUrlApiHeaderAuthorization];
    
    [NetworkConnection sendAsynchronousRequest:request completionOnLocalQueue:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        //id json = (data ? [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error] : nil);
        
        NSArray *checkInQueries = (!error && data ? [JSONParserManager getArrayDeserializeClassName:@"CheckInItem" jsonData:data] : nil);
        
        if (completion) completion(checkInQueries, error);
        
    }];
}

+ (void)putProfileUserParams:(NSDictionary *)params completion:(void(^)(NSInteger responseCodeData, NSError *error))completion {
    
    NSString *token = [PreferencesManager getPreferencesStringForKey:kJson_Key_access_token];
    
    NSString *postBody = [NSString queryStringFromDictionary:params];
    
    NSString *sURL = [NSString stringWithFormat:@"%@/%@", kUrlHost, kUrlApiProfile];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:sURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kNetworkDefaultTimeoutSeconds];
    
    request.HTTPMethod = @"PUT";
    request.HTTPBody = [postBody dataUsingEncoding:NSUTF8StringEncoding];
    
    [request addValue:[NSString stringWithFormat:@"%@ %@", kUrlApiHeaderPrefix, token] forHTTPHeaderField:kUrlApiHeaderAuthorization];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    [NetworkConnection sendAsynchronousRequest:request completionOnLocalQueue:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSInteger responseCodeData = (data ? [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] integerValue] : NSNotFound);
        
        if (completion) completion(responseCodeData, error);
    }];
}

+ (void)postLastTrackingGroupWithCompletion:(void(^)(NSString *responseCodeData, NSError *error))completion {
    
    NSString *token = [PreferencesManager getPreferencesStringForKey:kJson_Key_access_token];
    
    NSString *sURL = [NSString stringWithFormat:@"%@/%@", kUrlHost, kUrlApiLastTrackingGroup];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:sURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kNetworkDefaultTimeoutSeconds];
    
    request.HTTPMethod = @"POST";
    
    [request addValue:[NSString stringWithFormat:@"%@ %@", kUrlApiHeaderPrefix, token] forHTTPHeaderField:kUrlApiHeaderAuthorization];
//    [request addValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    
    [NetworkConnection sendAsynchronousRequest:request completionOnLocalQueue:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSString *responseCodeData = (!error && data ? [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] : @"-1");
        
        if (completion) completion(responseCodeData, error);
    }];
}

+ (void)postInsertTrackingWithParams:(NSDictionary *)params completion:(void(^)(NSString *responseCodeData, NSError *error))completion {
    
    NSString *token = [PreferencesManager getPreferencesStringForKey:kJson_Key_access_token];
    
    NSString *postBody = [NSString queryStringFromDictionary:params];
    
    NSString *sURL = [NSString stringWithFormat:@"%@/%@", kUrlHost, kUrlApiInsertTracking];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:sURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kNetworkDefaultTimeoutSeconds];
    
    request.HTTPMethod = @"POST";
    request.HTTPBody = [postBody dataUsingEncoding:NSUTF8StringEncoding];
    
    [request addValue:[NSString stringWithFormat:@"%@ %@", kUrlApiHeaderPrefix, token] forHTTPHeaderField:kUrlApiHeaderAuthorization];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [NetworkConnection sendAsynchronousRequest:request completionOnLocalQueue:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSString *responseCodeData = (!error && data ? [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] : @"-1");
        
        if (completion) completion(responseCodeData, error);
    }];
}

+ (void)getListTrackingGroupWithUserName:(NSString *)userName completion:(void(^)(NSArray *data, NSError *error))completion; {
    
    NSString *token = [PreferencesManager getPreferencesStringForKey:kJson_Key_access_token];
    
    NSString *sURL = [NSString stringWithFormat:@"%@/%@/%@", kUrlHost, kUrlApiListTrackingGroup, userName];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:sURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kNetworkDefaultTimeoutSeconds];
    
    request.HTTPMethod = @"GET";
    
    [request addValue:[NSString stringWithFormat:@"%@ %@", kUrlApiHeaderPrefix, token] forHTTPHeaderField:kUrlApiHeaderAuthorization];
    
    [NetworkConnection sendAsynchronousRequest:request completionOnLocalQueue:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSArray *items = (!error && data ? [JSONParserManager getArrayDeserializeClassName:@"TrackingGroupItem" jsonData:data] : nil);
        
        if (completion) completion(items, error);
        
    }];
}

+ (void)getListDetailTrackingGroupWithUserName:(NSString *)userName trackingGroup:(NSString *)trackingGroup completion:(void(^)(NSArray *data, NSError *error))completion; {
    
    NSString *token = [PreferencesManager getPreferencesStringForKey:kJson_Key_access_token];
    
    NSString *sURL = [NSString stringWithFormat:@"%@/%@/%@/%@", kUrlHost, kUrlApiDetailListTrackingGroup, userName, trackingGroup];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:sURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kNetworkDefaultTimeoutSeconds];
    
    request.HTTPMethod = @"GET";
    
    [request addValue:[NSString stringWithFormat:@"%@ %@", kUrlApiHeaderPrefix, token] forHTTPHeaderField:kUrlApiHeaderAuthorization];
    
    [NetworkConnection sendAsynchronousRequest:request completionOnLocalQueue:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSArray *items = (!error && data ? [JSONParserManager getArrayDeserializeClassName:@"TrackingGroupItem" jsonData:data] : nil);
        
        if (completion) completion(items, error);
        
    }];
}

@end

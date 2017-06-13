//
//  JSONParserManager.m
//  statslite
//
//  Created by Daniel on 11/04/17.
//  Copyright © 2017 Daniel. All rights reserved.
//

#import "JSONParserManager.h"
#import "PreferencesManager.h"
#import "UserProfile.h"
#import "Constants.h"
//#import "ParamInput.h"
//#import "CheckInItem.h"
#import "Item.h"
#import <objC/message.h>

@implementation JSONParserManager

+ (NSArray *)getArrayDeserializeClassName:(NSString *)className jsonData:(NSData *)jsonData {
    
    NSMutableArray *objects = nil;
    
    if (jsonData) {
        
        id json = (jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil] : nil);
        
        if ([json isKindOfClass:[NSArray class]]) {
            
            objects = [[NSMutableArray alloc] initWithCapacity:[json count]];
            
            for (__weak NSDictionary *item in json) {
                
                id object = [[NSClassFromString(className) alloc] init];
                
                if ([object conformsToProtocol:@protocol(ObjectInspectRuntime)]) {
                    
                    for (__weak NSString *propertyName in [object propertyListClassNames]) {
                        
                        SEL propertySelector = NSSelectorFromString([[NSString alloc] initWithFormat:@"set%@:", [propertyName capitalizedString]]);
                        
                        if (class_respondsToSelector([object class], propertySelector)) {
                            
                            id value = [item valueForKey:propertyName];
                            
                            if (![value isKindOfClass:[NSNull class]] && value) {
                                
                                void (*objc_msgSendTyped)(id selfObject, SEL _cmd, id object) = (void*)objc_msgSend;
                                
                                objc_msgSendTyped(object, propertySelector, value);
                            }
                        }
                        
                    }
                }
                
                [objects addObject:object];
            }
        }
    }
    
    return objects;
}

+ (id)getObjectDeserializeClassName:(NSString *)className jsonData:(NSData *)jsonData {
    
    id object = nil;
    
    if (jsonData) {
        
        id json = (jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil] : nil);
        
        if ([json isKindOfClass:[NSDictionary class]]) {
            
            object = [[NSClassFromString(className) alloc] init];
            
            if ([object conformsToProtocol:@protocol(ObjectInspectRuntime)]) {
                
                for (__weak NSString *propertyName in [object propertyListClassNames]) {
                    
                    SEL propertySelector = NSSelectorFromString([[NSString alloc] initWithFormat:@"set%@:", [propertyName capitalizedString]]);
                    
                    if ((class_respondsToSelector([object class], propertySelector))) {
                        
                        id value = [json valueForKey:propertyName];
                        
                        //                        if (value && ![value isKindOfClass:[NSNull class]]) {
                        if (![value isKindOfClass:[NSNull class]]) {
                            
                            void (*objc_msgSendTyped)(id selfObject, SEL _cmd, id object) = (void*)objc_msgSend;
                            
                            objc_msgSendTyped(object, propertySelector, value);
                        }
                    }
                }
            }
        }
    }
    
    return object;
}

+ (void)updateProfileJSONFromDict:(NSDictionary *)dict {
    
    NSString *jsonString = [PreferencesManager getPreferencesStringForKey:kJson_Key_user_info];
    
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *json = (NSMutableDictionary *)(data ? [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil] mutableCopy] : nil);
    
    for (NSString *key in dict.allKeys) {
     
        [json setValue:[dict valueForKey:key] forKey:key];
    }
    
    
    NSData *newJsonData = [NSJSONSerialization dataWithJSONObject:json
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    
    NSString *newJsonStringData = (newJsonData ? [[NSString alloc] initWithData:newJsonData encoding:NSUTF8StringEncoding] : nil);
    
    [PreferencesManager setPreferencesString:newJsonStringData forKey:kJson_Key_user_info];
    
}


+ (UserProfile *)userProfile {

    NSString *jsonString = [PreferencesManager getPreferencesStringForKey:kJson_Key_user_info];
    
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    UserProfile *userProfile = [[JSONParserManager class] getObjectDeserializeClassName:@"UserProfile" jsonData:data];
    
    return userProfile;
}

@end

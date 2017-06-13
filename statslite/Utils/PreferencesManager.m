//
//  PreferencesManager.m
//  statslite
//
//  Created by Daniel on 10/04/17.
//  Copyright © 2017 Daniel. All rights reserved.
//

#import "PreferencesManager.h"

@implementation PreferencesManager

+ (NSDictionary *)getDictionaryFromPlist:(NSString *)plist {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:plist ofType:@"plist"];
    
    NSDictionary *plistDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    return plistDictionary;
}

+ (void)setPreferencesString:(NSString *)value forKey:(NSString *)key {
    
    if (value && key) {
    
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void)setPreferencesBOOL:(BOOL)value forKey:(NSString *)key {
    
    if (key) {
        
        [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (BOOL)getPreferencesBOOLForKey:(NSString *)key {
    
    return (key ? [[NSUserDefaults standardUserDefaults] boolForKey:key] : NO);
}

+ (NSString *)getPreferencesStringForKey:(NSString *)key {
    
    NSString *value = (key ? [[NSUserDefaults standardUserDefaults] stringForKey:key] : nil);
    
    return value;
    
}

+ (void)setPreferencesDictionary:(NSDictionary *)value forKey:(NSString *)key {
    
    if (value && key) {
        
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NSDictionary *)getPreferencesDictionaryForKey:(NSString *)key {
    
    NSDictionary *value = (key ? [[NSUserDefaults standardUserDefaults] dictionaryForKey:key] : nil);
    
    return value;
}

+ (void)addPhotoCheckIn:(NSString *)value forKey:(NSString *)key {

    if (value && key) {
        
        NSString *keyDict = @"checkInPhotoDict";
        
        NSMutableDictionary *checkInPhotoDict = (key ? [[[NSUserDefaults standardUserDefaults] dictionaryForKey:keyDict] mutableCopy] : nil);
        
        if (!checkInPhotoDict) {
            
            checkInPhotoDict = [[NSMutableDictionary alloc] initWithCapacity:1];
            
        }
        
        [checkInPhotoDict setValue:value forKey:key];
        
        [[NSUserDefaults standardUserDefaults] setObject:[checkInPhotoDict copy] forKey:keyDict];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NSString *)getPhotoCheckInForKey:(NSString *)key {
    
    NSString *value = nil;
    
    if (key) {
        
        NSString *keyDict = @"checkInPhotoDict";
        
        NSMutableDictionary *checkInPhotoDict = (key ? [[[NSUserDefaults standardUserDefaults] dictionaryForKey:keyDict] mutableCopy] : nil);
        
        value = [checkInPhotoDict valueForKey:key];
        
    }
    
    return value;
}

@end

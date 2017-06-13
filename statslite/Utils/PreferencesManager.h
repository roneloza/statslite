//
//  PreferencesManager.h
//  statslite
//
//  Created by Daniel on 10/04/17.
//  Copyright © 2017 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PreferencesManager : NSObject

+ (NSDictionary *)getDictionaryFromPlist:(NSString *)plist;
+ (void)setPreferencesString:(NSString *)value forKey:(NSString *)key;
+ (NSString *)getPreferencesStringForKey:(NSString *)key;
+ (void)setPreferencesDictionary:(NSDictionary *)value forKey:(NSString *)key;
+ (NSDictionary *)getPreferencesDictionaryForKey:(NSString *)key;


+ (void)setPreferencesBOOL:(BOOL)value forKey:(NSString *)key;
+ (BOOL)getPreferencesBOOLForKey:(NSString *)key;


//+ (void)addPhotoCheckIn:(NSString *)value forKey:(NSString *)key;
//+ (NSString *)getPhotoCheckInForKey:(NSString *)key;

@end

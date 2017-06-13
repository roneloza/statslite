//
//  FireBaseManager.h
//  statslite
//
//  Created by rone shender loza aliaga on 4/15/17.
//  Copyright © 2017 eeeccom.elcomercio. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kFIREBASE_PHOTO_FOLDER @"photo"
#define kFIREBASE_CHECKIN_FOLDER @"marcaciones"

@interface FireBaseManager : NSObject

+ (void)uploadPathFile:(NSString *)pathFile fromData:(NSData *)data completion:(void (^)(NSError *error))completion;

+ (void)downloadPathFile:(NSString *)pathFile completion:(void (^)(NSData *data, NSError *error))completion;

@end
